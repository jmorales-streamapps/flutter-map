import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/methods/polylines_methods.dart';
import 'package:flutter_maps_creator_v3/maps/models/enums.dart';
import 'package:flutter_maps_creator_v3/maps/models/prediction.dart';
import 'package:flutter_maps_creator_v3/maps/providers/google_maps_api.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ControllerMapEditPolyline extends GetxController {
  RxInt secondsRemaining = 0.obs;
  Timer? _timer;
  late GoogleMapController controllerL;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  PolylinesMethods? polyMethods;
  TypePoint typePoint = TypePoint.PointNull;
  bool buttonNextActivate = false;
  bool buttonBackActivate = false;

  // bool isMovingMark = false;

  @override
  void onInit() async {
    polyMethods = PolylinesMethods(
        'AIzaSyBCoP5uyue_O8pMJtZOi60mAxKYkP-Ym3w',
        50,
        polylines,
        markers,
        Size(Get.width * Get.pixelRatio, Get.height * Get.pixelRatio));

    super.onInit();
  }

  void onCameraMove(CameraPosition cameraPosition) {
    // log("onCameraMove");
    _cancelTime();

    if (typePoint == TypePoint.PointA) {
      updatePointA();
    } else if (typePoint == TypePoint.PointB) {
      updatePointB();
    }
    if (polyMethods!.currentDestination != null &&
        polyMethods!.currentPointMove == null) {
      // es para que se muestre la ventanida de informacion al marcar el punto y y b
      // b es currentDestination y si no es nulo es porque se termino de marcar el b
      update(['update_info_window']);
    }
    if (typePoint != TypePoint.PointNull) {
      //
      LatLng? currentPointMove;
      if (typePoint == TypePoint.PointA) {
        currentPointMove = polyMethods!.currentOrigin;
      }
      if (typePoint == TypePoint.PointB) {
        currentPointMove = polyMethods!.currentDestination;
      }
      if (currentPointMove != null) {
        if (polyMethods!.currentPointMove != null) {
          log('polyMethods!.currentPointMove::: ${polyMethods!.currentPointMove}\npolyMethods!.routePoints.length::: ${polyMethods!.routePoints.length}\npolyMethods!.polylines.first.points.length::: ${polyMethods!.polylines.first.points.length}');
          log('');
          // log('polyMethods!.currentPointMove::: ${polyMethods!.currentPointMove}\npolyMethods!.routePoints.length::: ${polyMethods!.routePoints.length}\npolyMethods!.polylines.first.points.length::: ${polyMethods!.polylines.first.points.length}');

          if (currentPointMove == polyMethods!.polylines.first.points.last) {
            log('Son los mismos');
            polyMethods!.currentPointMove !=
                polyMethods!.routePoints.length - 1;
          } else {
            log('Son diferentes');
            polyMethods!.routePoints[polyMethods!.currentPointMove!] =
                currentPointMove;
            polyMethods?.createUniquePolyline();
            log('Se repite en la lista??:  ${_elementoSeRepite(polyMethods!.routePoints, polyMethods!.currentPointMove!)}');
          }
          log('Forma 1');
        } else if (polyMethods!.routePoints.length - 1 >= 0) {
          //} else {
          polyMethods!.routePoints[polyMethods!.routePoints.length - 1] =
              currentPointMove;
          polyMethods?.createUniquePolyline();
          // log('Forma 2');

          // polyMethods!.routePoints.add(currentPointMove);
        }

        // log('polyMethods!.currentPointMove! :: ${polyMethods!.currentPointMove!}');
      }
    }
  }

  Future<void> traceRoute(Prediction origin, Prediction destination) async {
    // log('Hubo cambio en las rutas');
    // log('origin ::  ${origin.latLng.toJson().toString()}');
    // log('destiny::  ${destination.latLng.toJson().toString()}');
    await traceRouteLatLng(origin.latLng, destination.latLng);
  }

  Future<void> traceRouteLatLng(LatLng origin, LatLng destination) async {
    Map<String, dynamic> routes = await MiClienteHttp()
        .getRoutes(origin: origin, destination: destination);

    for (var route in routes['routes']) {
      List<LatLng> routePoints = polyMethods!
          .getRouteByEncodedPoint(route['overview_polyline']['points']);
      polyMethods?.routePoints = routePoints;
      polyMethods?.createUniquePolyline(
        fun: () {
          update(['update_map']);
          polyMethods!.setMapFitToTour(polylines,
              (minLat, minLong, maxLat, maxLong) {
            controllerL.moveCamera(CameraUpdate.newLatLngBounds(
                LatLngBounds(
                    southwest: LatLng(minLat, minLong),
                    northeast: LatLng(maxLat, maxLong)),
                Get.width * .4));
          });
        },
      );
      break;
    }
  }

  void toBackAndToPoint(TypeAction action) {
    log('toBackAndToPoint');
    log('TypeAction:        $action');
    log('polyMethods!.currentPointMove:B: ${polyMethods!.currentPointMove}');
    log('polyMethods!.polylines.first.points.length: ${polyMethods!.polylines.first.points.length}');
    log('');
    if (typePoint != TypePoint.PointNull) {
      if (polyMethods!.polylines.isNotEmpty &&
          polyMethods!.polylines.first.points.isNotEmpty &&
          polyMethods!.polylines.first.points.length >= 2) {
        // if (polyMethods!.currentPointMove != null) {
        if (action == TypeAction.Back) {
          if (polyMethods!.currentPointMove == null) {
            polyMethods!.currentPointMove =
                polyMethods!.polylines.first.points.length - 1;
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
            if (polyMethods!.polylines.first.points.last ==
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
              polyMethods!.polylines.first.points.length - 1) {
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
        if (typePoint != TypePoint.PointNull) {
          int movePoint = polyMethods!.currentPointMove ??
              polyMethods!.routePoints.length - 1;
          controllerL
              .moveCamera(
                  CameraUpdate.newLatLng(polyMethods!.routePoints[movePoint]))
              .then((v) {
            Future.delayed(const Duration(milliseconds: 200), () {
              if (typePoint == TypePoint.PointA) {
                updatePointA(intPosition: movePoint, updateMap: false);
              } else if (typePoint == TypePoint.PointB) {
                updatePointB(intPosition: movePoint, updateMap: false);
              }
              update(['update_map']);
            });
          });
        }
      } else {
        log('no hay puntos');
      }
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
        point: 'pointA');
  }

  void updatePointB({int? intPosition, bool updateMap = true}) {
    polyMethods!.updateMarkPosition(
        intPosition: intPosition,
        fun: () {
          if (updateMap) {
            update(['update_map']);
          }
        },
        point: 'pointB');
  }

  void updatePointAB() {
    polyMethods!.updateMarkPosition(point: 'pointA', useCurrentLatlng: true);
    polyMethods!.updateMarkPosition(point: 'pointB', useCurrentLatlng: true);
    update(['update_map']);
  }

  Future<void> moveToCurrentPoint(TypePoint newTypePoint) async {
    LatLng? latLng;
    if (newTypePoint == TypePoint.PointA) {
      latLng = polyMethods!.currentOrigin;
    } else if (newTypePoint == TypePoint.PointB) {
      latLng = polyMethods!.currentDestination;
    }
    if (latLng != null) {
      await polyMethods!.moveWithOutAnimated(latLng);
    }
  }

  void toggleModEdit(TypePoint newTypePoint) async {
    if (typePoint == TypePoint.PointNull) {
      _startTimer();
    }
    if (newTypePoint != TypePoint.PointNull) {
      moveToCurrentPoint(newTypePoint);
      if (typePoint == newTypePoint) {
        typePoint = TypePoint.PointNull;
      } else {
        typePoint = newTypePoint;
      }
      update(['update_button']);
    }
  }

  void addPoint() {
    if (typePoint != TypePoint.PointNull) {
      LatLng newLatlng;
      if (typePoint == TypePoint.PointA) {
        newLatlng = polyMethods!.currentOrigin!;
      } else {
        newLatlng = polyMethods!.currentDestination!;
      }
      Polyline oldPoly =
          Polyline(polylineId: const PolylineId('value'), points: [newLatlng]);
      if (polyMethods!.polylines.isNotEmpty) {
        oldPoly = polyMethods!.polylines.first;
      } else {
        // si esta vacio
        polyMethods!.polylines.add(oldPoly);
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
      polyMethods!.routePoints =
          oldPoly.points; // se agrega los puntos internos
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
  }

  void removePoint() {
    if (typePoint != TypePoint.PointNull) {
      if (polyMethods!.polylines.isNotEmpty &&
          polyMethods!.polylines.first.points.isNotEmpty) {
        polyMethods!.polylines.first.points.removeLast();
        // isMovingMark = true; // se habilita el movimiento de la marka
        update(['update_map']);
      }
    }
  }

  void _startTimer() {
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

  bool _elementoSeRepite(List lista, int elemento) {
    int contador = 0;
    for (var i = 0; i < lista.length; i++) {
      if (lista[i] == elemento) {
        contador++;
      }
    }
    return contador > 1;
  }
}
