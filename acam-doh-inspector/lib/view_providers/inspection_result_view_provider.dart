import 'package:aca_mobile_app/views/draw_view2.dart';
import 'package:flutter/material.dart';

class InspectionResultProvider extends ChangeNotifier {
  PainterController painterController = _newController();
  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 4.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }
}
