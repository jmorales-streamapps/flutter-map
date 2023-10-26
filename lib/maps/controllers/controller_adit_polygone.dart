import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/methods/polygones_methods.dart';
import 'package:flutter_maps_creator_v3/maps/models/enums.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ControllerMapEditPolygone extends GetxController {
  RxInt secondsRemaining = 0.obs;
  Timer? _timer;
  late GoogleMapController controllerL;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Polygon> polygones = <Polygon>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;
  PolygonesMethods? polyMethods;
  // TypePoint typePoint = TypePoint.PointA;
  bool buttonNextActivate = false;
  bool buttonBackActivate = false;
  TypeGeofence typeGeofence = TypeGeofence.Circle;

  // bool isMovingMark = false;

  @override
  void onInit() async {
    polyMethods = PolygonesMethods(
        'AIzaSyBCoP5uyue_O8pMJtZOi60mAxKYkP-Ym3w',
        50,
        polygones,
        markers,
        Size(Get.width * Get.pixelRatio, Get.height * Get.pixelRatio),
        circles);

    super.onInit();
  }

  void onCameraMove(CameraPosition cameraPosition) {
    // log("onCameraMove");
    _cancelTime();

    if (typeGeofence == TypeGeofence.Circle) {
      polyMethods?.updateMarkPosition(
        useCurrentLatlng: false,
        withCircle: true,
        fun: () {
          update(['update_map']);
        },
      );
    } else {
      polyMethods?.updateMarkPosition(
        useCurrentLatlng: false,
        fun: () {
          update(['update_map']);
        },
      );
      //
      LatLng? currentPointMove = polyMethods!.currentOrigin;

      if (currentPointMove != null) {
        if (polyMethods!.currentPointMove != null) {
          if (currentPointMove == polyMethods!.polygones.first.points.last) {
            log('Son los mismos');
            polyMethods!.currentPointMove !=
                polyMethods!.routePoints.length - 1;
          } else {
            log('Son diferentes');
            polyMethods!.routePoints[polyMethods!.currentPointMove!] =
                currentPointMove;
            polyMethods?.createUniquePolygone();
          }
          log('Forma 1');
        } else if (polyMethods!.routePoints.length - 1 >= 0) {
          polyMethods!.routePoints[polyMethods!.routePoints.length - 1] =
              currentPointMove;
          polyMethods?.createUniquePolygone();
        }
      }

      polyMethods!.circles.clear();
    }
  }

  void toBackAndToPoint(TypeAction action) {
    log('toBackAndToPoint');
    log('TypeAction:        $action');
    log('polyMethods!.currentPointMove:B: ${polyMethods!.currentPointMove}');
    log('polyMethods!.polylines.first.points.length: ${polyMethods!.polygones.first.points.length}');
    log('');
    if (polyMethods!.polygones.isNotEmpty &&
        polyMethods!.polygones.first.points.isNotEmpty &&
        polyMethods!.polygones.first.points.length >= 2) {
      // if (polyMethods!.currentPointMove != null) {
      if (action == TypeAction.Back) {
        if (polyMethods!.currentPointMove == null) {
          polyMethods!.currentPointMove =
              polyMethods!.polygones.first.points.length - 1;
        }
        if (polyMethods!.currentPointMove! - 1 >= 0) {
          polyMethods!.currentPointMove = polyMethods!.currentPointMove! - 1;
        }
      } else if (action == TypeAction.To) {
        if (polyMethods!.currentPointMove != null &&
            polyMethods!.currentPointMove! + 1 <
                polyMethods!.routePoints.length) {
          polyMethods!.currentPointMove = polyMethods!.currentPointMove! + 1;
          // log('El ultimo punto, y el pretendido son los mismos?: ${(polyMethods!.polylines.first.points.last == polyMethods!.routePoints[polyMethods!.currentPointMove!]).toString()}');
          if (polyMethods!.polygones.first.points.last ==
              polyMethods!.routePoints[polyMethods!.currentPointMove!]) {
            polyMethods!.currentPointMove = null;
          }
        }
      }

      if (polyMethods!.currentPointMove != null) {
        if (polyMethods!.currentPointMove! > 0) {
          buttonBackActivate = true;
        } else {
          buttonBackActivate = false;
        }

        if (polyMethods!.currentPointMove! <
            polyMethods!.polygones.first.points.length - 1) {
          buttonNextActivate = true;
        } else {
          buttonNextActivate = false;
        }
        update(['area_buttons']);
      } else {
        update(['area_buttons']);

        buttonNextActivate = false;
      }
      // }

      log('polyMethods!.currentPointMove:A: ${polyMethods!.currentPointMove}');
      int movePoint =
          polyMethods!.currentPointMove ?? polyMethods!.routePoints.length - 1;
      controllerL
          .moveCamera(
              CameraUpdate.newLatLng(polyMethods!.routePoints[movePoint]))
          .then((v) {
        Future.delayed(const Duration(milliseconds: 200), () {
          updatePointA(intPosition: movePoint, updateMap: false);

          update(['update_map']);
        });
      });
    } else {
      log('no hay puntos');
    }
  }

  void updatePointA({int? intPosition, bool updateMap = true}) {
    polyMethods!.updateMarkPosition(
      intPosition: intPosition,
      fun: () {
        if (updateMap) {
          update(['update_map']);
        }
      },
    );
  }

  Future<void> moveToCurrentPoint(TypePoint newTypePoint) async {
    LatLng? latLng;
    if (newTypePoint == TypePoint.PointA) {
      latLng = polyMethods!.currentOrigin;
    }
    if (latLng != null) {
      await polyMethods!.moveWithOutAnimated(latLng);
    }
  }

  void addPoint() {
    LatLng newLatlng = polyMethods!.currentOrigin!;

    Polygon oldPoly =
        Polygon(polygonId: const PolygonId('value'), points: [newLatlng]);
    if (polyMethods!.polygones.isNotEmpty) {
      oldPoly = polyMethods!.polygones.first;
    } else {
      // si esta vacio
      polyMethods!.polygones.add(oldPoly);
    }
    log('addPoint');
    log('oldPoly.points.length:B: ${oldPoly.points.length}');
    log('newLatlng:: $newLatlng');
    log('oldPoly.points.last: ${oldPoly.points.last}');
    //if (oldPoly.points.last != newLatlng) {
    if (_isMedium(polyMethods!.routePoints, newLatlng)) {
      log('_isMedium::  ');

      /// si esta en medio agregar otro punto a partir de donde se encontro
      oldPoly.points.insert(polyMethods!.routePoints.indexOf(newLatlng),
          LatLng(newLatlng.latitude, newLatlng.longitude));
    } else {
      oldPoly.points.add(newLatlng);
    }

    //}
    polyMethods!.lastConfirmed = newLatlng;
    polyMethods!.routePoints = oldPoly.points; // se agrega los puntos internos
    // polyMethods!.createUniquePolyline();
    // isMovingMark = true; // se habilita el movimiento de la marka
    if (polyMethods!.routePoints.isNotEmpty) {
      buttonBackActivate = true;
      update(['area_buttons']);
    }
    log('oldPoly.points.length:A: ${oldPoly.points.length}');

    log('');
    update(['update_map']);
  }

  void removePoint() {
    if (polyMethods!.polygones.isNotEmpty &&
        polyMethods!.polygones.first.points.isNotEmpty) {
      if (polyMethods!.currentPointMove == null) {
        polyMethods!.routePoints.removeLast();
        // polyMethods!.polygones.first.points.removeLast();
      } else {
        if (polyMethods!.currentPointMove! >= 0) {
          polyMethods!.routePoints.removeAt(polyMethods!.currentPointMove!);
        }
        // polyMethods!.currentPointMove = polyMethods!.currentPointMove! - 1;
      }
      polyMethods!.createUniquePolygone();

      // isMovingMark = true; // se habilita el movimiento de la marka
      update(['update_map']);
    }
  }

  void startTimer() {
    secondsRemaining.value = 5;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // log('_timer = Timer.periodic(const Duration(seconds: 1), (timer) { $secondsRemaining');
      if (secondsRemaining > 0) {
        secondsRemaining--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void handleTap(TapDownDetails details) {
    _cancelTime();
  }

  void _cancelTime() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      secondsRemaining.value = 0;
    }
  }

  bool _isMedium(List list, element) {
    var indice = list.indexOf(element);
    bool tieneElementoAntes = indice > 0;
    bool tieneElementoDespues = indice < list.length - 1;
    return tieneElementoAntes && tieneElementoDespues;
  }
}
