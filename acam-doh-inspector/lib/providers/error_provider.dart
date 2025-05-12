import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorObject {
  String errorMessage;

  ErrorObject(this.errorMessage);
}

class ErrorProvider extends ChangeNotifier {
  String errorMessage = "";

  void setError(String errorMessage) {
    this.errorMessage = errorMessage;
    notifyListeners();
  }
}

// final errorStateNotifierProvider = StateNotifierProvider<ErrorProvider, ErrorObject>((ref) {
//   return ErrorProvider();
// });

final errorStateNotifierProvider = ChangeNotifierProvider((ref) {
  return ErrorProvider();
});
