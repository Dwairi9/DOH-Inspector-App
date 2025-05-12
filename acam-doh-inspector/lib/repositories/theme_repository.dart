import 'package:aca_mobile_app/network/accela_services.dart';

class ThemeRepository {
  static Future<Map<String, dynamic>?> getTheme(bool useAnonymousToken) async {
    var result = await AccelaServiceManager.emseRequest('getAppTheme', {}, useAnonymousToken: useAnonymousToken);
    if (result.success) {
      return result.content;
    }
    return null;
  }
}
