import 'package:aca_mobile_app/data_models/user_profile.dart';
import 'package:aca_mobile_app/settings/constants.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// enum InspectorUserType { citizen, inspector }

class UserSessionProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  String inspectorUserType = "aca";
  String _token = "";
  String _anonymousToken = "";
  String userId = "";
  bool _isLoggedIn = false;
  List<String> allowedFileTypes = [
    "avi",
    "flv",
    "mkv",
    "mov",
    "mp4",
    "mpeg",
    "webm",
    "wmv",
    "bmp",
    "gif",
    "jpeg",
    "jpg",
    "png",
    "xls",
    "xlsx",
    "doc",
    "docx",
    "pdf"
  ];

  setUserId(String id) {
    userId = id.trim().toUpperCase();
    notifyListeners();
  }

  setUserType(String userType) {
    inspectorUserType = userType;
    notifyListeners();
  }

  setProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    _isLoggedIn = true;
    notifyListeners();
  }

  setToken(String token) {
    _token = token;
    notifyListeners();
  }

  setAnonymousToken(String token) {
    _anonymousToken = token;
    notifyListeners();
  }

  logout() {
    _userProfile = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  isLoggedIn() {
    return _isLoggedIn;
  }

  String getToken() {
    return _token;
  }

  String getAnonymousToken() {
    return _anonymousToken;
  }

  String getFullName() {
    return "${Utility.capitalizeFirstLetter(_userProfile?.firstName ?? "")} ${Utility.capitalizeFirstLetter(_userProfile?.lastName ?? "")}";
  }

  String getDisplayName() {
    var displayName = _userProfile?.displayName ?? "";
    if (displayName.isEmpty) {
      displayName = getFullName().trim();
    }

    return displayName;
  }

  String getEmail() {
    return _userProfile?.email ?? "";
  }

  String getInitials() {
    String initials = "AU";
    if ((_userProfile?.firstName ?? "").isNotEmpty) {
      initials = _userProfile?.firstName[0].toUpperCase() ?? "";
    }
    if ((_userProfile?.lastName ?? "").isNotEmpty) {
      initials += _userProfile?.lastName[0].toUpperCase() ?? "";
    }

    return initials;
  }

  String? getAccelaDocumentUrl(String documentNo) {
    String? imgUrl;

    if (documentNo.isEmpty) {
      return imgUrl;
    }
    if (Constants.connectionMethod == ConnectionMethods.cloud) {
      imgUrl = '${Constants.apiUrl}/documents/$documentNo/download';
    } else if (Constants.connectionMethod == ConnectionMethods.gateway) {
      imgUrl = '${Constants.gatewayUrl}/documents/$documentNo/download?token=$getToken()';
    } else {
      imgUrl = '${Constants.baseUrl}/documents/$documentNo/download?token=$getToken()';
    }
    return imgUrl;
  }

  Map<String, String> getAccelaRequestHeaders() {
    Map<String, String> headers = {};
    if (Constants.connectionMethod == ConnectionMethods.cloud) {
      headers = {
        'Authorization': getToken(),
        'x-accela-appid': Constants.clientId,
        'x-accela-appsecret': Constants.clientSecret,
      };
    } else if (Constants.connectionMethod == ConnectionMethods.gateway) {
      headers = {
        'AccessKey': Constants.gatewayAccessKey,
      };
    }
    return headers;
  }
}

final userSessionProvider = ChangeNotifierProvider((ref) => UserSessionProvider());
