import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WidgetHandIndicator extends StatelessWidget {
  final double height;
  final double width;
  final void Function(TapDownDetails details)? onTap;
  const WidgetHandIndicator({
    super.key,
    required this.height,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onTap,
      onTapDown: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: MovingRectangle()),
            Stack(
              children: [
                // Implement the stroke
                Text(
                  'Mueve el mapa para ubicar el punto',
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..color = Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                // The text inside
                const Text(
                  'Mueve el mapa para ubicar el punto',
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MovingRectangle extends StatefulWidget {
  const MovingRectangle({super.key});

  @override
  State<MovingRectangle> createState() => _MovingRectangleState();
}

class _MovingRectangleState extends State<MovingRectangle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double radius = 15; // Radio del círculo
    double angle = _controller.value * 2 * pi; // Ángulo actual

    // Calcula las coordenadas del rectángulo
    double x = radius * cos(angle);
    double y = radius * sin(angle);

    return Center(
      child: Transform.translate(
        offset: Offset(x, y), // Aplica la traslación
        child: SvgPicture.asset(
          'lib/images/hands.svg',
          semanticsLabel: 'Acme Logo',
          package: 'flutter_maps_creator_v3',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera los recursos del controlador de animación
    super.dispose();
  }
}
