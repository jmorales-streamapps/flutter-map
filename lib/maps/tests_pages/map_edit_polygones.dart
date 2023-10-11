import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/controllers/controller_adit_polygone.dart';
import 'package:flutter_maps_creator_v3/maps/controllers/controller_search_route.dart';
import 'package:flutter_maps_creator_v3/maps/models/enums.dart';
import 'package:flutter_maps_creator_v3/maps/models/prediction.dart';
import 'package:flutter_maps_creator_v3/maps/widgets/search_route.dart';
import 'package:flutter_maps_creator_v3/maps/widgets/shape_s.dart';
import 'package:flutter_maps_creator_v3/maps/widgets/widget_hand_indicator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class MapEditPolygones extends StatelessWidget {
  final LatLng? target;
  final ControllerMapEditPolygone conp = Get.put(ControllerMapEditPolygone());
  final ControllerSearchRoute controllerSeach =
      Get.find<ControllerSearchRoute>();

  MapEditPolygones({super.key, this.target});

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
        GetBuilder<ControllerMapEditPolygone>(
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
                polygons: controller.polygones,
                circles: controller.circles,
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
                  child: GetBuilder<ControllerMapEditPolygone>(
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
        // AREA DE BUSQUEDA
        Positioned.fill(
            child: Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFieldSearch(
                            hintText: 'Buscar',
                            controller: controllerSeach.controllerOrigin,
                            focusNode: controllerSeach.focusNodeOrigin,
                            onTap: () {
                              Navigator.push<Prediction?>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PageSearchPlace(
                                    prediction: controllerSeach.originPlace,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              ).then((value) {
                                if (value != null) {
                                  controllerSeach.originPlace = value;
                                  controllerSeach.controllerOrigin.text =
                                      value.description;
                                }

                                controllerSeach.focusNodeOrigin.unfocus();
                              });
                            },
                          ),
                        ),
                      ),
                      GetBuilder<ControllerMapEditPolygone>(
                          id: 'buttons_type_geofence',
                          builder: (c) {
                            return Row(
                              children: [
                                Card(
                                  child: IconButton(
                                      onPressed: () {
                                        if (c.typeGeofence !=
                                            TypeGeofence.Circle) {
                                          c.startTimer();
                                        }
                                        c.typeGeofence = TypeGeofence.Circle;
                                        c.update(['buttons_type_geofence']);
                                      },
                                      color:
                                          c.typeGeofence == TypeGeofence.Circle
                                              ? Colors.blue
                                              : Colors.grey,
                                      icon: const Icon(Icons.gps_fixed)),
                                ),
                                Card(
                                  child: IconButton(
                                      onPressed: () {
                                        if (c.typeGeofence !=
                                            TypeGeofence.Polygon) {
                                          c.startTimer();
                                        }
                                        c.typeGeofence = TypeGeofence.Polygon;
                                        c.update(['buttons_type_geofence']);
                                      },
                                      color:
                                          c.typeGeofence == TypeGeofence.Polygon
                                              ? Colors.blue
                                              : Colors.grey,
                                      icon: const Icon(Icons.polymer)),
                                )
                              ],
                            );
                          })
                    ],
                  ),
                ))),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Obx(() => conp.secondsRemaining.value != 0
                  ? WidgetHandIndicator(
                      height: 150,
                      width: 150,
                      onTap: conp.handleTap,
                    )
                  : Container())),
        )
      ],
    );
  }
}
