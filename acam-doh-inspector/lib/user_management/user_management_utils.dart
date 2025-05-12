import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/screens/dohaudits/audit_visitors_dashboard_screen.dart';
import 'package:aca_mobile_app/settings/constants.dart';
import 'package:aca_mobile_app/user_management/screens/login_screen.dart';
import 'package:aca_mobile_app/utility/secure_storage.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UserManageUtils {
  static String tokenString = "${Constants.uniqueEnvironmentNoVersionKey}-token";
  static String userNameString = "${Constants.uniqueEnvironmentNoVersionKey}-login-username";
  static String passwordString = "${Constants.uniqueEnvironmentNoVersionKey}-login-password";
  static String userNameBiometricString = "${Constants.uniqueEnvironmentNoVersionKey}-biometrics-login-username";
  static String passwordBiometricString = "${Constants.uniqueEnvironmentNoVersionKey}-biometrics-login-password";
  static String askedForBiometricString = "${Constants.uniqueEnvironmentNoVersionKey}-asked-biometric";
  static String hasBiometricsLoginString = "${Constants.uniqueEnvironmentNoVersionKey}-biometrics-login";

  static Widget getLoginScreen() {
    return const LoginScreen();
  }

  static Widget getDashboardScreen() {
    return const AuditVisitorsDashboardScreen();
  }

  static Future<bool> logoutConfirm(BuildContext context) async {
    await Utility.showOptionsDialog(context, 'Logout'.tr(), 'Are you sure you want to logout?'.tr(), [
      ActionButton(
          title: 'Cancel'.tr(),
          callback: (context) {
            Navigator.of(context).pop();
          }),
      ActionButton(
          title: 'Okay'.tr(),
          callback: (context) {
            logout(context);
          }),
    ]);
    return false;
  }

  static void logout(BuildContext context) async {
    await SecureStorage.write(tokenString, '');
    await SecureStorage.delete(tokenString);

    if (context.mounted) {
      Navigator.popUntil(context, (route) => false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => getLoginScreen()),
      );
    }
  }
}
