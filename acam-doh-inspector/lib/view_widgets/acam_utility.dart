import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:flutter/material.dart';

class AcamUtility {
  static showMessageForActionObject(BuildContext context, ActionObject actionObject) {
    showMessage(context, actionObject.message, isError: !actionObject.success);
  }

  static showMessage(BuildContext context, String message, {bool isError = false}) {
    var snackBar = SnackBar(content: Text(message));
    if (!isError) {
      snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ));
    } else {
      snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ));
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
