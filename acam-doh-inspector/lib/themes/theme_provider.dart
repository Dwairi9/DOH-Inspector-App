import 'dart:convert';

import 'package:aca_mobile_app/repositories/theme_repository.dart';
import 'package:aca_mobile_app/settings/constants.dart';
import 'package:aca_mobile_app/themes/default_themes.dart';
import 'package:aca_mobile_app/utility/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utility/theme_util.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData currentTheme = ThemeData.light();

  final String key = "${Constants.uniqueEnvironmentKey}-theme4";
  String? logoDocumentNbr;
  var themeData = {};

  var defaultTheme = AcamDefaultTheme.getDefaultTheme();

  ThemeNotifier() {
    loadInitTheme();
  }

  Future<Map<String, dynamic>> getCurrentTheme() async {
    Map<String, dynamic> themeData = {
      "theme": defaultTheme,
    };

    if (Constants.loadTheme) {
      var themeDataString = await SecureStorage.read(key);
      if (themeDataString != null) {
        themeData = jsonDecode(themeDataString);
      }
    }

    return themeData;
  }

  loadInitTheme() async {
    var appTheme = await getCurrentTheme();
    // var theme = ThemeDecoder.decodeThemeData(appTheme["theme"]) ?? ThemeData();
    var theme = decodeTheme(appTheme["theme"]);
    themeData = appTheme["theme"];
    logoDocumentNbr = appTheme["logoDocumentNbr"];
    currentTheme = theme;
    currentTheme = setThemeFont(currentTheme);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: primaryColor));
    notifyListeners();
  }

  loadTheme({bool useAnonymousToken = false}) async {
    var appTheme = await ThemeRepository.getTheme(useAnonymousToken);

    if (appTheme == null) {
      return;
    }

    // currentTheme = ThemeDecoder.decodeThemeData(appTheme["theme"]) ?? ThemeData();
    currentTheme = decodeTheme(appTheme["theme"]);
    currentTheme = setThemeFont(currentTheme);
    themeData = appTheme["theme"];
    logoDocumentNbr = appTheme["logoDocumentNbr"];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: primaryColor));

    await SecureStorage.write(key, jsonEncode(appTheme));

    notifyListeners();
  }

  setThemeFont(ThemeData themeData) {
    themeData.textTheme.apply(fontFamily: Constants.fontFamily);
    themeData.primaryTextTheme.apply(fontFamily: Constants.fontFamily);
    return themeData;
  }

  Color get greyColor {
    return getColor("grey");
  }

  Color get light0Color {
    return getColor("light0");
  }

  Color get light1Color {
    return resolveColor(themeData["scaffoldBackgroundColor"]);
  }

  Color get light2Color {
    return getColor("light2");
  }

  Color get light3Color {
    return getColor("light3");
  }

  Color get light4Color {
    return getColor("light4");
  }

  Color get light5Color {
    return getColor("light5");
  }

  Color get orangeColor {
    return getColor("orange");
  }

  Color get blueColor {
    return getColor("blue");
  }

  Color get dark0Color {
    return getColor("dark0");
  }

  Color get dark1Color {
    return getColor("dark1");
  }

  Color get dark2Color {
    return getColor("dark2");
  }

  Color get dark3Color {
    return getColor("dark3");
  }

  Color get secondaryButtonColor {
    return getColor("secondaryButtonColor");
  }

  Color get secondaryButtonTextColor {
    return getColor("secondaryButtonText");
  }

  Color get gradientButtonFromColor {
    return getColor("gradientButtonFrom");
  }

  Color get gradientButtonToColor {
    return getColor("gradientButtonTo");
  }

  Color get gradientButtonBorderColor {
    return getColor("gradientButtonBorder");
  }

  Color get gradientButtonTextColor {
    return getColor("gradientButtonTextColor");
  }

  Color get successColor {
    return getColor("success");
  }

  Color get deleteColor {
    return getColor("error");
  }

  Color get errorColor {
    return getColor("error");
  }

  Color get notchColor {
    return getColor("notchColor");
  }

  double get notchWidth {
    dynamic extraTheme = themeData["extraTheme"]["dimensions"] ?? {};
    return double.parse(extraTheme["notchWidth"] ?? "260");
  }

  double get notchHeight {
    dynamic extraTheme = themeData["extraTheme"]["dimensions"] ?? {};
    return double.parse(extraTheme["notchHeight"] ?? "200");
  }

  Color get primaryColor {
    return resolveColor(themeData["primaryColor"]);
  }

  Color get iconColor {
    return resolveColor(themeData["iconTheme"]?["color"]);
  }

  Color get headline6Color {
    return resolveColor(themeData["textTheme"]?["headline6"]?["color"]);
  }

  Color get headline5Color {
    return resolveColor(themeData["textTheme"]?["headline5"]?["color"]);
  }

  Color get headline3Color {
    return resolveColor(themeData["textTheme"]?["headline3"]?["color"]);
  }

  Color get headline2Color {
    return resolveColor(themeData["textTheme"]?["headline2"]?["color"]);
  }

  Color get headline1Color {
    return resolveColor(themeData["textTheme"]?["headline1"]?["color"]);
  }

  Color get subtitle1Color {
    return resolveColor(themeData["textTheme"]?["subtitle1"]?["color"]);
  }

  Color get subtitle2Color {
    return resolveColor(themeData["textTheme"]?["subtitle2"]?["color"]);
  }

  Color get bodyText2Color {
    return resolveColor(themeData["textTheme"]?["bodyText2"]?["color"]);
  }

  Color get captionColor {
    return resolveColor(themeData["textTheme"]?["caption"]?["color"]);
  }

  Color get overlineColor {
    return resolveColor(themeData["textTheme"]?["overline"]?["color"]);
  }

  Color get appBarTitleTextColor {
    return resolveColor(themeData["appBarTheme"]?["titleTextStyle"]?["color"]);
  }

  double get secondaryButtonFontSize {
    return getFontSize("secondaryButtonFontSize");
  }

  double get gradientButtonText {
    return getFontSize("gradientButtonText");
  }

  Color resolveColor(String? color) {
    if (color != null) {
      return ThemeUtility.getMaterialColor(color);
    }

    return Colors.blue;
  }

  Color getColor(String name) {
    dynamic extraTheme = themeData["extraTheme"]?["colors"] ?? defaultTheme["extraTheme"]?["colors"] ?? {};

    if (extraTheme[name] != null) {
      return ThemeUtility.getMaterialColor((extraTheme[name]));
    }

    return Colors.white;
  }

  Color getMyRecordsCardBackgroundColor() {
    return resolveColor(themeData["extraTheme"]?["myRecords"]?["cardBackgroundColor"] ?? defaultTheme["extraTheme"]?["myRecords"]?["cardBackgroundColor"]);
  }

  Color getMyRecordsCardActionBackgroundColor() {
    return resolveColor(themeData["extraTheme"]?["myRecords"]?["cardActionsBackground"] ?? defaultTheme["extraTheme"]?["myRecords"]?["cardActionsBackground"]);
  }

  double getMyRecordsCardElevation() {
    var elevation = themeData["extraTheme"]?["myRecords"]?["cardElevation"] ?? defaultTheme["extraTheme"]?["myRecords"]?["cardElevation"] ?? "0";
    if (elevation is double) {
      return elevation;
    } else {
      return double.parse(elevation ?? "0");
    }
  }

  double getMyRecordsSpaceBetweenCards() {
    var space = themeData["extraTheme"]?["myRecords"]?["spaceBetweenCards"] ?? defaultTheme["extraTheme"]?["myRecords"]?["spaceBetweenCards"] ?? "14";
    if (space is double) {
      return space;
    } else {
      return double.parse(space ?? "14");
    }
  }

  String getMyRecordsLabelPosition() {
    return themeData["extraTheme"]?["myRecords"]?["labelPosition"] ?? defaultTheme["extraTheme"]?["myRecords"]?["labelPosition"] ?? "bottom";
  }

  List<dynamic> getMyRecordsLabels() {
    List<dynamic> arr = themeData["extraTheme"]?["myRecords"]?["labels"] ?? defaultTheme["extraTheme"]?["myRecords"]?["labels"] ?? [];
    // sort the array by the order of the labels
    arr.sort((a, b) => int.parse(a["displayOrder"]) - int.parse(b["displayOrder"]));
    return arr;
  }

  Color getInspectionsCardBackgroundColor() {
    return resolveColor(themeData["extraTheme"]?["inspections"]?["cardBackgroundColor"] ?? defaultTheme["extraTheme"]?["inspections"]?["cardBackgroundColor"]);
  }

  Color getInspectionsCardActionBackgroundColor() {
    return resolveColor(
        themeData["extraTheme"]?["inspections"]?["cardActionsBackground"] ?? defaultTheme["extraTheme"]?["inspections"]?["cardActionsBackground"]);
  }

  double getInspectionsCardElevation() {
    var elevation = themeData["extraTheme"]?["inspections"]?["cardElevation"] ?? defaultTheme["extraTheme"]?["inspections"]?["cardElevation"] ?? "0";
    if (elevation is double) {
      return elevation;
    } else {
      return double.parse(elevation ?? "0");
    }
  }

  double getInspectionsSpaceBetweenCards() {
    var space = themeData["extraTheme"]?["inspections"]?["spaceBetweenCards"] ?? defaultTheme["extraTheme"]?["inspections"]?["spaceBetweenCards"] ?? "14";
    if (space is double) {
      return space;
    } else {
      return double.parse(space ?? "14");
    }
  }

  String getInspectionsLabelPosition() {
    return themeData["extraTheme"]?["inspections"]?["labelPosition"] ?? defaultTheme["extraTheme"]?["inspections"]?["labelPosition"] ?? "bottom";
  }

  List<dynamic> getInspectionsLabels() {
    List<dynamic> arr = themeData["extraTheme"]?["inspections"]?["labels"] ?? defaultTheme["extraTheme"]?["inspections"]?["labels"] ?? [];
    // sort the array by the order of the labels
    arr.sort((a, b) => int.parse(a["displayOrder"]) - int.parse(b["displayOrder"]));
    return arr;
  }

  String getColorValue(String name) {
    dynamic extraTheme = themeData["extraTheme"]["colors"] ?? {};
    return extraTheme[name] ?? "#FFFFFF";
  }

  double getFontSize(String name) {
    dynamic extraTheme = themeData["extraTheme"]["fonts"] ?? {};
    if (extraTheme[name] is double) {
      return extraTheme[name];
    } else {
      return double.parse(extraTheme[name] ?? "14");
    }
  }

  double getButtonsRadius() {
    var elevatedButttonTheme = themeData["elevatedButtonTheme"];
    return ((elevatedButttonTheme["style"]["shape"]["empty"]["borderRadius"] as num)).toDouble();
  }

//   ButtonStyle? getSecondaryButtonStyle(BuildContext context) {
//     var elevatedButttonTheme = themeData["elevatedButtonTheme"];
//     elevatedButttonTheme["style"]["backgroundColor"] = {
//       'empty': getColorValue("secondaryButtonColor"),
//       'hovered': getColorValue("secondaryButtonColor"),
//       'pressed': getColorValue("secondaryButtonColor"),
//     };
//     elevatedButttonTheme["style"]["foregroundColor"] = {
//       'empty': getColorValue("secondaryButtonText"),
//       'hovered': getColorValue("secondaryButtonText"),
//       'pressed': getColorValue("secondaryButtonText"),
//     };

//     elevatedButttonTheme["style"]["textStyle"] = {"fontSize": getFontSize("secondaryButtonFontSize")};

//     return ThemeDecoder.decodeElevatedButtonThemeData(jsonDecode(jsonEncode(elevatedButttonTheme)))?.style;
//   }

  String? getLogoDocumentNbr() {
    return logoDocumentNbr;
  }

  String getCardLabelPosition() {
    return themeData["extraTheme"]?["cardLabelPosition"] ?? defaultTheme["extraTheme"]?["cardLabelPosition"] ?? "bottom";
  }

  ThemeData decodeTheme(Map<String, dynamic> jsonTheme) {
    ThemeData themeData = ThemeData(
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (!states.contains(MaterialState.selected)) {
            return Colors.transparent;
          }
          return Color(parseColor(jsonTheme['checkboxTheme']['fillColor']));
        }),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: TextStyle(
          color: Color(parseColor(jsonTheme['dialogTheme']['titleTextStyle']['color'])),
          fontSize: double.parse(jsonTheme['dialogTheme']['titleTextStyle']['fontSize']),
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: Color(parseColor(jsonTheme['dialogTheme']['contentTextStyle']['color'])),
          fontSize: double.parse(jsonTheme['dialogTheme']['contentTextStyle']['fontSize']),
          fontWeight: FontWeight.w500,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
            fontFamily: jsonTheme['textButtonTheme']['style']['textStyle']['fontFamily'],
            fontSize: double.parse(jsonTheme['textButtonTheme']['style']['textStyle']['fontSize']),
            fontWeight: FontWeight.w500,
            color: Color(parseColor(jsonTheme['textButtonTheme']['style']['textStyle']['color'])),
          ),
        ).copyWith(foregroundColor: MaterialStateProperty.all<Color>(Color(parseColor(jsonTheme['primaryColor'])))),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: double.parse(jsonTheme['elevatedButtonTheme']['style']['elevation']['empty']),
          backgroundColor: Color(parseColor(jsonTheme['elevatedButtonTheme']['style']['backgroundColor']['empty'])),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(double.parse(jsonTheme['elevatedButtonTheme']['style']['shape']['empty']['borderRadius'].toString())),
          ),
          foregroundColor: Color(parseColor(jsonTheme['elevatedButtonTheme']['style']['foregroundColor']['empty'])),
          textStyle: TextStyle(
            fontSize: double.parse(jsonTheme['elevatedButtonTheme']['style']['textStyle']['fontSize']),
            fontFamily: jsonTheme['elevatedButtonTheme']['style']['textStyle']['fontFamily'],
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(parseColor(jsonTheme['iconTheme']['color'])),
      ),
      scaffoldBackgroundColor: Color(parseColor(jsonTheme['scaffoldBackgroundColor'])),
      cardTheme: CardThemeData(
        elevation: double.parse(jsonTheme['cardTheme']['elevation'].toString()),
        color: Color(parseColor(jsonTheme['cardTheme']['color'])),
      ),
      appBarTheme: AppBarTheme(
        elevation: double.parse(jsonTheme['appBarTheme']['elevation'].toString()),
        backgroundColor: Color(parseColor(jsonTheme['appBarTheme']['backgroundColor'])),
        titleTextStyle: TextStyle(
          color: Color(parseColor(jsonTheme['appBarTheme']['titleTextStyle']['color'])),
          fontSize: double.parse(jsonTheme['appBarTheme']['titleTextStyle']['fontSize']),
          fontWeight: FontWeight.w400,
          fontFamily: jsonTheme['appBarTheme']['titleTextStyle']['fontFamily'],
        ),
        iconTheme: IconThemeData(
          size: double.parse(jsonTheme['appBarTheme']['iconTheme']['size'].toString()),
          color: Color(parseColor(jsonTheme['appBarTheme']['iconTheme']['color'])),
        ),
        toolbarHeight: double.parse(jsonTheme['appBarTheme']['toolbarHeight'].toString()),
      ),
      dividerTheme: DividerThemeData(
        color: Color(parseColor(jsonTheme['dividerTheme']['color'])),
        thickness: double.parse(jsonTheme['dividerTheme']['thickness'].toString()),
        indent: double.parse(jsonTheme['dividerTheme']['indent'].toString()),
        endIndent: double.parse(jsonTheme['dividerTheme']['endIndent'].toString()),
        space: double.parse(jsonTheme['dividerTheme']['space'].toString()),
      ),
      //   errorColor: Color(parseColor(jsonTheme['errorColor'])),
      fontFamily: jsonTheme['fontFamily'],
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: Color(parseColor(jsonTheme['textTheme']['titleLarge']['color'])),
          fontSize: double.parse(jsonTheme['textTheme']['titleLarge']['fontSize']),
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: Color(parseColor(jsonTheme['textTheme']['titleMedium']['color'])),
          fontSize: double.parse(jsonTheme['textTheme']['titleMedium']['fontSize']),
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: Color(parseColor(jsonTheme['textTheme']['titleSmall']['color'])),
          fontSize: double.parse(jsonTheme['textTheme']['titleSmall']['fontSize']),
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: TextStyle(
          color: Color(parseColor(jsonTheme['textTheme']['headlineLarge']['color'])),
          fontSize: double.parse(jsonTheme['textTheme']['headlineLarge']['fontSize']),
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: TextStyle(
          color: Color(parseColor(jsonTheme['textTheme']['headlineMedium']['color'])),
          fontSize: double.parse(jsonTheme['textTheme']['headlineMedium']['fontSize']),
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: Color(parseColor(jsonTheme['textTheme']['headlineSmall']['color'])),
          fontSize: double.parse(jsonTheme['textTheme']['headlineSmall']['fontSize']),
          fontWeight: FontWeight.w500,
        ),
        labelLarge: TextStyle(
          color: Color(parseColor(jsonTheme['textTheme']['labelLarge']['color'])),
          fontSize: double.parse(jsonTheme['textTheme']['labelLarge']['fontSize']),
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: Color(parseColor(jsonTheme['textTheme']['labelMedium']['color'])),
          fontSize: double.parse(jsonTheme['textTheme']['labelMedium']['fontSize']),
          fontWeight: FontWeight.w400,
        ),
        labelSmall: TextStyle(
          color: Color(parseColor(jsonTheme['textTheme']['labelSmall']['color'])),
          fontSize: double.parse(jsonTheme['textTheme']['labelSmall']['fontSize']),
          fontWeight: FontWeight.w500,
        ),
      ),
      //   toggleableActiveColor: Color(parseColor(jsonTheme['toggleableActiveColor'])),
      indicatorColor: Color(parseColor(jsonTheme['indicatorColor'])),
      primaryColor: Color(parseColor(jsonTheme['primaryColor'])),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        refreshBackgroundColor: Color(parseColor(jsonTheme['progressIndicatorTheme']['refreshBackgroundColor'])),
        color: Color(parseColor(jsonTheme['progressIndicatorTheme']['color'])),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(parseColor(jsonTheme['inputDecorationTheme']['fillColor'])),
        filled: jsonTheme['inputDecorationTheme']['filled'],
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(parseColor(jsonTheme['inputDecorationTheme']['disabledBorder']['borderSide']['color'])),
            width: double.parse(jsonTheme['inputDecorationTheme']['disabledBorder']['borderSide']['width'].toString()),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(parseColor(jsonTheme['inputDecorationTheme']['focusedBorder']['borderSide']['color'])),
            width: double.parse(jsonTheme['inputDecorationTheme']['focusedBorder']['borderSide']['width'].toString()),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(parseColor(jsonTheme['inputDecorationTheme']['focusedErrorBorder']['borderSide']['color'])),
            width: double.parse(jsonTheme['inputDecorationTheme']['focusedErrorBorder']['borderSide']['width'].toString()),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(parseColor(jsonTheme['inputDecorationTheme']['errorBorder']['borderSide']['color'])),
            width: double.parse(jsonTheme['inputDecorationTheme']['errorBorder']['borderSide']['width'].toString()),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(parseColor(jsonTheme['inputDecorationTheme']['enabledBorder']['borderSide']['color'])),
            width: double.parse(jsonTheme['inputDecorationTheme']['enabledBorder']['borderSide']['width'].toString()),
          ),
        ),
      ),
    );

    return themeData;
  }

  int parseColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }
}

class CustomTheme {}

final themeProvider = ChangeNotifierProvider((ref) => ThemeNotifier());
