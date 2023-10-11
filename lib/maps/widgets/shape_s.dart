import 'package:flutter/material.dart';

class DurmaShape extends ShapeBorder {
  const DurmaShape({
    required this.borderRadius,
    this.offset = Offset.zero,
    this.side = BorderSide.none,
  });

  final Radius borderRadius;
  final Offset offset;
  final BorderSide side;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  Path _getPath(Rect rect) {
    return Path.combine(
      PathOperation.difference,
      Path()
        ..addRRect(RRect.fromRectAndRadius(rect, borderRadius))
        ..close(),
      Path()
        ..addOval(Rect.fromCircle(
          center: Offset(rect.width * .933, rect.height / 2),
          radius: rect.height * .75,
        ))
        ..close(),
    );
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side != BorderSide.none) {
      canvas.drawPath(
        _getPath(rect),
        side.toPaint(),
      );
    }
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }
}
