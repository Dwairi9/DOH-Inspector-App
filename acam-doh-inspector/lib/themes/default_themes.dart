class AcamDefaultTheme {
  static Map<String, dynamic> getDefaultTheme() {
    return dohThemeInspector;
  }

  static var dohThemeInspector = <String, dynamic>{
    "checkboxTheme": {"checkColor": "#006871", "fillColor": "#006871"},
    "dialogTheme": {
      "titleTextStyle": {"color": "#4E4E4E", "fontSize": "22", "fontWeight": "w600"},
      "contentTextStyle": {"color": "#4E4E4E", "fontSize": "15", "fontWeight": "w500"}
    },
    "textButtonTheme": {
      "style": {
        "textStyle": {"fontFamily": "Cairo", "fontSize": "15", "fontWeight": "w500", "color": "#006871"}
      }
    },
    "elevatedButtonTheme": {
      "style": {
        "elevation": {"pressed": "0", "hovered": "0", "empty": "0"},
        "backgroundColor": {"pressed": "#006871", "hovered": "#006871", "empty": "#006871"},
        "shape": {
          "empty": {"borderRadius": 4, "type": "rounded"},
          "hovered": {"borderRadius": 4, "type": "rounded"},
          "pressed": {"borderRadius": 4, "type": "rounded"}
        },
        "foregroundColor": {"pressed": "#FFFFFF", "hovered": "#FFFFFF", "empty": "#FFFFFF"},
        "textStyle": {"fontSize": "24", "fontFamily": "Cairo"}
      }
    },
    "iconTheme": {"color": "#9D9B98"},
    "scaffoldBackgroundColor": "#f5f4f2",
    "cardTheme": {"elevation": 2, "color": "#FFFFFF"},
    "appBarTheme": {
      "elevation": 0,
      "backgroundColor": "#006871",
      "titleTextStyle": {"color": "#ffffff", "fontSize": "20", "fontWeight": "w400", "fontFamily": "Cairo"},
      "iconTheme": {"size": 24, "color": "#ffffff"},
      "toolbarHeight": 80
    },
    "dividerTheme": {"color": "#DFDBD3", "thickness": 2, "indent": 0, "endIndent": 0, "space": 1},
    "errorColor": "#CC3D0B",
    "extraTheme": {
      "fonts": {"secondaryButtonFontSize": "20", "gradientButtonText": "14"},
      "colors": {
        "notchColor": "#DFDBD3",
        "secondaryButtonColor": "#FFFFFF",
        "gradientButtonBorder": "#AAAAAA",
        "gradientButtonTo": "#F2F4F7",
        "error": "#CC3D0B",
        "secondaryButtonText": "#273142",
        "dark2": "#4E4E4E",
        "gradientButtonTextColor": "#273142",
        "dark3": "#273142",
        "dark0": "#ABBBD1",
        "dark1": "#8198B1",
        "success": "#96A926",
        "gradientButtonFrom": "#FFFFFF",
        "light0": "#FFFFFF",
        "light1": "#F8F8F8",
        "light2": "#F5F4F2",
        "light3": "#DFDBD3",
        "light4": "#9D9B98",
        "light5": "#f0eee9",
        "orange": "#F6AE00",
        "blue": "#00A8DF",
        "grey": "4E4E4E"
      },
      "dimensions": {"notchWidth": "260", "notchHeight": "200"},
    },
    "fontFamily": "Cairo",
    "textTheme": {
      "titleLarge": {"color": "#4E4E4E", "fontSize": "30", "fontWeight": "w500"},
      "titleMedium": {"color": "#4E4E4E", "fontSize": "20", "fontWeight": "w500"},
      "titleSmall": {"color": "#4E4E4E", "fontSize": "12", "fontWeight": "w500"},
      "headlineLarge": {"color": "#4E4E4E", "fontSize": "30", "fontWeight": "w500"},
      "headlineMedium": {"color": "#4E4E4E", "fontSize": "17", "fontWeight": "w600"},
      "headlineSmall": {"color": "#9D9B98", "fontSize": "13", "fontWeight": "w500"},
      "labelLarge": {"color": "#4E4E4E", "fontSize": "30", "fontWeight": "w500"},
      "labelMedium": {"color": "#4E4E4E", "fontSize": "20", "fontWeight": "w400"},
      "labelSmall": {"color": "#4E4E4E", "fontSize": "12", "fontWeight": "w500"},
    },
    "toggleableActiveColor": "#006871",
    "indicatorColor": "#006871",
    "primaryColor": "#006871",
    "progressIndicatorTheme": {"refreshBackgroundColor": "#FFFFFF", "color": "#006871"},
    "inputDecorationTheme": {
      "fillColor": "#FFFFFF",
      "disabledBorder": {
        "borderSide": {"color": "#E2E7EE", "width": 0},
        "type": "outline"
      },
      "focusedBorder": {
        "borderSide": {"color": "#4E4E4E", "width": 0},
        "type": "outline"
      },
      "focusedErrorBorder": {
        "borderSide": {"color": "#CC3D0B", "width": 0},
        "type": "outline"
      },
      "errorBorder": {
        "borderSide": {"color": "#CC3D0B", "width": 0},
        "type": "outline"
      },
      "filled": true,
      "enabledBorder": {
        "borderSide": {"color": "#DFDBD3", "width": 0},
        "type": "outline"
      }
    },
  };
}
