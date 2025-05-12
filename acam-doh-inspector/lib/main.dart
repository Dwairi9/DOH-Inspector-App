import 'dart:io';
import 'dart:ui';
import 'package:aca_mobile_app/network/accela_services.dart';
import 'package:aca_mobile_app/providers/error_provider.dart';
import 'package:aca_mobile_app/settings/constants.dart';
import 'package:aca_mobile_app/user_management/user_management_utils.dart';
import 'package:flutter/material.dart';
import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await el.EasyLocalization.ensureInitialized();
  if (!Constants.enableMessageLog) {
    el.EasyLocalization.logger.enableBuildModes = [];
    el.EasyLocalization.logger.enableLevels = [];
  }
  HttpOverrides.global = MyHttpOverrides();

  debugPrintGlobalKeyedWidgetLifecycle = true;
  runApp(
    el.EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('en', 'GB'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale("en"),
        child: const MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _jailbroken = false;
  @override
  void initState() {
    super.initState();
    checkJailBroken();
  }

  checkJailBroken() async {
    bool jailBroken = false;
    if ((Platform.isAndroid || Platform.isIOS) && Constants.enableRootDetect) {
      try {
        jailBroken = await FlutterJailbreakDetection.jailbroken;
      } catch (e) {
        jailBroken = true;
      }
    }

    setState(() {
      _jailbroken = jailBroken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          final themeNotifier = ref.watch(themeProvider);

          return MaterialApp(
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            scrollBehavior: MyCustomScrollBehavior(),
            scaffoldMessengerKey: _scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            builder: (BuildContext context, Widget? child) {
              return Directionality(
                  textDirection: context.locale.languageCode == "ar" ? TextDirection.rtl : TextDirection.ltr,
                  child: Builder(
                    builder: (BuildContext context) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaleFactor: 1.0,
                        ),
                        child: child ?? Container(),
                      );
                    },
                  ));
            },
            // home: WebViewTest(),
            home: Consumer(builder: (context, ref, child) {
              ref.listen<ErrorProvider>(errorStateNotifierProvider, (oldError, newError) {
                if (newError.errorMessage.isNotEmpty) {
                  //   Utility.showAlert(context, "Test", newError.errorMessage);
                }
              });
              if (_jailbroken) {
                return Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Center(
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 160),
                                child: const Image(
                                  image: AssetImage("assets/doh_logo.png"),
                                ))),
                        const SizedBox(height: 40),
                        Center(
                            child: Platform.isAndroid
                                ? const Text(
                                    "Security Alert: This app is not available on rooted devices. Please access this app on a non-rooted device for full functionality.")
                                : const Text(
                                    "Security Alert: This app is not available on jailbroken devices. Please access this app on a non-jailbroken device for full functionality.")),
                      ],
                    ),
                  ),
                );
              }
              return UserManageUtils.getLoginScreen();
            }),
            theme: themeNotifier.currentTheme,
            routes: const {},
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
