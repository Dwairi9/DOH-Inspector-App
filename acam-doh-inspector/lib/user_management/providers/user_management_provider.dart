import 'dart:io';

import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/data_models/user_profile.dart';
import 'package:aca_mobile_app/network/accela_services.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/settings/constants.dart';
import 'package:aca_mobile_app/user_management/providers/user_session_provider.dart';
import 'package:aca_mobile_app/user_management/user_management_utils.dart';
import 'package:aca_mobile_app/utility/secure_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class UserManagementProvider extends ChangeNotifier {
  UserManagementProvider(this.ref) {
    if (Constants.loadTheme) {
      loadToken();
    }
    initLoginInfo();
    loginViaBiometrics();
  }

  String? anonymousToken;
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordError = false;
  final ChangeNotifierProviderRef ref;
  bool rememberPassword = false;
  bool usernameError = false;
  bool showPassword = false;
  bool authenticatedSuccessfullyViaBiometrics = false;
  bool hasBiometrics = false;
  String biometricUsername = "";
  String customToken = "";
  String customUsername = "";

  loadToken() async {
    anonymousToken = await AccelaServiceManager.getToken(getAnonymousToken: true);
    notifyListeners();
    var notifier = ref.read(themeProvider);
    notifier.loadTheme(useAnonymousToken: true);
  }

  bool getAuthenticatedSuccessfullyViaBiometrics() {
    if (authenticatedSuccessfullyViaBiometrics) {
      authenticatedSuccessfullyViaBiometrics = false;
      return true;
    }
    return false;
  }

  bool hasAnonymousToken() {
    return anonymousToken?.isNotEmpty ?? false;
  }

  String getAnonymousToken() {
    return anonymousToken ?? "";
  }

  setRememberPassword(bool remember) {
    rememberPassword = remember;
    notifyListeners();
  }

  setShowPassword(bool show) {
    showPassword = show;
    notifyListeners();
  }

  setLoading(loading) {
    if (this.loading != loading) {
      this.loading = loading;
      notifyListeners();
    }
  }

  canSubmit() {
    return !loading;
  }

  initLoginInfo() async {
    nameController.text = await SecureStorage.read(UserManageUtils.userNameString) ?? "";
    passwordController.text = await SecureStorage.read(UserManageUtils.passwordString) ?? "";

    if (nameController.text.isNotEmpty) {
      rememberPassword = true;
    }

    hasBiometrics = await hasBiometricsLogin();
    biometricUsername = await SecureStorage.read(UserManageUtils.userNameBiometricString) ?? "";
    notifyListeners();
  }

  Future<bool> hasBiometricsLogin() async {
    if (!Constants.enableBiometrics) {
      return false;
    }
    return await SecureStorage.readBool(UserManageUtils.hasBiometricsLoginString);
  }

  // if there's a username and password stored in the biometrics, and the username matches the one entered, update the password
  Future<void> verifyAndUpdateBiometrics(String username, String password) async {
    if (!await hasBiometricsLogin()) {
      return;
    }

    String biometricUsername = await SecureStorage.read(UserManageUtils.userNameBiometricString) ?? "";
    String biometricPassword = await SecureStorage.read(UserManageUtils.passwordBiometricString) ?? "";

    if (username.toLowerCase() == biometricUsername.toLowerCase() && password != biometricPassword) {
      await SecureStorage.write(UserManageUtils.userNameBiometricString, username);
      await SecureStorage.write(UserManageUtils.passwordBiometricString, password);
      await SecureStorage.writeBool(UserManageUtils.hasBiometricsLoginString, true);
    }
  }

  Future<bool> loginViaBiometrics() async {
    if (!Constants.enableBiometrics) {
      return false;
    }
    if (!await hasBiometricsLogin()) {
      return false;
    }

    return await authenticateBiometrics(true);
  }

  Future<bool> authenticateBiometrics(bool forLogin) async {
    if (!await bioMetricsEnabled()) {
      return false;
    }
    var username = await SecureStorage.read(UserManageUtils.userNameBiometricString) ?? "";
    var localAuth = LocalAuthentication();
    var result = await localAuth.authenticate(localizedReason: "${"Please authenticate to login with".tr()} $username");
    if (result && forLogin) {
      authenticatedSuccessfullyViaBiometrics = true;
      notifyListeners();
    }
    return result;
  }

  saveBiometricsLogin() async {
    var authenticated = await authenticateBiometrics(false);
    if (!authenticated) {
      return;
    }
    await SecureStorage.write(UserManageUtils.userNameBiometricString, nameController.text);
    await SecureStorage.write(UserManageUtils.passwordBiometricString, passwordController.text);
    await SecureStorage.writeBool(UserManageUtils.hasBiometricsLoginString, true);
  }

  removeBiometricsLogin() async {
    await SecureStorage.delete(UserManageUtils.userNameBiometricString);
    await SecureStorage.delete(UserManageUtils.passwordBiometricString);
    await SecureStorage.writeBool(UserManageUtils.hasBiometricsLoginString, false);
    hasBiometrics = false;
    biometricUsername = "";
    notifyListeners();
  }

  Future<bool> askedForBiometrics() async {
    if (!(await bioMetricsEnabled())) {
      return true;
    }
    return await SecureStorage.readBool(UserManageUtils.askedForBiometricString);
  }

  setAskedForBiometrics(bool asked) async {
    await SecureStorage.writeBool(UserManageUtils.askedForBiometricString, asked);
  }

  Future<bool> bioMetricsEnabled() async {
    if (!Constants.enableBiometrics) {
      return false;
    }
    var localAuth = LocalAuthentication();

    if (Platform.isIOS || Platform.isAndroid) {
      return await localAuth.canCheckBiometrics;
    }

    return false;
  }

  saveLoginInfo() async {
    if (rememberPassword) {
      await SecureStorage.write(UserManageUtils.userNameString, nameController.text);
      await SecureStorage.write(UserManageUtils.passwordString, passwordController.text);
    } else {
      await SecureStorage.delete(UserManageUtils.userNameString);
      await SecureStorage.delete(UserManageUtils.passwordString);
      nameController.text = "";
      passwordController.text = "";
    }
  }

  String getUsername() {
    return nameController.text;
  }

  String getPassword() {
    return passwordController.text;
  }

  Future<ActionObject<UserProfile>> login(bool bioMetrics) async {
    setLoading(true);

    if (customToken.isNotEmpty) {
      setLoading(false);
      await SecureStorage.write(UserManageUtils.tokenString, customToken);
      return loginSucces(customToken, customUsername);
    }

    passwordError = false;
    usernameError = false;

    var username = nameController.text;
    var password = passwordController.text;

    if (bioMetrics) {
      username = await SecureStorage.read(UserManageUtils.userNameBiometricString) ?? "";
      password = await SecureStorage.read(UserManageUtils.passwordBiometricString) ?? "";
    }

    usernameError = username.isEmpty;
    passwordError = password.isEmpty;

    if (username.isEmpty || password.isEmpty) {
      setLoading(false);
      return ActionObject(success: false, message: "Please enter username and password".tr());
    }
    var result = await AccelaServiceManager.authenticateWithCredentials(username, password, isCitizen: Constants.appMode == AppMode.aca);
    setLoading(false);
    if (result.success) {
      if (!bioMetrics) {
        await verifyAndUpdateBiometrics(username, password);
      }

      return loginSucces(result.content ?? "", username);
    } else {
      return ActionObject(success: false, message: result.message.tr());
    }
  }

  Future<ActionObject<UserProfile>> loginSucces(String token, String username) async {
    final userSessionNotifier = ref.read(userSessionProvider);
    userSessionNotifier.setToken(token);
    var userProfileRes = await AccelaServiceManager.emseRequest("getUserProfile", {});
    if (!userProfileRes.success) {
      if (userProfileRes.message.contains("FID")) {
        return ActionObject(
            success: false,
            message:
                "Your account does not currently have the necessary permission to log in. Please contact your administrator to grant you access. (FID Permission)"
                    .tr());
      }
      return ActionObject(success: false, message: userProfileRes.message.tr());
    }
    var userProfile = UserProfile.fromMap({"firstName": username});
    if (userProfileRes.success) {
      userProfile = UserProfile.fromMap(userProfileRes.content);
    }
    userSessionNotifier.setProfile(userProfile);
    userSessionNotifier.setUserId(username);

    if (!userProfile.needChangePassword) {
      await saveLoginInfo();
    }

    return ActionObject<UserProfile>(success: true, message: "", content: userProfile);
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

final userManagementProvider = ChangeNotifierProvider<UserManagementProvider>((ref) => UserManagementProvider(ref));
