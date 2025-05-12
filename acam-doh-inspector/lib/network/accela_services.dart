import 'dart:convert';
import 'dart:io';
import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/user_management/user_management_utils.dart';
import 'package:aca_mobile_app/utility/secure_storage.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aca_mobile_app/settings/constants.dart';

enum DocumentEntityType { record, inspection, checklistItem }

class AccelaServiceManager {
  static Dio getDioInstance(
      {bool addLogger = false, bool addContentTypeHeaderJson = true, bool isAuthenticate = false, bool externalRequest = false, String token = ""}) {
    String baseUrl = Constants.baseUrl;
    if (Constants.connectionMethod == ConnectionMethods.gateway) {
      baseUrl = Constants.gatewayUrl;
    } else if (Constants.connectionMethod == ConnectionMethods.cloud) {
      baseUrl = Constants.apiUrl;
    }
    if (externalRequest) {
      baseUrl = "";
    }
    if (isAuthenticate) {
      baseUrl = Constants.authUrl;
    }
    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    );

    var dio = Dio(options);

    // (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    //   HttpClient client = HttpClient();
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };
    if (Constants.enableCertificatePinning && (Platform.isAndroid || Platform.isIOS)) {
      dio.interceptors.add(CertificatePinningInterceptor(allowedSHAFingerprints: [Constants.shaFingerPrint]));
    }
    if (addLogger && Constants.enableMessageLog) {
      // dio.interceptors.add(LogInterceptor());
      dio.interceptors.add(LogInterceptor(requestHeader: true, responseHeader: true, responseBody: true, requestBody: true));
    }
    // dio.interceptors.add(LogInterceptor(requestHeader: true, responseHeader: true, responseBody: true, requestBody: true));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (addContentTypeHeaderJson) {
        options.headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        };
      }
      if (!isAuthenticate && Constants.connectionMethod == ConnectionMethods.cloud) {
        options.headers = <String, String>{
          'Authorization': token,
          'Content-Type': 'application/json',
          'x-accela-appid': Constants.clientId,
          'x-accela-appsecret': Constants.clientSecret,
        };
      } else {
        options.queryParameters['token'] = token;
      }
      if (Constants.connectionMethod == ConnectionMethods.gateway && !externalRequest) {
        options.headers['AccessKey'] = Constants.gatewayAccessKey;
      }

      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioException e, handler) {
      logNetwork('HTTP Exception: $e');
      return handler.next(e);
    }));

    return dio;
  }

  static dynamic tryDecodeErrorJson(String errorJson) {
    try {
      return json.decode(errorJson);
    } catch (e) {
      return null;
    }
  }

  static String? extractHostname(String message) {
    RegExp exp = RegExp(r"Failed host lookup: '([^']+)'");
    Match? match = exp.firstMatch(message);
    if (match != null && match.groupCount > 0) {
      return match.group(1);
    }
    return null;
  }

  static String getErrorMessage(DioException e, {String prefix = ""}) {
    String errorMessage = "An error has occurred.".tr();
    try {
      if (e.response?.data is String) {
        dynamic errorJson = tryDecodeErrorJson(e.response?.data);
        if (errorJson != null) {
          errorMessage = errorJson["message"] ?? errorJson["error"] ?? errorJson["error_description"] ?? e.response?.data;
        } else {
          errorMessage = e.response?.data;
        }
      } else {
        if (e.error is SocketException) {
          errorMessage = (e.error as SocketException).message;
          String? extractedHostname = extractHostname(errorMessage);
          if (extractedHostname != null) {
            errorMessage = "We couldn't reach the server\n\n$extractedHostname\n\nPlease check your connection or try again later.";
          }
        } else {
          errorMessage = e.response?.data?["message"] ?? e.response?.data?.message ?? e.error?.toString() ?? e.error?.toString() ?? e.message;
        }
      }
    } catch (e) {}

    return "$prefix${prefix.isNotEmpty ? " " : ""}$errorMessage";
  }

  static Future<String> getToken({required bool getAnonymousToken}) async {
    String token = '';

    if (getAnonymousToken) {
      token = await SecureStorage.read('${Constants.uniqueEnvironmentKey}-anonymousToken') ?? '';
      if (token.isEmpty) {
        await authenticateAnonymous();
        token = await SecureStorage.read('${Constants.uniqueEnvironmentKey}-anonymousToken') ?? '';
      }
    } else {
      token = await SecureStorage.read(UserManageUtils.tokenString) ?? '';
    }
    return token;
  }

  static Future<bool> isAuthenticated({required bool getAnonymousToken}) async {
    String token = await getToken(getAnonymousToken: getAnonymousToken);
    return token.isNotEmpty;
  }

  static Future<ActionObject<String>> authenticate(String userName, String password, {bool isCitizen = true}) async {
    if (Constants.connectionMethod == ConnectionMethods.gateway || Constants.connectionMethod == ConnectionMethods.direct) {
      return await authenticateDirect(userName, password, isCitizen: isCitizen);
    } else if (Constants.connectionMethod == ConnectionMethods.cloud) {
      return await authenticateCloud(userName, password);
    }

    throw Exception("Invalid Connection Method");
  }

  static Future<ActionObject<String>> authenticateDirect(String userName, String password, {bool isCitizen = true}) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (!result && Constants.checkForInternetConnection) {
      return ActionObject<String>(success: false, message: "Please make sure you are connected to the internet.".tr());
    }
    Dio dio = getDioInstance(addLogger: true);
    try {
      Response response =
          await dio.post(isCitizen ? '/citizen/auth' : '/agency/auth', data: {'agency': Constants.agency, 'userId': userName, 'password': password});

      if (response.statusCode != 200) {
        return ActionObject<String>(success: false, message: response.statusMessage ?? "Failed to Authenticate");
      }
      Map<String, dynamic> result = response.data;
      if (response.statusCode != 200) {
        return ActionObject<String>(success: false, message: result['message'] ?? "Failed to Authenticate");
      } else {
        return ActionObject<String>(success: true, message: '', content: result['result']);
      }
    } on DioException catch (e) {
      return ActionObject<String>(success: false, message: getErrorMessage(e));
    } on Exception catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    } catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    }
  }

  static Future<ActionObject<String>> authenticateCloud(String userName, String password) async {
    Dio dio = getDioInstance(addContentTypeHeaderJson: false, isAuthenticate: true);
    try {
      String requestData = "agency_name=${Constants.agency}&username=$userName&password=$password&environment=${Constants.environment}"
          "&client_id=${Constants.clientId}&client_secret=${Constants.clientSecret}&scope=${Constants.scope}&grant_type=${Constants.grantType}";
      Response response = await dio.post(
        '',
        data: requestData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode != 200) {
        return ActionObject<String>(success: false, message: response.statusMessage ?? "Failed to Authenticate");
      }
      Map<String, dynamic> result = response.data;
      if (response.statusCode != 200) {
        return ActionObject<String>(success: false, message: result['message'] ?? "Failed to Authenticate");
      } else {
        return ActionObject<String>(success: true, message: '', content: result['access_token']);
      }
    } on DioException catch (e) {
      return ActionObject<String>(success: false, message: getErrorMessage(e));
    } on Exception catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    } catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    }
  }

  static Future<ActionObject<String>> authenticateWithCredentials(String userName, String password, {bool isCitizen = true}) async {
    ActionObject<String> authResult = await authenticate(userName, password, isCitizen: isCitizen);

    if (authResult.success) {
      await SecureStorage.write(UserManageUtils.tokenString, authResult.content ?? "");
    }

    return authResult;
  }

  static Future<ActionObject<String>> authenticateAnonymous() async {
    String anonymousUsername = "anonymous";
    String anonymousPassword = "anonymous";

    if (Constants.connectionMethod == ConnectionMethods.cloud || true) {
      anonymousUsername = Constants.anonymousUser;
      anonymousPassword = Constants.anonymousPassword;
    }

    ActionObject<String> authResult = await authenticate(anonymousUsername, anonymousPassword);

    if (authResult.success) {
      await SecureStorage.write("${Constants.uniqueEnvironmentKey}-anonymousToken", authResult.content ?? "");
    }

    return authResult;
  }

  static Future<ActionObject<Map<String, dynamic>>> externalRequest(String url) async {
    Dio dio = getDioInstance(externalRequest: true);
    ActionObject<Map<String, dynamic>> output = ActionObject<Map<String, dynamic>>(success: false, message: "");
    try {
      Response? response = await dio.get(url);
      Map<String, dynamic> result = response.data;
      output = ActionObject<Map<String, dynamic>>(success: true, message: "", content: result, isAppError: false);
    } on DioException catch (e) {
      output = ActionObject<Map<String, dynamic>>(success: false, message: getErrorMessage(e));
    } on Exception catch (e) {
      output = ActionObject<Map<String, dynamic>>(success: false, message: e.toString());
    } catch (e) {
      output = ActionObject<Map<String, dynamic>>(success: false, message: e.toString());
    }

    return output;
  }

  static Future<ActionObject<dynamic>> emseRequest(String action, Map parameter, {bool useAnonymousToken = false}) async {
    String token = await getToken(getAnonymousToken: useAnonymousToken);

    if (token.isEmpty) {
      logNetwork("Action $action failed, no token");
      return ActionObject<dynamic>(success: false, message: 'Not Authenticated');
    }

    Dio dio = getDioInstance(token: token);

    parameter['action'] = action;
    parameter['appName'] = Constants.appName;
    parameter['connectionMethod'] = Constants.connectionMethod.toString().replaceAll("ConnectionMethods.", "");

    String locale = await SecureStorage.read('locale') ?? '';
    if (locale == "ar") {
      parameter["lang"] = "ar_AE";
    } else {
      parameter["lang"] = "en_US";
    }
    Response? response;
    ActionObject<dynamic> output = ActionObject<dynamic>(success: false, message: "");
    String requestData = jsonEncode(parameter);
    try {
      if (Constants.connectionMethod == ConnectionMethods.cloud) {
        response = await dio.post(
          '/scripts/${Constants.scriptName}',
          data: parameter,
        );
      } else {
        response = await dio.post('/scripts/${Constants.scriptName}', data: requestData);
      }

      Map<String, dynamic> result = response.data;
      if (result['status'] != 200) {
        String errorMessage = result['message'] ?? 'Rest API Error';
        output = ActionObject<dynamic>(success: false, message: errorMessage);
      } else {
        var res = result['result'];
        output = ActionObject<dynamic>(success: res['success'], message: res['message'], content: res['content'], isAppError: res['isAppError'] ?? false);
      }
    } on DioException catch (e) {
      output = ActionObject<dynamic>(success: false, message: getErrorMessage(e));
    } on Exception catch (e) {
      output = ActionObject<dynamic>(success: false, message: e.toString());
    } catch (e) {
      output = ActionObject<dynamic>(success: false, message: e.toString());
    } finally {
      logNetwork(
          '------------------------------------$action call /scripts/${Constants.scriptName} Success: ${output.success}, Anonymous: $useAnonymousToken------------------------------------');
      logNetwork('$action request:');
      logNetwork(requestData);
      logNetwork('$action response: ${output.message}');
      logNetwork(jsonEncode(response?.data));
      logNetwork('------------------------------------$action end------------------------------------');
    }

    if (!output.success) {
      //   errorProvider.setError(output.message);
    }

    return output;
  }

  static Future<ActionObject<String>> getReport(String reportName, String reportId, String module, dynamic parameter, ProgressCallback progressCallback,
      {bool useAnonymousToken = false}) async {
    String token = await getToken(getAnonymousToken: useAnonymousToken);

    if (token.isEmpty) {
      return ActionObject<String>(success: false, message: "Not Authenticated.");
    }

    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory directory = await Directory('${appDocDirectory.path}/dir').create(recursive: true);

    Dio dio = getDioInstance(token: token, addLogger: true);
    var dateStr = Utility.dateToString(DateTime.now(), 'yyyyMMddHHmmss');

    var reportFileName = 'report$reportName$reportId$dateStr.pdf'.replaceAll(" ", "");

    var fullPath = '${directory.path}/$reportFileName';
    if (Platform.isWindows) {
      fullPath = reportFileName;
    }

    try {
      await dio.download('/reports/$reportId${module.isNotEmpty ? '?module=$module' : ''}', fullPath,
          onReceiveProgress: progressCallback, options: Options(method: "POST"), data: parameter);
    } on DioException catch (e) {
      logNetwork(getErrorMessage(e));
      return ActionObject<String>(success: false, message: getErrorMessage(e), content: '');
    } on Exception catch (e) {
      logNetwork(e.toString());
      return ActionObject<String>(success: false, message: e.toString());
    } catch (e) {
      logNetwork(e.toString());
      return ActionObject<String>(success: false, message: e.toString());
    }
    return ActionObject<String>(success: true, message: "", content: fullPath);
  }

  static Future<ActionObject<String>> downloadAttachment(String documentNo, String saveFileName,
      {bool useAnonymousToken = false, ProgressCallback? progressCallback}) async {
    String url = '/documents/$documentNo/download';
    return await downloadDocument(url, saveFileName, progressCallback: progressCallback, useAnonymousToken: useAnonymousToken);
  }

  static Future<ActionObject<String>> downloadDocument(String url, String saveFileName,
      {bool useAnonymousToken = false, dynamic parameter, String method = "GET", ProgressCallback? progressCallback}) async {
    String token = await getToken(getAnonymousToken: useAnonymousToken);

    if (token.isEmpty) {
      return ActionObject<String>(success: false, message: 'Not Authenticated');
    }

    Dio dio = getDioInstance(token: token, addLogger: true);

    Directory appDocDirectory = Platform.isIOS ? await getTemporaryDirectory() : await getApplicationDocumentsDirectory();

    Directory directory = await Directory('${appDocDirectory.path}/dir').create(recursive: true);

    var dateStr = Utility.dateToString(DateTime.now(), 'yyyyMMddHHmmss');
    // separte into file name and file extension
    var fileExtension = saveFileName.split('.').last;
    saveFileName = saveFileName.replaceAll(".$fileExtension", "");

    saveFileName = '$saveFileName$dateStr.$fileExtension';
    saveFileName = saveFileName.replaceAll(" ", "");

    var fullPath = '${directory.path}/$saveFileName';
    if (Platform.isWindows) {
      fullPath = saveFileName;
    }

    logNetwork('Full Path: $fullPath');

    try {
      await dio.download('/$url', fullPath, onReceiveProgress: progressCallback, options: Options(method: method), data: parameter);
    } on DioException catch (e) {
      return ActionObject<String>(success: false, message: getErrorMessage(e), content: '');
    } on Exception catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    } catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    }
    return ActionObject<String>(success: true, message: "", content: fullPath);
  }

  static Future<ActionObject<dynamic>> deleteDocument(String recordId, String documentNumber, {bool useAnonymousToken = false}) async {
    String token = await getToken(getAnonymousToken: useAnonymousToken);

    if (token.isEmpty) {
      return ActionObject<dynamic>(success: false, message: "Not Authenticated.");
    }

    Dio dio = getDioInstance(token: token, addLogger: true);

    try {
      //   if (Constants.connectionMethod == ConnectionMethods.cloud) {
      //     response = await dio.delete('/records/$recordId/documents/$documentNumber');
      //   } else {
      //     response = await dio.delete('/records/$recordId/documents/$documentNumber?token=$token');
      //   }
      //   Response response = await dio.delete('/records/$recordId/documents/$documentNumber?token=$token');
      Response? response = await dio.delete('/records/$recordId/documents/$documentNumber');

      Map<String, dynamic> result = response.data;
      if (result['status'] != 200) {
        String errorMessage = "${"Failed to Delete Document".tr()}, ${"error".tr()}: ${result['message']}";
        return ActionObject<dynamic>(success: false, message: errorMessage);
      }
    } on DioException catch (e) {
      return ActionObject<dynamic>(success: false, message: getErrorMessage(e, prefix: "${"Failed to Delete Document".tr()}, ${"error".tr()}: "));
    } on Exception catch (e) {
      return ActionObject<dynamic>(success: false, message: e.toString());
    } catch (e) {
      return ActionObject<dynamic>(success: false, message: e.toString());
    }

    return ActionObject<dynamic>(success: true, message: 'Document Deleted Successfully'.tr());
  }

  static Future<ActionObject<dynamic>> deleteEntityDocument(DocumentEntityType entityType, String documentNumber,
      {String? recordId, int? inspectionId, bool useAnonymousToken = false}) async {
    String token = await getToken(getAnonymousToken: useAnonymousToken);

    if (token.isEmpty) {
      return ActionObject<dynamic>(success: false, message: "Not Authenticated.");
    }

    if (entityType == DocumentEntityType.inspection) {
      if (inspectionId == null) {
        return ActionObject<dynamic>(success: false, message: "Inspection Id is required.");
      }
    } else {
      if (recordId == null) {
        return ActionObject<dynamic>(success: false, message: "Record Id is required.");
      }
    }

    Dio dio = getDioInstance(token: token, addLogger: true);

    try {
      //   if (Constants.connectionMethod == ConnectionMethods.cloud) {
      //     response = await dio.delete('/records/$recordId/documents/$documentNumber');
      //   } else {
      //     response = await dio.delete('/records/$recordId/documents/$documentNumber?token=$token');
      //   }
      //   Response response = await dio.delete('/records/$recordId/documents/$documentNumber?token=$token');
      String url = '/records/$recordId/documents/$documentNumber';
      if (entityType == DocumentEntityType.inspection) {
        url = '/inspections/$inspectionId/documents/$documentNumber';
      }
      Response? response = await dio.delete(url);

      Map<String, dynamic> result = response.data;
      if (result['status'] != 200) {
        String errorMessage = "${"Failed to Delete Document".tr()}, ${"error".tr()}: ${result['message']}";
        return ActionObject<dynamic>(success: false, message: errorMessage);
      }
    } on DioException catch (e) {
      return ActionObject<dynamic>(success: false, message: getErrorMessage(e, prefix: "${"Failed to Delete Document".tr()}, ${"error".tr()}: "));
    } on Exception catch (e) {
      return ActionObject<dynamic>(success: false, message: e.toString());
    } catch (e) {
      return ActionObject<dynamic>(success: false, message: e.toString());
    }

    return ActionObject<dynamic>(success: true, message: 'Document Deleted Successfully'.tr());
  }

  static Future<ActionObject> uploadEntityDocument(DocumentEntityType entityType, File file,
      {String? recordId,
      int? inspectionId,
      String? checklistId,
      String? checklistItemId,
      bool useAnonymousToken = false,
      String group = "",
      String category = "",
      String description = "",
      Function(int, int)? sendProgress}) async {
    String token = await getToken(getAnonymousToken: useAnonymousToken);

    if (token.isEmpty) {
      return ActionObject<String>(success: false, message: "Not Authenticated.", content: '');
    }

    if (entityType == DocumentEntityType.inspection) {
      if (inspectionId == null) {
        return ActionObject<dynamic>(success: false, message: "Inspection Id is required.");
      }
    } else if (entityType == DocumentEntityType.record) {
      if (recordId == null) {
        return ActionObject<dynamic>(success: false, message: "Record Id is required.");
      }
    } else if (entityType == DocumentEntityType.checklistItem) {
      if (inspectionId == null || checklistId == null || checklistItemId == null) {
        return ActionObject<dynamic>(success: false, message: "Inspection Id, Checklist Id and Checklist Item Id are required.");
      }
    }

    Dio dio = getDioInstance(addContentTypeHeaderJson: false, token: token, addLogger: true);
    String docNumber = '';

    try {
      var formData = FormData.fromMap({
        'fileInfo': jsonEncode([
          {"fileName": basename(file.path), "fileType": lookupMimeType(file.path), "description": description}
        ]),
        'uploadedFile': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      category = category.replaceAll("(", "%28");
      category = category.replaceAll(")", "%29");
      category = category.replaceAll("+", "%2B");

      String url = '/records/$recordId/documents?group=$group&category=$category';
      if (entityType == DocumentEntityType.inspection) {
        url = '/inspections/$inspectionId/documents/';
      } else if (entityType == DocumentEntityType.checklistItem) {
        url = '/inspections/$inspectionId/checklists/$checklistId/checklistItems/$checklistItemId/documents?group=$group&category=$category';
      }

      var response = await dio.post(
        url,
        data: formData,
        onSendProgress: sendProgress,
      );

      Map<String, dynamic> result = response.data;
      if (result['status'] != 200) {
        String errorMessage = "${"Failed to Upload Document".tr()}, ${"error".tr()}: ${result['message']}";
        return ActionObject<String>(success: false, message: errorMessage, content: '');
      } else {
        docNumber = result["result"][0]["id"].toString();
      }
    } on DioException catch (e) {
      return ActionObject<dynamic>(success: false, message: getErrorMessage(e, prefix: "${"Failed to Upload Document".tr()}, ${"error".tr()}: "));
    } on Exception catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    } catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    }

    return ActionObject<String>(success: true, message: "Document Uploaded Successfully".tr(), content: docNumber);
  }

  static Future<ActionObject> uploadDocument(String recordId, File file, String group, String category, String description, Function(int, int) sendProgress,
      {bool useAnonymousToken = false}) async {
    String token = await getToken(getAnonymousToken: useAnonymousToken);

    if (token.isEmpty) {
      return ActionObject<String>(success: false, message: "Not Authenticated.", content: '');
    }

    Dio dio = getDioInstance(addContentTypeHeaderJson: false, addLogger: true);
    String docNumber = '';

    try {
      var formData = FormData.fromMap({
        'fileInfo': jsonEncode([
          {"fileName": basename(file.path), "fileType": lookupMimeType(file.path), "description": description}
        ]),
        'uploadedFile': await MultipartFile.fromFile(file.path, filename: basename(file.path))
      });

      category = category.replaceAll("(", "%28");
      category = category.replaceAll(")", "%29");
      category = category.replaceAll("+", "%2B");

      var response = await dio.post(
        '/records/$recordId/documents?token=$token&group=$group&category=$category',
        data: formData,
        onSendProgress: sendProgress,
      );

      Map<String, dynamic> result = response.data;
      if (result['status'] != 200) {
        String errorMessage = "${"Failed to Upload Document".tr()}, ${"error".tr()}: ${result['message']}";
        return ActionObject<String>(success: false, message: errorMessage, content: '');
      } else {
        docNumber = result["result"][0]["id"].toString();
      }
    } on DioException catch (e) {
      return ActionObject<dynamic>(success: false, message: getErrorMessage(e, prefix: "${"Failed to Upload Document".tr()}, ${"error".tr()}: "));
    } on Exception catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    } catch (e) {
      return ActionObject<String>(success: false, message: e.toString());
    }

    return ActionObject<String>(success: true, message: "Document Uploaded Successfully".tr(), content: docNumber);
  }

  static Future<Map<String, dynamic>> registerACAPublicUser(Map<String, dynamic> parameter) async {
    Dio dio = getDioInstance(addLogger: true);
    try {
      Response response = await dio.post('/citizens/register', data: parameter);

      Map<String, dynamic> result = response.data;
      if (result['status'] != 200) {
        return {'success': false, 'message': '${result['message']}'};
      } else {
        return {'success': true, 'message': ''};
      }
    } on Exception catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  static logNetwork(String msg) {
    if (Constants.enableMessageLog) {
      debugPrint(msg);
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
