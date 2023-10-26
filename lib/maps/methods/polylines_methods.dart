import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/customs_markers/marker_generator.dart';
import 'package:flutter_maps_creator_v3/maps/customs_markers/marker_pin.dart';
import 'package:flutter_maps_creator_v3/maps/methods/geelements_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylinesMethods extends GeoelementsMethods {
  final String googleApiKey;
  int? currentPointMove;
  LatLng? currentOrigin, currentDestination, lastConfirmed;
  // LatLng? lastPointA, lastPointB;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  double radius;
  List<LatLng> routePoints = [];
  final Size sizeScreen;
  Map<String, Marker> markers_a_b = {};

  PolylinesMethods(this.googleApiKey, this.radius, this.polylines, this.markers,
      this.sizeScreen) {
    Future.wait([_createMark('A'), _createMark('B')]).then((value) {
      Marker mA = Marker(
          markerId: const MarkerId('pointA'),
          position: const LatLng(0, 0),
          visible: false,
          icon: value[0]);
      Marker mB = Marker(
          markerId: const MarkerId('pointB'),
          position: const LatLng(0, 0),
          visible: false,
          icon: value[1]);

      // Marker(markerId: MarkerId('value'));

      markers_a_b = {'pointA': mA, 'pointB': mB};
    });
  }

  List<LatLng> getRouteByEncodedPoint(String encodedString) {
    return _decodeEncodedPolyline(encodedString);
  }

  setPositions({LatLng? origin, LatLng? destination}) {
    if (origin != null) {
      currentOrigin = origin;
    }
    if (destination != null) {
      currentDestination = destination;
    }
    log("currentOrigin: $currentOrigin\ncurrentDestination:$currentDestination");
  }

  void updateMarkPosition(
      {VoidCallback? fun,
      required String point,
      bool? useCurrentLatlng,
      int? intPosition}) async {
    Marker? oldMark = markers_a_b[point];
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
      if (point == 'pointA') {
        newPostion = currentOrigin!;
      } else if (point == 'pointB') {
        newPostion = currentDestination!;
      }
    }

    if (oldMark != null) {
      if (point == 'pointA') {
        currentOrigin = newPostion;
        // lastPointA = newPostion;
      } else if (point == 'pointB') {
        currentDestination = newPostion;
        // lastPointB = newPostion;
      }
      if ((point == 'pointA' || point == 'pointB')) {
        // log('El punto es: $point\n las coordenadas son: $newPostion');
        Marker newMarker = Marker(
            markerId: MarkerId(point),
            position: newPostion,
            icon: oldMark.icon);
        markers_a_b[point] = newMarker;
        markers.clear();
        markers.addAll(markers_a_b.values);
        if (fun != null) {
          fun();
        }
      }
    }
    // logica para otras marcas que no sean pointA o pointB
    if (intPosition != null && oldMark != null) {
      newPostion = routePoints[intPosition];
      Marker newMarker = Marker(
          markerId: MarkerId(point), position: newPostion, icon: oldMark.icon);
      markers_a_b[point] = newMarker;
      markers.clear();
      markers.addAll(markers_a_b.values);
      if (fun != null) {
        fun();
      }
    }
  }

  void createUniquePolyline(
      {LatLng? position, double? rad, VoidCallback? fun}) {
    radius = rad ?? radius;
    // currentPosition = position ?? currentPosition;

    // markers.clear();
    // circles.clear();
    polylines.clear();
    polylines.add(
        Polyline(polylineId: const PolylineId('unique'), points: routePoints));

    if (fun != null) {
      fun();
    }
  }

  List<LatLng> _decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  void setMapFitToTour(
      Set<Polyline> p,
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

  Future<void> focusPolyLine(Set<Polyline> p) async {
    Completer<void> c = Completer();
    setMapFitToTour(p, (minLat, minLong, maxLat, maxLong) async {
      await controller.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong),
          ),
          20));
      c.complete();
    });
    await c.future;
  }
}
