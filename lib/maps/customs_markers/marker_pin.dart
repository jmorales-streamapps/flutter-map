// Definimos nuestro painter.
import 'dart:math';
// import 'dart:developer' as d;

import 'package:flutter/material.dart';

// aHR0cHM6Ly9kZXYudG8vamxlb25kZXYvZGlidWphci15LWFuaW1hci1jb24tY3VzdG9tcGFpbnRl
// ci1lbi1mbHV0dGVyLTNhZmg=
class PinWithLetter {
  final String letter;

  PinWithLetter(this.letter);
  paint(Canvas canvas, Size size) {
// Necesitamos un lápiz para dibujar
    /*
    final paint2 = Paint()
      ..color = Color.fromARGB(255, 0, 0, 0) // Definimos color (negro)
      ..style = PaintingStyle.stroke // Sólo líneas, sin relleno.
      ..strokeWidth = 8; // Grosor de la línea

    // Vamos a crear un path, para indicarle al lápiz por dónde dibujar.
    final path2 = Path();

    path2.moveTo(0, 0); // Nos movemos al punto inicial
    path2.lineTo(size.width, 0); // →
    path2.lineTo(size.width, size.height); // ↓
    path2.lineTo(0, size.height); // ←
    path2.lineTo(0, 0); // ↑

    canvas.drawPath(path2, paint2);
     */

    // Lapiz que que rellena la forma.
    //final paintFill = Paint()
    //  ..color = Colors.blue
    //  ..style = PaintingStyle.fill;

    // Lapiz que solo delinea.
    final paintStroke = Paint()
      ..strokeWidth = 7.0
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    double bigRadio = size.width / 2.1;

    // Hallamos punto C
    final c = _getC(size);
    // Hallamos punto P
    final p = _getP(size);
    // Radio de la circunferencia exterior.
    // const smallRadio = 15.0;
    // Radio de la círculo interior.

    final path = Path();

    // Hallamos ALFA:
    double alpha = acos(bigRadio / (bigRadio + (p.dy - c.dy)));
    // Dibujamos la circunferencia exterior
    path.addArc(Rect.fromCircle(center: c, radius: bigRadio), pi / 2 + alpha,
        2 * (pi - alpha));
    // Tangente derecha hacia el punto P
    path.lineTo(c.dx, c.dy + bigRadio + (p.dy - c.dy));

    // Tangente izquierda desde el punto P
    path.lineTo(c.dx - bigRadio * sin(alpha), c.dy + bigRadio * cos(alpha));

    canvas.drawPath(path, paintStroke);

    TextSpan span = TextSpan(
      style: TextStyle(
        color: Colors.white,
        fontSize: size.width,
        // backgroundColor: Colors.amber
      ),
      text: letter,
    );
    TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.rtl,
    );
    tp.layout();

    tp.paint(canvas, Offset(c.dx - (tp.width / 2), c.dy - (tp.height / 2)));
  }

  Offset _getC(Size size) {
    return Offset(size.width / 2, size.height / 2.7);
  }

  Offset _getP(
    Size s,
  ) {
    return Offset(s.width, s.height / 1.6);
  }
}
