import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/customs_markers/marker_generator.dart';
import 'package:flutter_maps_creator_v3/maps/customs_markers/marker_pin.dart';
import 'package:flutter_maps_creator_v3/maps/methods/geelements_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonesMethods extends GeoelementsMethods {
  final String googleApiKey;
  int? currentPointMove;
  LatLng? currentOrigin, lastConfirmed;
  final Set<Marker> markers;
  final Set<Polygon> polygones;
  final Set<Circle> circles;

  MaterialColor colorCircle;

  double radius;
  List<LatLng> routePoints = [];
  final Size sizeScreen;
  Map<String, Marker> markers_a_b = {};

  PolygonesMethods(this.googleApiKey, this.radius, this.polygones, this.markers,
      this.sizeScreen, this.circles,
      {this.colorCircle = Colors.blue}) {
    Future.wait([_createMark('')]).then((value) {
      Marker mA = Marker(
          markerId: const MarkerId('pointA'),
          position: const LatLng(0, 0),
          visible: false,
          icon: value[0]);

      // Marker(markerId: MarkerId('value'));

      markers_a_b = {'pointA': mA};
    });
  }

  void updateMarkPosition(
      {VoidCallback? fun,
      bool? useCurrentLatlng,
      int? intPosition,
      bool withCircle = false}) async {
    Marker? oldMark = markers_a_b['pointA'];
    late LatLng newPostion;
    if (useCurrentLatlng == null) {
      newPostion = await controller.getLatLng(ScreenCoordinate(
          x: sizeScreen.width ~/ 2, y: sizeScreen.height ~/ 2));
    }
    if (useCurrentLatlng != null && !useCurrentLatlng) {
      newPostion = await controller.getLatLng(ScreenCoordinate(
          x: sizeScreen.width ~/ 2, y: sizeScreen.height ~/ 2));
    }
    if (useCurrentLatlng != null && useCurrentLatlng) {
      newPostion = currentOrigin!;
    }

    if (oldMark != null) {
      currentOrigin = newPostion;

      Marker newMarker = Marker(
          markerId: const MarkerId('pointA'),
          position: newPostion,
          icon: oldMark.icon);

      markers_a_b['pointA'] = newMarker;
      markers.clear();
      circles.clear();

      markers.addAll(markers_a_b.values);
      if (withCircle) {
        circles.add(Circle(
            circleId: const CircleId('unique'),
            center: newPostion,
            fillColor: colorCircle.shade200,
            strokeColor: colorCircle.shade300,
            strokeWidth: 2,
            radius: radius));
      }

      if (fun != null) {
        fun();
      }
    }
    if (intPosition != null && oldMark != null) {
      newPostion = routePoints[intPosition];
      Marker newMarker = Marker(
          markerId: const MarkerId('pointA'),
          position: newPostion,
          icon: oldMark.icon);
      markers_a_b['pointA'] = newMarker;
      markers.clear();
      circles.clear();

      markers.addAll(markers_a_b.values);
      if (withCircle) {
        circles.add(Circle(
            circleId: const CircleId('unique'),
            center: newPostion,
            fillColor: colorCircle.shade200,
            strokeColor: colorCircle.shade300,
            strokeWidth: 2,
            radius: radius));
      }

      if (fun != null) {
        fun();
      }
    }
  }

  void createUniquePolygone(
      {LatLng? position, double? rad, VoidCallback? fun}) {
    radius = rad ?? radius;
    // currentPosition = position ?? currentPosition;

    // markers.clear();
    // circles.clear();
    polygones.clear();
    polygones.add(Polygon(
        polygonId: const PolygonId('unique'),
        points: routePoints,
        fillColor: Colors.blue.shade200,
        strokeWidth: 1,
        strokeColor: Colors.blue));

    if (fun != null) {
      fun();
    }
  }

  void setMapFitToTour(
      Set<Polygon> p,
      Function(double minLat, double minLong, double maxLat, double maxLong)?
          fun) {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    for (var poly in p) {
      for (var point in poly.points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      }
    }
    if (fun != null) {
      fun(minLat, minLong, maxLat, maxLong);
    }
  }

  Future<BitmapDescriptor> _createMark(letter) {
    return MarkerGenerator.createBitmapDescriptor(
        sizeMarker: 0,
        sizeCustom2: const Size(100, 150),
        canvasFuntion: (canvas, size) {
          PinWithLetter(letter).paint(canvas, size);
        });
  }
}
