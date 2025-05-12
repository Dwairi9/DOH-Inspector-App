// class ConnectionMethods {
//   static const int CONNECTION_DIRECT = 1;
//   static const int CONNECTION_GATEWAY = 2;
//   static const int CONNECTION_CLOUD = 3;
// }

enum ConnectionMethods { direct, gateway, cloud }

enum MapProviderType { google, arcgis }

enum AppMode { aca, inspector }

class Constants {
  static const String acaScriptName = "INCLUDE_ACAM2";
  static const String anonymousPassword = 'anonymous';
  static const String anonymousUser = 'anonymous';

  static const String apiUrl = 'https://apis.accela.com/v4';

  // Cloud
  static const String authUrl = 'https://auth.accela.com/oauth2/token';

  // DOH Cloud
//   static const ConnectionMethods connectionMethod = ConnectionMethods.gateway;
//   static const String environment = "CONFIG";
//   static const String fontFamily = "Cairo";
//   static const String gatewayAccessKey = '2D60166087D546D8B45B5FF53398739C';
//   static const String gatewayUrl = 'https://addoh.northeurope.cloudapp.azure.com:443/gateway/apis/v4';
// //   static const String gatewayUrl = 'https://acaopttest.doh.gov.ae/gateway/apis/v4';
//   static const String grantType = 'password';
//   static const String inspectorScriptName = "ACCMOB_INSPECTOR";
//   static const MapProviderType mapProviderType = MapProviderType.arcgis;
//   static const AppMode appMode = AppMode.inspector;
//   static const String appName = "INSPECTOR";
//   static const String baseUrl = 'http://addoh.northeurope.cloudapp.azure.com:3080/apis/v4';
//   static const String clientId = 'com.accela.inspector';
//   static const String clientSecret = '839ffae0ee244cb4b558f252ca84524c';
//   static const String scope = 'run_emse_script create_inspection_checklist_item_document documents create_record_documents create_inspection_documents';
//   static const String agency = "ADDOH";

  // DOH OPT TEST
//   static const ConnectionMethods connectionMethod = ConnectionMethods.gateway;
//   static const String environment = "CONFIG";
//   static const String fontFamily = "Cairo";
//   static const String gatewayAccessKey = '706066BABD3B4809AF66D571009F8E20';
//   static const String gatewayUrl = 'https://acaopttest.doh.gov.ae/gateway/apis/v4';
//   static const String grantType = 'password';
//   static const String inspectorScriptName = "ACCMOB_INSPECTOR";
//   static const MapProviderType mapProviderType = MapProviderType.arcgis;
//   static const AppMode appMode = AppMode.inspector;
//   static const String appName = "INSPECTOR";
//   static const String baseUrl = 'http://10.90.135.51:3080/apis/v4';
//   static const String clientId = '';
//   static const String clientSecret = '';
//   static const String scope = 'run_emse_script create_inspection_checklist_item_document documents create_record_documents create_inspection_documents';
//   static const String agency = "ADDOH";
//   static const String shaFingerPrint = "FC:71:DB:C4:25:B4:D3:2E:AF:0C:6C:52:99:0C:C0:D8:FF:89:CF:31:26:70:45:BF:09:36:FD:B2:91:41:54:E3";

  // DOH TEST
  static const ConnectionMethods connectionMethod = ConnectionMethods.gateway;
  static const String environment = "CONFIG";
  static const String fontFamily = "Cairo";
  static const String gatewayAccessKey = '29A60D1B13E643A7AF7E9B4FFE217478';
  static const String gatewayUrl = 'https://acatest.doh.gov.ae/gateway/apis/v4';
  static const String grantType = 'password';
  static const String inspectorScriptName = "ACCMOB_INSPECTOR";
  static const MapProviderType mapProviderType = MapProviderType.arcgis;
  static const AppMode appMode = AppMode.inspector;
  static const String appName = "INSPECTOR";
  static const String baseUrl = 'http://10.198.25.135:3080/apis/v4';
  static const String clientId = '';
  static const String clientSecret = '';
  static const String scope = 'run_emse_script create_inspection_checklist_item_document documents create_record_documents create_inspection_documents';
  static const String agency = "ADDOH";
  static const String shaFingerPrint = "FC:71:DB:C4:25:B4:D3:2E:AF:0C:6C:52:99:0C:C0:D8:FF:89:CF:31:26:70:45:BF:09:36:FD:B2:91:41:54:E3";

  static String scriptName = appMode == AppMode.aca ? acaScriptName : inspectorScriptName;

  // DOH PROD
//   static const ConnectionMethods connectionMethod = ConnectionMethods.gateway;
//   static const String environment = "CONFIG";
//   static const String fontFamily = "Cairo";
//   static const String gatewayAccessKey = 'C0C789F535384DA19E665E2A17C9AF39';
// //   static const String gatewayUrl = 'https://addoh.northeurope.cloudapp.azure.com:443/gateway/apis/v4';
//   static const String gatewayUrl = 'https://es.doh.gov.ae/gateway/apis/v4';
//   static const String grantType = 'password';
//   static const String inspectorScriptName = "ACCMOB_INSPECTOR";
//   static const MapProviderType mapProviderType = MapProviderType.arcgis;
//   static const AppMode appMode = AppMode.inspector;
//   static const String appName = "INSPECTOR";
//   static const String baseUrl = 'http://10.198.22.91:3080/apis/v4';
//   static const String clientId = 'com.accela.inspector';
//   static const String clientSecret = '839ffae0ee244cb4b558f252ca84524c';
//   static const String scope = 'run_emse_script create_inspection_checklist_item_document documents create_record_documents create_inspection_documents';
//   static const String agency = "ADDOH";
//   static const String shaFingerPrint = "FC:71:DB:C4:25:B4:D3:2E:AF:0C:6C:52:99:0C:C0:D8:FF:89:CF:31:26:70:45:BF:09:36:FD:B2:91:41:54:E3";
//
//   static String scriptName = appMode == AppMode.aca ? acaScriptName : inspectorScriptName;

  static String uniqueEnvironmentKey =
      "${Constants.agency}-${Constants.appName}-${Constants.environment}-${Constants.version}-${Constants.connectionMethod.name}-${Constants.appMode.name}";
  static String uniqueEnvironmentNoVersionKey =
      "${Constants.agency}-${Constants.appName}-${Constants.environment}-${Constants.connectionMethod.name}-${Constants.appMode.name}";
  static const String engineVersion = "0.38";
  static const String version = "1.02";
  static const bool isDebug = false;
  static const bool enableArabic = false;
  static const bool enableRootDetect = true;
  static const bool enableMessageLog = true;
  static const bool loadTheme = false;
  static const bool enableCertificatePinning = false;
  static const bool checkForInternetConnection = false;
  static const bool enableBiometrics = false;
}
