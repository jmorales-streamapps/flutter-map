import 'dart:ui' as UI;
import 'package:flutter/material.dart';

class MarkerWithImage {
  final Color color;
  final UI.Image image;
  MarkerWithImage({this.color = Colors.black, required this.image});

  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double radio = size.width * 0.35;
    final double x0 = width * 0.5;
    final double y0 = radio;
    const double strokePunta = 1.10;

    //
    final pathAncla = Path();
    final paint = Paint()
      //..color = color
      ..color = color
      //..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    //
    pathAncla.moveTo(x0 + strokePunta, height);

    pathAncla.quadraticBezierTo(
        (x0 + 20), (y0 + radio + 20), (x0 + radio * 0.7), (y0 + radio * 0.7));
    pathAncla.quadraticBezierTo(
        x0, radio * 2 + 20, (x0 - radio * 0.7), (y0 + radio * 0.7));
    pathAncla.quadraticBezierTo(
        (x0 - 20), (y0 + radio + 20), x0 - strokePunta, height);
    //

    canvas.drawPath(pathAncla, paint); // la punta

    Path circuloExterior = Path()
      ..addOval(Rect.fromCircle(center: Offset(x0, y0), radius: radio));
    Path circuloInterior = Path()
      ..addOval(Rect.fromCircle(center: Offset(x0, y0), radius: radio * 0.75));

    canvas.drawPath(circuloExterior, paint);
    canvas.clipPath(circuloInterior);

    //canvas.drawImage(image, Offset(-image.width.toDouble() / 3, 0), Paint()); // la imagen

    drawImageResized(canvas, image, size);
  }

  // Para redimencionar la imagen
  void drawImageResized(Canvas canvas, UI.Image image, Size size) {
    final UI.Rect rect = UI.Offset.zero & size;
    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());
    FittedSizes sizes = applyBoxFit(BoxFit.fitHeight, imageSize, size);
    final Rect inputSubrect =
        Alignment.topCenter.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect =
        Alignment.topCenter.inscribe(sizes.destination, rect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, Paint());
  }
}
