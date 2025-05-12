import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';

class InfoMessageProvider extends ChangeNotifier {
  String textMessage = '';
  bool showMessage = false;
  ThemeNotifier themeNotifier;
  Color color = Colors.green;
  IconData icon = Icons.info;

  InfoMessageProvider(this.themeNotifier);
  setInfoMessage(String textMessage) {
    color = Colors.orange;
    icon = Icons.warning;
    this.textMessage = textMessage;
    showMessage = true;
    notifyListeners();
  }

  setErrorMessage(String textMessage) {
    color = themeNotifier.errorColor;
    icon = Icons.error;
    this.textMessage = textMessage;
    showMessage = true;
    notifyListeners();
  }

  setSuccessMessage(String textMessage) {
    color = Colors.green;
    icon = Icons.info;
    this.textMessage = textMessage;
    showMessage = true;
    notifyListeners();
  }

  closeMessage() {
    showMessage = false;
    notifyListeners();
  }
}
