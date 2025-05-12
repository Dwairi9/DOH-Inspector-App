/// Provides a widget and an associated controller for simple painting using touch.
library painter;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:path_provider/path_provider.dart';

/// A very simple widget that supports drawing using touch.
class PainterView extends StatefulWidget {
  final PainterController painterController;

  /// Creates an instance of this widget that operates on top of the supplied [PainterController].
  PainterView(this.painterController) : super(key: ValueKey<PainterController>(painterController));

  @override
  PainterViewState createState() => PainterViewState();
}

class PainterViewState extends State<PainterView> {
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    widget.painterController._widgetFinish ??= _finish;
  }

  Size _finish() {
    if (mounted) {
      setState(() {
        _finished = true;
      });
      return context.size ?? const Size(0, 0);
    } else {
      return widget.painterController._contextSize ?? const Size(0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = CustomPaint(
      willChange: true,
      painter: _PainterPainter(
        widget.painterController._pathHistory,
        repaint: widget.painterController,
      ),
    );

    child = ClipRect(child: child);

    if (!_finished) {
      child = GestureDetector(
        key: const ValueKey('interactive'), // <-- key here
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: child,
      );
    } else {
      child = KeyedSubtree(
        key: const ValueKey('non-interactive'), // <-- alternate key
        child: child,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: child,
    );
  }

  void _onPanStart(DragStartDetails start) {
    widget.painterController._contextSize ??= context.size ?? const Size(0, 0);
    Offset pos = (context.findRenderObject() as RenderBox).globalToLocal(start.globalPosition);
    widget.painterController._pathHistory.add(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanUpdate(DragUpdateDetails update) {
    Offset pos = (context.findRenderObject() as RenderBox).globalToLocal(update.globalPosition);
    widget.painterController._pathHistory.updateCurrent(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanEnd(DragEndDetails end) {
    widget.painterController._pathHistory.endCurrent();
    widget.painterController._notifyListeners();
  }
}

class _PainterPainter extends CustomPainter {
  final _PathHistory _path;

  _PainterPainter(this._path, {Listenable? repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) {
    return true;
  }
}

class _PathHistory {
  final List<MapEntry<Path, Paint>> _paths;
  Paint currentPaint;
  final Paint _backgroundPaint;
  bool _inDrag;

  bool get isEmpty => _paths.isEmpty || (_paths.length == 1 && _inDrag);

  _PathHistory()
      : _paths = <MapEntry<Path, Paint>>[],
        _inDrag = false,
        _backgroundPaint = Paint()..blendMode = BlendMode.dstOver,
        currentPaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 1.0
          ..style = PaintingStyle.fill;

  void setBackgroundColor(Color backgroundColor) {
    _backgroundPaint.color = backgroundColor;
  }

  void undo() {
    if (!_inDrag) {
      _paths.removeLast();
    }
  }

  bool hasContent() {
    return _paths.isNotEmpty;
  }

  void clear() {
    if (!_inDrag) {
      _paths.clear();
    }
  }

  void add(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      Path path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      _paths.add(MapEntry<Path, Paint>(path, currentPaint));
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      Path path = _paths.last.key;
      path.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endCurrent() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    for (MapEntry<Path, Paint> path in _paths) {
      Paint p = path.value;
      canvas.drawPath(path.key, p);
    }
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _backgroundPaint);
    canvas.restore();
  }
}

class PictureDetails {
  final Picture picture;

  final int width;

  final int height;

  const PictureDetails(this.picture, this.width, this.height);

  Future<Image> toImage() => picture.toImage(width, height);

  Future<Uint8List> toPNG() async {
    Image image = await toImage();
    ByteData? data = await image.toByteData(format: ImageByteFormat.png);

    if (data != null) {
      return data.buffer.asUint8List();
    } else {
      throw FlutterError('Flutter failed to convert an Image to bytes!');
    }
  }

  Future<File> toFile(String saveFileName) async {
    final byteList = await toPNG();
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory directory = await Directory('${appDocDirectory.path}/dir').create(recursive: true);
    var fullPath = '${directory.path}/$saveFileName';
    if (Platform.isWindows) {
      fullPath = saveFileName;
    }
    return File(fullPath).writeAsBytes(byteList);
  }
}

class PainterController extends ChangeNotifier {
  Color _drawColor = const Color.fromARGB(255, 0, 0, 0);
  Color _backgroundColor = const Color.fromARGB(255, 255, 255, 255);
  bool _eraseMode = false;

  double _thickness = 1.0;
  PictureDetails? _cached;
  final _PathHistory _pathHistory;
  ValueGetter<Size>? _widgetFinish;
  Size? _contextSize;

  PainterController() : _pathHistory = _PathHistory();

  bool get isEmpty => _pathHistory.isEmpty;
  bool get eraseMode => _eraseMode;

  set eraseMode(bool enabled) {
    _eraseMode = enabled;
    _updatePaint();
  }

  Color get drawColor => _drawColor;

  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  double get thickness => _thickness;

  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  void _updatePaint() {
    Paint paint = Paint();
    if (_eraseMode) {
      paint.blendMode = BlendMode.clear;
      paint.color = const Color.fromARGB(0, 255, 0, 0);
    } else {
      paint.color = drawColor;
      paint.blendMode = BlendMode.srcOver;
    }
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = thickness;
    _pathHistory.currentPaint = paint;
    _pathHistory.setBackgroundColor(backgroundColor);
    notifyListeners();
  }

  void undo() {
    if (!isFinished()) {
      _pathHistory.undo();
      notifyListeners();
    }
  }

  void _notifyListeners() {
    notifyListeners();
  }

  void clear() {
    if (!isFinished()) {
      _pathHistory.clear();
      notifyListeners();
    }
  }

  PictureDetails finish() {
    if (!isFinished()) {
      if (_widgetFinish != null) {
        _cached = _render(_widgetFinish!());
      } else {
        throw StateError('Called finish on a PainterController that was not connected to a widget yet!');
      }
    }
    return _cached!;
  }

  bool hasContent() {
    return _pathHistory.hasContent();
  }

  PictureDetails _render(Size size) {
    if (size.isEmpty) {
      throw StateError('Tried to render a picture with an invalid size!');
    } else {
      PictureRecorder recorder = PictureRecorder();
      Canvas canvas = Canvas(recorder);
      _pathHistory.draw(canvas, size);
      return PictureDetails(recorder.endRecording(), size.width.floor(), size.height.floor());
    }
  }

  bool isFinished() {
    return _cached != null;
  }
}
