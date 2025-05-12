import 'package:aca_mobile_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BackgroundEffectPainter extends CustomPainter {
  Color color;
  double opacity;

  BackgroundEffectPainter(this.color, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.cubicTo(size.width * 0.1, size.height * 0.3, size.width * 0.2, size.height * 0.4, size.width * 0.6, size.height * 0.5);
    path_0.cubicTo(size.width, size.height * 0.6, size.width, size.height * 0.7, size.width, size.height * 0.8);
    path_0.cubicTo(size.width, size.height, size.width, size.height * 0.8, size.width, 0);
    path_0.lineTo(size.width, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    // paint_0_fill.color = Color(0xffE2E7EE).withOpacity(0.6);
    paint0Fill.color = color.withOpacity(opacity);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BreadcrumbItemPainter extends CustomPainter {
  late final Color strokeColor;
  late final Color backgroundColor;
  late final PaintingStyle paintingStyle;
  late final double strokeWidth;
  final Color altColor;
  final int idx;
  final int selectedIdx;
  final int totalSteps;
  final ThemeNotifier themeNotifier;
  final bool reversed;

//   TrianglePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke, this.backgroundColor = Colors.white});
  BreadcrumbItemPainter(
      {required this.themeNotifier, required this.idx, required this.selectedIdx, required this.totalSteps, required this.reversed, required this.altColor}) {
    if (selectedIdx == idx) {
      backgroundColor = altColor;
      strokeColor = themeNotifier.getColor("light0");
      paintingStyle = PaintingStyle.fill;
      strokeWidth = 10;
    } else if (idx == selectedIdx - 1) {
      backgroundColor = themeNotifier.getColor("light0");
      strokeColor = altColor;
      paintingStyle = PaintingStyle.fill;
      strokeWidth = 10;
    } else {
      backgroundColor = themeNotifier.getColor("light0");
      strokeColor = themeNotifier.getColor("light0");
      //themeNotifier.breadcrumbBackgroundColor;
      paintingStyle = PaintingStyle.stroke;
      strokeWidth = 3;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    if (selectedIdx == idx || idx == selectedIdx - 1) {
      canvas.drawRect(Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)), paint);
    }
    paint.color = strokeColor;
    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    if (!reversed) {
      return Path()
        ..moveTo(0, 0)
        ..lineTo(x, y / 2)
        ..lineTo(0, y);
    } else {
      return Path()
        ..moveTo(x, 0)
        ..lineTo(0, y / 2)
        ..lineTo(x, y);
    }
  }

  @override
  bool shouldRepaint(BreadcrumbItemPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor || oldDelegate.paintingStyle != paintingStyle || oldDelegate.strokeWidth != strokeWidth;
  }
}

class TrianglePainter extends CustomPainter {
  final ThemeNotifier themeNotifier;
  final bool reversed;
  TrianglePainter({required this.themeNotifier, required this.reversed});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = themeNotifier.getColor("light0")
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    paint.color = themeNotifier.getColor("light0");
    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    if (!reversed) {
      return Path()
        ..moveTo(0, 0)
        ..lineTo(x, y / 2)
        ..lineTo(0, y);
    } else {
      return Path()
        ..moveTo(x, 0)
        ..lineTo(0, y / 2)
        ..lineTo(x, y);
    }
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return true;
  }
}
