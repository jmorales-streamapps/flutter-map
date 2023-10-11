import 'package:flutter/material.dart';

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  TooltipShapeBorder({
    this.radius = 16.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.bottomCenter.dx + x / 2, rect.bottomCenter.dy)
      ..relativeLineTo(-x / 2 * r, y * r)
      ..relativeQuadraticBezierTo(
          -x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, -y * r);
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: implement paint
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }
}

class TooltipWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;

  const TooltipWidget(
      {super.key, this.width, this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: TooltipShapeBorder(arrowArc: 0.5),
        shadows: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(3.0), child: child),
    );
  }
}
