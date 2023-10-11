import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/methods/geelements_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class POIMethods extends GeoelementsMethods {
  final Set<Marker> markers;
  final Set<Circle> circles;
  late bool mostrar = false;
  late double radiusPoi;
  MaterialColor colorCircle;
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
        fillColor: colorCircle.shade200,
        strokeColor: colorCircle.shade300,
        strokeWidth: 2,
        radius: radiusPoi));
    if (fun != null) {
      fun();
    }
  }

  void changeColorCircle(MaterialColor color, void Function()? fun) {
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
}
