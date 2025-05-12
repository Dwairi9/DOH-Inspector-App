import 'dart:convert';
import 'dart:math';

import 'package:aca_mobile_app/Widgets/acam_widgets.dart';
import 'package:aca_mobile_app/settings/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  static Future<void> showAlert(BuildContext context, String title, String text) async {
    return showAndroidAlertDialog(context, title, text);
  }

  static Future<void> showAndroidAlertDialog(BuildContext context, String messageTitle, String messageDesc) {
    return showOptionsDialog(context, messageTitle, messageDesc, []);
  }

  static Future<T?> showFullScreenDialog<T extends Object?>(BuildContext context, Widget content, String title, List<FullScreenActionButton> actions,
      {void Function(BuildContext context)? onClose}) async {
    return Navigator.push<T>(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 200),
            child: FullScreenDialog(content: content, title: title, actions: actions, onClose: onClose)));
  }

  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static String dateToString(DateTime? dateTime, String format) {
    if (dateTime == null) {
      return '';
    }
    DateFormat dateFormat = DateFormat(format, "en_US");
    return dateFormat.format(dateTime);
  }

  static DateTime? stringToDate(String date, String format) {
    try {
      return DateFormat(format, "en_US").parse(date);
    } catch (e) {
      return null;
    }
  }

  static TimeOfDay? stringToTime(String time) {
    try {
      var arr = time.split(":");
      return TimeOfDay(hour: int.tryParse(arr[0]) ?? 0, minute: int.tryParse(arr[1]) ?? 0);
    } catch (e) {
      return null;
    }
  }

  static String timeToString(TimeOfDay? time) {
    if (time == null) {
      return '';
    }
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  static String stringDateReformat(String date, String oldFormat, String newFormat) {
    if (date.isEmpty) {
      return "";
    }
    return dateToString(stringToDate(date, oldFormat), newFormat);
  }

  static Future<void> showOptionsDialog(BuildContext context, String messageTitle, String messageDesc, List<ActionButton> actions) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(messageTitle),
            content: SingleChildScrollView(
              child: Text(messageDesc),
            ),
            actions: actions.isNotEmpty
                ? actions
                    .map((e) => TextButton(
                          onPressed: () {
                            if (e.callback != null) {
                              e.callback!(context);
                            }
                          },
                          child: Text(e.title),
                        ))
                    .toList()
                : [
                    TextButton(
                      child: Text('Okay'.tr()),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]);
      },
    );
  }

  static String capitalizeFirstLetter(String s) {
    if (s.isNotEmpty) {
      s = s[0].toUpperCase() + s.substring(1).toLowerCase();
    }

    return s;
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  static bool isRTL(BuildContext context) {
    return Directionality.of(context).toString().contains(TextDirection.RTL.value.toLowerCase());
  }

  static void setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${Constants.uniqueEnvironmentKey}-lang', lang);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString('${Constants.uniqueEnvironmentKey}-lang');
    lang ??= 'en';
    return lang;
  }

  static String getImageUrl(String documentNo, String token) {
    String imgUrl = "";
    if (Constants.connectionMethod == ConnectionMethods.cloud) {
      imgUrl = '${Constants.apiUrl}/documents/$documentNo/download';
    } else if (Constants.connectionMethod == ConnectionMethods.gateway) {
      imgUrl = '${Constants.gatewayUrl}/documents/$documentNo/download?token=$token';
    } else {
      imgUrl = '${Constants.baseUrl}/documents/$documentNo/download?token=$token';
    }
    return imgUrl;
  }

  static Map<String, String> getImageHeaders(String token) {
    Map<String, String> headers = {};
    if (Constants.connectionMethod == ConnectionMethods.cloud) {
      headers = {
        'Authorization': token,
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

  static Widget getImageFromAccela(String documentNo, String token, {double width = 80, double height = 80, BoxFit boxFit = BoxFit.cover}) {
    if (documentNo != "") {
      String imgUrl = getImageUrl(documentNo, token);
      Map<String, String> headers = getImageHeaders(token);
      return CachedNetworkImage(
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        imageUrl: imgUrl,
        height: height,
        width: width,
        httpHeaders: headers,
        fit: boxFit,
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          color: Colors.red[200],
        ),
      );
    } else {
      return const Image(image: AssetImage('assets/service-icon.png'), height: 80, width: 80, fit: BoxFit.cover);
    }
  }

  static getDispValueFromMap(BuildContext context, Map<String, dynamic> map, String key, String defaultValue, {bool basedOnLanguage = false}) {
    var dispKey = key;

    if (basedOnLanguage) {
      if (context.locale.languageCode == "ar") {
        dispKey = "${dispKey}Disp";
      }
    } else {
      dispKey = "${dispKey}Disp";
    }
    if (map.containsKey(dispKey) && map[dispKey] != null && map[dispKey] != "") {
      return map[dispKey];
    } else if (map.containsKey(key) && map[key] != null && map[key] != "") {
      return map[key];
    } else {
      return defaultValue;
    }
  }

  static String replaceArabicNumberWithEnglishNumber(String value) {
    return value.replaceAllMapped("[۰-۹]", (match) => '۰۱۲۳۴۵۶۷۸۹'.indexOf(match.group(0) ?? '').toString());
  }

  static String generateRandomString(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  static bool isInt(String? str) {
    if (str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  static randomInt(int i, int j) {
    var random = Random.secure();
    return random.nextInt(j - i) + i;
  }
}
