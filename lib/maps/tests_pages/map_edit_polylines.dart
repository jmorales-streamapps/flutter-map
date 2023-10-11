import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/controllers/controller_adit_polyline.dart';
import 'package:flutter_maps_creator_v3/maps/controllers/controller_search_route.dart';
import 'package:flutter_maps_creator_v3/maps/models/enums.dart';
import 'package:flutter_maps_creator_v3/maps/widgets/clipper_infowindow.dart';
import 'package:flutter_maps_creator_v3/maps/widgets/search_route.dart';
import 'package:flutter_maps_creator_v3/maps/widgets/shape_s.dart';
import 'package:flutter_maps_creator_v3/maps/widgets/widget_hand_indicator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class MapEditPolylines extends StatelessWidget {
  final LatLng? target;
  final ControllerMapEditPolyline controller =
      Get.put(ControllerMapEditPolyline());

  MapEditPolylines({super.key, this.target});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double iconSize = size.width * .04;
    double splashRadius = math.max(
      Material.defaultSplashRadius,
      (iconSize + math.min(8, 8)) * 0.1,
    );

    return Stack(
      children: [
        GetBuilder<ControllerMapEditPolyline>(
            id: 'update_map',
            builder: (controller) {
              return GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: target ?? const LatLng(20.5215443, -99.8939799),
                    zoom: 12),
                onCameraMove: controller.onCameraMove,
                onMapCreated: (controllermap) {
                  controller.controllerL = controllermap;
                  controller.polyMethods?.controller = controllermap;
                },
                markers: controller.markers,
                circles: controller.circles,
                polylines: controller.polylines,
              );
            }),
        Positioned.fill(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //color: Colors.white,
                  width: size.width,
                  height: size.height * .1,
                  child: GetBuilder<ControllerMapEditPolyline>(
                      id: 'area_buttons',
                      builder: (controller) {
                        return Stack(
                          children: [
                            Card(
                              elevation: 2,
                              shape: const DurmaShape(
                                  borderRadius: Radius.circular(15),
                                  side: BorderSide.none),
                              child: Row(
                                children: [
                                  IconButton(
                                      iconSize: iconSize,
                                      splashRadius: splashRadius,
                                      onPressed: controller.buttonBackActivate
                                          ? () {
                                              controller.toBackAndToPoint(
                                                  TypeAction.Back);
                                            }
                                          : null,
                                      icon: const Icon(Icons.arrow_back_ios)),
                                  IconButton(
                                      iconSize: iconSize,
                                      splashRadius: splashRadius,
                                      onPressed: () {
                                        controller.removePoint();
                                      },
                                      icon: const Icon(Icons.remove)),
                                  IconButton(
                                      iconSize: iconSize,
                                      splashRadius: splashRadius,
                                      onPressed: () {
                                        controller.addPoint();
                                      },
                                      icon: const Icon(Icons.add)),
                                  IconButton(
                                      iconSize: iconSize,
                                      splashRadius: splashRadius,
                                      onPressed: controller.buttonNextActivate
                                          ? () {
                                              controller.toBackAndToPoint(
                                                  TypeAction.To);
                                            }
                                          : null,
                                      icon:
                                          const Icon(Icons.arrow_forward_ios)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                FloatingActionButton(
                                  onPressed: () {
                                    log('gola');
                                  },
                                  child: const Icon(Icons.save),
                                )
                              ],
                            ),
                          ],
                        );
                      }),
                ))),
        Positioned.fill(
            child: Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                    child: GetBuilder<ControllerMapEditPolyline>(
                        id: 'update_button',
                        builder: (context) {
                          return SearchRouteWidget(
                            miController: Get.find<ControllerSearchRoute>(),
                            typePoint: controller.typePoint,
                            onChange:
                                (origin, destiny, isValid, newTypePoint) async {
                              controller.polyMethods!.setPositions(
                                  origin: origin?.latLng,
                                  destination: destiny?.latLng);
                              //
                              if (isValid) {
                                controller.typePoint = TypePoint.PointNull;
                                controller.updatePointAB();
                                controller.traceRoute(origin!, destiny!);
                              } else {
                                log('controller.typePoint::  ${controller.typePoint} :: newTypePoint$newTypePoint');
                                controller.typePoint = newTypePoint;
                                controller.moveToCurrentPoint(newTypePoint);
                                if (newTypePoint == TypePoint.PointA) {
                                  controller.updatePointA();
                                } else if (newTypePoint == TypePoint.PointB) {
                                  controller.updatePointB();
                                }
                              }
                            },
                            onTapPointA: () {
                              controller.toggleModEdit(TypePoint.PointA);
                              controller.updatePointA();
                            },
                            onTapPointB: controller.typePoint ==
                                    TypePoint.PointNull
                                ? null
                                : () {
                                    controller.toggleModEdit(TypePoint.PointB);
                                    controller.updatePointB();
                                  },
                          );
                        })))),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Obx(() => controller.secondsRemaining.value != 0
                  ? WidgetHandIndicator(
                      height: 150,
                      width: 150,
                      onTap: controller.handleTap,
                    )
                  : Container())),
        ),
        GetBuilder<ControllerMapEditPolyline>(
            id: 'update_info_window',
            builder: (controller) {
              //log('controller.polyMethods!.currentDestination:: ${controller.polyMethods!.currentDestination}');
              // log('controller.polyMethods!.currentDestination != null:: ${controller.polyMethods!.currentDestination != null}');
              if (controller.polyMethods!.currentDestination != null) {
                return FutureBuilder(
                  future: controller.controllerL.getScreenCoordinate(
                      controller.polyMethods!.currentDestination!),
                  builder: (context, snapshot) {
                    //log('getScreenCoordinate 1');

                    if (snapshot.hasData) {
                      double infoWindowWidth = 120;
                      double markerOffset = 120;
                      double devicePixelRatio = Get.pixelRatio;
                      double left =
                          (snapshot.data!.x.toDouble() / devicePixelRatio) -
                              (infoWindowWidth / 2);
                      double top =
                          (snapshot.data!.y.toDouble() / devicePixelRatio) -
                              markerOffset;
                      log('getScreenCoordinate 2');
                      log('left $left');
                      log('top $top');

                      return Positioned(
                          top: top,
                          left: left,
                          child: TooltipWidget(
                            width: infoWindowWidth,
                            height: 80,
                            child: TextButton(
                                onPressed: () {
                                  controller.traceRouteLatLng(
                                      controller.polyMethods!.currentOrigin!,
                                      controller
                                          .polyMethods!.currentDestination!);
                                },
                                child: const Text('Trazar')),
                          ));
                    }
                    return const SizedBox();
                  },
                );
              }
              log('update_info_window');
              return const SizedBox();
            })
      ],
    );
  }
}
