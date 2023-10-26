import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/methods/geelements_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class POIMethods extends GeoelementsMethods {
  final Set<Marker> markers;
  final Set<Circle> circles;
  late bool mostrar = false;
  late double radiusPoi;
  Color colorCircle;
  late LatLng currentPosition;

  POIMethods(this.markers, this.circles, this.radiusPoi, this.currentPosition,
      {this.colorCircle = Colors.blue});

  void createUniquePOI({LatLng? position, double? radius, VoidCallback? fun}) {
    radiusPoi = radius ?? radiusPoi;
    currentPosition = position ?? currentPosition;

    markers.clear();
    circles.clear();
    markers.add(Marker(
        markerId: const MarkerId('unique'),
        position: currentPosition,
        icon: iconMark));
    circles.add(Circle(
        circleId: const CircleId('unique'),
        center: currentPosition,
        fillColor: colorCircle.withOpacity(0.2),
        strokeColor: colorCircle.withOpacity(0.3),
        strokeWidth: 2,
        radius: radiusPoi));
    if (fun != null) {
      fun();
    }
  }

  void changeColorCircle(Color color, {void Function()? fun}) {
    log('changeColorCircle:: $color');
    colorCircle = color;
    createUniquePOI(
      fun: fun,
    );
  }

  void changeRadius({double? radius, Operation? op, void Function()? fun}) {
    if (radius == null && op == Operation.add) {
      radius = ++radiusPoi;
    } else if (radius == null && op == Operation.suscratract) {
      radius = --radiusPoi;
    }
    // log("radius:: $radius\nop: $op");
    createUniquePOI(
      radius: radius,
      fun: fun,
    );
  }

  Future<void> focusCircle({LatLng? location, double? radio}) async {
    await controller.animateCamera(CameraUpdate.newLatLngZoom(
        location ?? this.currentPosition,
        getZoomLevel(radio ?? this.radiusPoi)));
  }

  double getZoomLevel(double radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - math.log(scale) / math.log(2);
    }
    zoomLevel = double.parse(zoomLevel.toStringAsFixed(2));
    return zoomLevel;
  }

  MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }
}
