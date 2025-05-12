import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/Widgets/background_notch_widget.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:aca_mobile_app/user_management/providers/user_management_provider.dart';
import 'package:aca_mobile_app/settings/constants.dart';
import 'package:aca_mobile_app/user_management/user_management_utils.dart';
import 'package:aca_mobile_app/utility/utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(userManagementProvider);
    ref.listen<UserManagementProvider>(userManagementProvider, (oldValue, newValue) {
      if (newValue.getAuthenticatedSuccessfullyViaBiometrics()) {
        login(context, newValue, true);
      }
    });
    return LoginForm(provider, () => login(context, provider, false));
  }

  void login(BuildContext context, UserManagementProvider loginProvider, bool bioMetrics) async {
    var actionObject = await loginProvider.login(bioMetrics);
    if (!context.mounted) {
      return;
    }
    if (actionObject.success) {
      //   UserProfile userProfile = actionObject.content!;
      if (!bioMetrics) {
        await askForBiometricsLogin(context, loginProvider);
      }

      if (!context.mounted) {
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserManageUtils.getDashboardScreen()),
      );
    } else {
      Utility.showAlert(context, 'Unable to login'.tr(), actionObject.message.tr());
    }
  }

  askForBiometricsLogin(BuildContext context, UserManagementProvider provider) async {
    if (await provider.askedForBiometrics()) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    await Utility.showOptionsDialog(context, "Biometrics Login".tr(), "Do you want to use biometrics for future login?".tr(), [
      ActionButton(
          title: 'Cancel'.tr(),
          callback: (context) {
            provider.setAskedForBiometrics(true);
            Navigator.of(context).pop();
          }),
      ActionButton(
          title: 'Okay'.tr(),
          callback: (context) async {
            provider.setAskedForBiometrics(true);
            await provider.saveBiometricsLogin();
            if (!context.mounted) {
              return;
            }
            Navigator.of(context).pop();
          }),
    ]);
  }
}

class LoginForm extends ConsumerWidget {
  const LoginForm(this.provider, this.loginPressed, {super.key});
  final UserManagementProvider provider;
  final Function loginPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              const BackgroundNotch(),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (Constants.enableArabic)
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: InkWell(
                                        onTap: () {
                                          if (context.locale.languageCode == "ar") {
                                            context.setLocale(const Locale("en"));
                                            Utility.setLanguage("en");
                                          } else {
                                            context.setLocale(const Locale("ar"));
                                            Utility.setLanguage("ar");
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            "oppositeLanguage".tr(),
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).primaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  // const SizedBox(height: 70),
                                  Expanded(
                                    child: Center(
                                        child: themeNotifier.getLogoDocumentNbr() != null && provider.hasAnonymousToken() && Constants.appMode == AppMode.aca
                                            ? ConstrainedBox(
                                                constraints: const BoxConstraints(maxHeight: 120),
                                                child: Utility.getImageFromAccela(themeNotifier.getLogoDocumentNbr()!, provider.getAnonymousToken(),
                                                    width: 120, height: 120, boxFit: BoxFit.fitHeight))
                                            : ConstrainedBox(
                                                constraints: const BoxConstraints(maxHeight: 160),
                                                child: const Image(
                                                  image: Constants.agency == 'ADDOH' ? AssetImage("assets/doh_logo.png") : AssetImage('assets/acclogo.png'),
                                                ))),
                                  ),
                                  // const SizedBox(height: 32),
                                  Text("Username".tr(), style: Theme.of(context).textTheme.headlineMedium),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: provider.nameController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(8),
                                      hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: themeNotifier.light4Color),
                                      labelStyle: Theme.of(context).textTheme.labelMedium,
                                      errorText: provider.usernameError ? "field is required".tr() : null,
                                      prefixIcon: Icon(Icons.supervisor_account,
                                          color: provider.usernameError ? Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color : null),
                                      hintText: 'enter user name'.tr(),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    "Password".tr(),
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    obscureText: !provider.showPassword,
                                    controller: provider.passwordController,
                                    enableInteractiveSelection: false,
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          provider.setShowPassword(!provider.showPassword);
                                        },
                                        child: Icon(
                                          provider.showPassword ? Icons.visibility_off : Icons.visibility,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(8),
                                      hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: themeNotifier.light4Color),
                                      labelStyle: Theme.of(context).textTheme.labelMedium,
                                      errorText: provider.passwordError ? "field is required".tr() : null,
                                      prefixIcon: Icon(Icons.lock_outline,
                                          color: provider.passwordError ? Theme.of(context).inputDecorationTheme.errorBorder?.borderSide.color : null),
                                      hintText: 'enter password'.tr(),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: provider.rememberPassword,
                                        onChanged: (value) => {
                                          provider.setRememberPassword(value ?? false),
                                        },
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Remember Password'.tr(),
                                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints.tightFor(height: 56),
                                          child: ElevatedButton(
                                            onPressed: provider.loading ? null : () => {loginPressed()},
                                            child: provider.loading
                                                ? const SizedBox(
                                                    height: 25,
                                                    width: 25,
                                                    child: CircularProgressIndicator(),
                                                  )
                                                : Text(
                                                    'LOGIN'.tr(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      if (Constants.enableBiometrics) ...[
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        IconButton(
                                          padding: const EdgeInsets.all(0),
                                          icon: Icon(
                                            Icons.fingerprint,
                                            color: Theme.of(context).primaryColor,
                                            size: 60,
                                          ),
                                          onPressed: () async {
                                            var hasBiometricsLogin = await provider.hasBiometricsLogin();
                                            if (hasBiometricsLogin) {
                                              await provider.loginViaBiometrics();
                                            } else {
                                              provider.setAskedForBiometrics(false);
                                              if (!context.mounted) {
                                                return;
                                              }
                                              Utility.showAlert(context, "Biometrics Login".tr(), "Biometrics login is not enabled".tr());
                                            }
                                          },
                                        )
                                      ],
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: Row(
                          children: [
                            InkWell(
                                child:
                                    Text('Privacy Policy'.tr(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).primaryColor)),
                                onTap: () => launchUrl(
                                      Uri.parse("privacyPolicyUrl".tr()),
                                    )),
                            const SizedBox(width: 16),
                            InkWell(
                              child: Text(
                                "${Constants.appMode == AppMode.aca ? 'acam' : 'Version'} ${Constants.version}",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
