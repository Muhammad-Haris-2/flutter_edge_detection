import 'dart:ui';
import 'package:flutter/material.dart';

class Magnifier extends StatefulWidget {
  const Magnifier({
    super.key,
    required this.child,
    required this.position,
    this.visible = true,
    this.scale = 1.5,
    this.size = const Size(160, 160),
  });

  final Widget child;
  final Offset position;
  final bool visible;
  final double scale;
  final Size size;

  @override
  State<Magnifier> createState() => _MagnifierState();
}

class _MagnifierState extends State<Magnifier> {
  late Size _magnifierSize;
  late double _scale;
  late Matrix4 _matrix;

  @override
  void initState() {
    _magnifierSize = widget.size;
    _scale = widget.scale;
    _calculateMatrix();

    super.initState();
  }

  @override
  void didUpdateWidget(Magnifier oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calculateMatrix();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.visible) _getMagnifier(context),
      ],
    );
  }

  void _calculateMatrix() {
    setState(() {
      double newX = widget.position.dx - (_magnifierSize.width / 2 / _scale);
      double newY = widget.position.dy - (_magnifierSize.height / 2 / _scale);

      if (_bubbleCrossesMagnifier()) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          newX -= ((box.size.width - _magnifierSize.width) / _scale);
        }
      }

      final Matrix4 updatedMatrix = Matrix4.identity()
        ..scale(_scale, _scale)
        ..translate(-newX, -newY);

      _matrix = updatedMatrix;
    });
  }

  Widget _getMagnifier(BuildContext context) {
    return Align(
      alignment: _getAlignment(),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.matrix(_matrix.storage),
          child: CustomPaint(
            painter: const MagnifierPainter(color: Colors.green),
            size: _magnifierSize,
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment() {
    if (_bubbleCrossesMagnifier()) {
      return Alignment.topRight;
    }

    return Alignment.topLeft;
  }

  bool _bubbleCrossesMagnifier() => widget.position.dx < widget.size.width && widget.position.dy < widget.size.height;
}

class MagnifierPainter extends CustomPainter {
  const MagnifierPainter({
    required this.color,
    this.strokeWidth = 5,
  });

  final double strokeWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    _drawCircle(canvas, size);
    // _drawCrosshair(canvas, size);
  }

  void _drawCircle(Canvas canvas, Size size) {
    Paint paintObject = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;

    canvas.drawCircle(size.center(const Offset(0, 0)), size.longestSide / 2, paintObject);
  }

  void _drawCrosshair(Canvas canvas, Size size) {
    Paint crossPaint = Paint()
      ..strokeWidth = strokeWidth / 2
      ..color = color;

    double crossSize = size.longestSide * 0.04;

    canvas.drawLine(size.center(Offset(-crossSize, -crossSize)), size.center(Offset(crossSize, crossSize)), crossPaint);

    canvas.drawLine(size.center(Offset(crossSize, -crossSize)), size.center(Offset(-crossSize, crossSize)), crossPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
