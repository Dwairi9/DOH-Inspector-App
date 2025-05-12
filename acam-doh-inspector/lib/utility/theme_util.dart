import 'package:flutter/material.dart';

class ThemeUtility {
  static MaterialColor getMaterialColor(String colorHexStr) {
    int getPrimaryColorInt(String colorHexStr) {
      String prefix = '';
      colorHexStr = colorHexStr.replaceAll("#", "");
      if (colorHexStr.length == 6 || colorHexStr.length == 7) {
        prefix = '0xFF';
      } else if (colorHexStr.length == 8) {
        prefix = '0x';
      }
      return (int.parse(prefix + colorHexStr));
    }

    Map<int, Color> getSwatchColor(Color primaryColor) {
      List strengths = <double>[.05];
      Map<int, Color> swatch = {};
      final int r = primaryColor.red, g = primaryColor.green, b = primaryColor.blue;

      for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
      for (var strength in strengths) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      }
      return swatch;
    }

    int primary = getPrimaryColorInt(colorHexStr);
    Map<int, Color> swatch = getSwatchColor(Color(primary));
    return MaterialColor(primary, swatch);
  }

  static ThemeData buildTheme(BuildContext context, Map themeData) {
    return ThemeData(
      fontFamily: 'SourceSansPro',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: getMaterialColor(themeData['primaryColor']),
      scaffoldBackgroundColor: getMaterialColor(themeData['scaffoldBackgroundColor']),
      inputDecorationTheme: InputDecorationTheme(
        filled: (themeData['inputDecorationTheme']['filled'] == "true"),
        fillColor: getMaterialColor(themeData['inputDecorationTheme']['fillColor']),
      ), colorScheme: ColorScheme.fromSwatch(primarySwatch: getMaterialColor(themeData['primarySwatch'])).copyWith(error: getMaterialColor(themeData['errorColor'])),
    );
  }
}
