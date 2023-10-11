import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = Colors.red;
    ;
    path = Path();
    path.lineTo(size.width * 0.79, size.height * 1.29);
    path.cubicTo(size.width * 0.68, size.height * 1.27, size.width * 0.61,
        size.height * 1.19, size.width * 0.62, size.height * 1.1);
    path.cubicTo(size.width * 0.63, size.height * 1.07, size.width * 0.64,
        size.height * 1.05, size.width * 0.65, size.height * 1.04);
    path.cubicTo(size.width * 0.66, size.height * 1.03, size.width * 0.69,
        size.height * 1.03, size.width * 0.7, size.height * 1.05);
    path.cubicTo(size.width * 0.7, size.height * 1.05, size.width * 0.69,
        size.height * 1.06, size.width * 0.69, size.height * 1.07);
    path.cubicTo(size.width * 0.68, size.height * 1.09, size.width * 0.68,
        size.height * 1.13, size.width * 0.68, size.height * 1.16);
    path.cubicTo(size.width * 0.71, size.height * 1.22, size.width * 0.78,
        size.height * 1.26, size.width * 0.86, size.height * 1.25);
    path.cubicTo(size.width * 0.93, size.height * 1.24, size.width * 0.98,
        size.height * 1.2, size.width, size.height * 1.14);
    path.cubicTo(size.width, size.height * 1.12, size.width, size.height * 1.1,
        size.width * 0.98, size.height * 1.06);
    path.cubicTo(size.width * 0.97, size.height * 1.05, size.width * 0.97,
        size.height * 1.05, size.width * 0.98, size.height * 1.04);
    path.cubicTo(size.width, size.height * 1.03, size.width, size.height * 1.03,
        size.width, size.height * 1.03);
    path.cubicTo(size.width * 1.03, size.height * 1.04, size.width * 1.05,
        size.height * 1.08, size.width * 1.05, size.height * 1.12);
    path.cubicTo(size.width * 1.05, size.height * 1.22, size.width * 0.96,
        size.height * 1.29, size.width * 0.84, size.height * 1.3);
    path.cubicTo(size.width * 0.82, size.height * 1.3, size.width * 0.8,
        size.height * 1.3, size.width * 0.79, size.height * 1.29);
    path.cubicTo(size.width * 0.79, size.height * 1.29, size.width * 0.79,
        size.height * 1.29, size.width * 0.79, size.height * 1.29);
    canvas.drawPath(path, paint);

    // Path number 2

    paint.color = Colors.red;
    ;
    path = Path();
    path.lineTo(size.width * 0.42, size.height * 1.23);
    path.cubicTo(size.width * 0.41, size.height * 1.23, size.width / 3,
        size.height * 1.16, size.width * 0.32, size.height * 1.15);
    path.cubicTo(size.width * 0.32, size.height * 1.15, size.width * 0.32,
        size.height * 1.14, size.width * 0.32, size.height * 1.14);
    path.cubicTo(size.width * 0.32, size.height * 1.13, size.width * 0.38,
        size.height * 1.08, size.width * 0.41, size.height * 1.06);
    path.cubicTo(size.width * 0.42, size.height * 1.05, size.width * 0.43,
        size.height * 1.05, size.width * 0.45, size.height * 1.06);
    path.cubicTo(size.width * 0.46, size.height * 1.07, size.width * 0.46,
        size.height * 1.08, size.width * 0.44, size.height * 1.1);
    path.cubicTo(size.width * 0.42, size.height * 1.11, size.width * 0.42,
        size.height * 1.11, size.width * 0.49, size.height * 1.12);
    path.cubicTo(size.width * 0.52, size.height * 1.12, size.width * 0.54,
        size.height * 1.12, size.width * 0.55, size.height * 1.12);
    path.cubicTo(size.width * 0.56, size.height * 1.13, size.width * 0.56,
        size.height * 1.14, size.width * 0.56, size.height * 1.15);
    path.cubicTo(size.width * 0.56, size.height * 1.16, size.width * 0.55,
        size.height * 1.17, size.width * 0.49, size.height * 1.17);
    path.cubicTo(size.width * 0.45, size.height * 1.17, size.width * 0.43,
        size.height * 1.18, size.width * 0.43, size.height * 1.18);
    path.cubicTo(size.width * 0.43, size.height * 1.18, size.width * 0.43,
        size.height * 1.18, size.width * 0.44, size.height * 1.19);
    path.cubicTo(size.width * 0.45, size.height * 1.2, size.width * 0.45,
        size.height * 1.21, size.width * 0.45, size.height * 1.21);
    path.cubicTo(size.width * 0.45, size.height * 1.22, size.width * 0.44,
        size.height * 1.23, size.width * 0.44, size.height * 1.23);
    path.cubicTo(size.width * 0.44, size.height * 1.23, size.width * 0.43,
        size.height * 1.24, size.width * 0.43, size.height * 1.24);
    path.cubicTo(size.width * 0.43, size.height * 1.24, size.width * 0.42,
        size.height * 1.24, size.width * 0.42, size.height * 1.23);
    path.cubicTo(size.width * 0.42, size.height * 1.23, size.width * 0.42,
        size.height * 1.23, size.width * 0.42, size.height * 1.23);
    canvas.drawPath(path, paint);

    // Path number 3

    paint.color = Colors.red;
    ;
    path = Path();
    path.lineTo(size.width * 1.22, size.height * 1.23);
    path.cubicTo(size.width * 1.2, size.height * 1.23, size.width * 1.2,
        size.height * 1.21, size.width * 1.22, size.height * 1.19);
    path.cubicTo(size.width * 1.23, size.height * 1.18, size.width * 1.24,
        size.height * 1.18, size.width * 1.23, size.height * 1.18);
    path.cubicTo(size.width * 1.23, size.height * 1.18, size.width * 1.21,
        size.height * 1.17, size.width * 1.17, size.height * 1.17);
    path.cubicTo(size.width * 1.12, size.height * 1.17, size.width * 1.11,
        size.height * 1.17, size.width * 1.11, size.height * 1.16);
    path.cubicTo(size.width * 1.09, size.height * 1.15, size.width * 1.1,
        size.height * 1.13, size.width * 1.12, size.height * 1.12);
    path.cubicTo(size.width * 1.12, size.height * 1.12, size.width * 1.14,
        size.height * 1.12, size.width * 1.17, size.height * 1.12);
    path.cubicTo(size.width * 1.24, size.height * 1.11, size.width * 1.24,
        size.height * 1.11, size.width * 1.22, size.height * 1.1);
    path.cubicTo(size.width * 1.2, size.height * 1.08, size.width * 1.2,
        size.height * 1.06, size.width * 1.22, size.height * 1.06);
    path.cubicTo(size.width * 1.23, size.height * 1.04, size.width * 1.24,
        size.height * 1.05, size.width * 1.28, size.height * 1.08);
    path.cubicTo(size.width * 1.36, size.height * 1.15, size.width * 1.35,
        size.height * 1.14, size.width * 1.29, size.height * 1.19);
    path.cubicTo(size.width * 1.26, size.height * 1.23, size.width * 1.24,
        size.height * 1.24, size.width * 1.23, size.height * 1.24);
    path.cubicTo(size.width * 1.23, size.height * 1.24, size.width * 1.23,
        size.height * 1.24, size.width * 1.22, size.height * 1.23);
    path.cubicTo(size.width * 1.22, size.height * 1.23, size.width * 1.22,
        size.height * 1.23, size.width * 1.22, size.height * 1.23);
    canvas.drawPath(path, paint);

    // Path number 4

    paint.color = Colors.red;
    ;
    path = Path();
    path.lineTo(size.width * 0.82, size.height * 1.19);
    path.cubicTo(size.width * 0.79, size.height * 1.18, size.width * 0.77,
        size.height * 1.17, size.width * 0.76, size.height * 1.15);
    path.cubicTo(size.width * 0.75, size.height * 1.13, size.width * 0.75,
        size.height * 1.13, size.width * 0.75, size.height * 0.89);
    path.cubicTo(size.width * 0.75, size.height * 0.64, size.width * 0.75,
        size.height * 0.64, size.width * 0.75, size.height * 0.63);
    path.cubicTo(size.width * 0.74, size.height * 0.63, size.width * 0.73,
        size.height * 0.63, size.width * 0.72, size.height * 0.64);
    path.cubicTo(size.width * 0.71, size.height * 0.64, size.width * 0.68,
        size.height * 0.67, size.width * 0.65, size.height * 0.71);
    path.cubicTo(size.width * 0.6, size.height * 0.76, size.width * 0.59,
        size.height * 0.77, size.width * 0.58, size.height * 0.78);
    path.cubicTo(size.width * 0.55, size.height * 0.79, size.width * 0.52,
        size.height * 0.79, size.width / 2, size.height * 0.78);
    path.cubicTo(size.width * 0.47, size.height * 0.76, size.width * 0.45,
        size.height * 0.73, size.width * 0.46, size.height * 0.7);
    path.cubicTo(size.width * 0.46, size.height * 0.69, size.width * 0.48,
        size.height * 0.67, size.width * 0.53, size.height * 0.61);
    path.cubicTo(size.width * 0.56, size.height * 0.56, size.width * 0.62,
        size.height * 0.49, size.width * 0.66, size.height * 0.44);
    path.cubicTo(size.width * 0.69, size.height * 0.39, size.width * 0.73,
        size.height * 0.34, size.width * 0.74, size.height / 3);
    path.cubicTo(size.width * 0.75, size.height * 0.31, size.width * 0.81,
        size.height * 0.26, size.width * 0.84, size.height / 4);
    path.cubicTo(size.width, size.height * 0.16, size.width * 1.2,
        size.height * 0.17, size.width * 1.33, size.height * 0.28);
    path.cubicTo(size.width * 1.39, size.height * 0.32, size.width * 1.43,
        size.height * 0.38, size.width * 1.45, size.height * 0.45);
    path.cubicTo(size.width * 1.45, size.height * 0.47, size.width * 1.45,
        size.height * 0.49, size.width * 1.46, size.height * 0.62);
    path.cubicTo(size.width * 1.46, size.height * 0.78, size.width * 1.46,
        size.height * 0.78, size.width * 1.43, size.height * 0.8);
    path.cubicTo(size.width * 1.4, size.height * 0.82, size.width * 1.37,
        size.height * 0.83, size.width * 1.34, size.height * 0.81);
    path.cubicTo(size.width * 1.33, size.height * 0.81, size.width * 1.31,
        size.height * 0.8, size.width * 1.31, size.height * 0.8);
    path.cubicTo(size.width * 1.3, size.height * 0.79, size.width * 1.29,
        size.height * 0.78, size.width * 1.28, size.height * 0.79);
    path.cubicTo(size.width * 1.28, size.height * 0.79, size.width * 1.28,
        size.height * 0.8, size.width * 1.27, size.height * 0.81);
    path.cubicTo(size.width * 1.27, size.height * 0.84, size.width * 1.23,
        size.height * 0.87, size.width * 1.19, size.height * 0.87);
    path.cubicTo(size.width * 1.16, size.height * 0.87, size.width * 1.13,
        size.height * 0.85, size.width * 1.12, size.height * 0.83);
    path.cubicTo(size.width * 1.11, size.height * 0.81, size.width * 1.1,
        size.height * 0.81, size.width * 1.1, size.height * 0.83);
    path.cubicTo(size.width * 1.09, size.height * 0.87, size.width * 1.07,
        size.height * 0.89, size.width * 1.03, size.height * 0.9);
    path.cubicTo(size.width, size.height * 0.9, size.width, size.height * 0.9,
        size.width * 0.97, size.height * 0.89);
    path.cubicTo(size.width * 0.95, size.height * 0.88, size.width * 0.93,
        size.height * 0.85, size.width * 0.93, size.height * 0.84);
    path.cubicTo(size.width * 0.93, size.height * 0.82, size.width * 0.93,
        size.height * 0.82, size.width * 0.92, size.height * 0.82);
    path.cubicTo(size.width * 0.92, size.height * 0.82, size.width * 0.92,
        size.height * 0.84, size.width * 0.92, size.height * 0.97);
    path.cubicTo(size.width * 0.92, size.height * 1.07, size.width * 0.92,
        size.height * 1.13, size.width * 0.92, size.height * 1.14);
    path.cubicTo(size.width * 0.9, size.height * 1.17, size.width * 0.86,
        size.height * 1.19, size.width * 0.82, size.height * 1.19);
    path.cubicTo(size.width * 0.82, size.height * 1.19, size.width * 0.82,
        size.height * 1.19, size.width * 0.82, size.height * 1.19);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
