import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/controllers/controller_adit.dart';
import 'package:flutter_maps_creator_v3/maps/controllers/controller_search_route.dart';
import 'package:flutter_maps_creator_v3/maps/models/prediction.dart';
import 'package:flutter_maps_creator_v3/maps/widgets/search_route.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapEditPOIS extends StatelessWidget {
  final LatLng? target;

  const MapEditPOIS({super.key, this.target});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final ControllerSearchRoute controllerSeach =
        Get.find<ControllerSearchRoute>();
    final ControllerMapEdit cG = Get.find<ControllerMapEdit>();

    return Stack(
      children: [
        GetBuilder<ControllerMapEdit>(
            id: 'map_section',
            builder: (controller) {
              return GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: target ?? const LatLng(20.5215443, -99.8939799),
                    zoom: 12),
                onCameraMove: controller.onCameraMove,
                onMapCreated: (controllermap) {
                  controller.controllerL = controllermap;
                  cG.poiMethods?.controller = controllermap;
                },
                markers: controller.markers,
                circles: controller.circles,
              );
            }),
        Positioned.fill(
            child: Align(
                alignment: Alignment.centerRight,
                child: Card(
                  elevation: 2,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    // color: Colors.red,
                    width: size.width * .07,
                    height: size.height * .5,
                    child: GetBuilder<ControllerMapEdit>(
                        id: 'slider_section',
                        builder: (c) {
                          return Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: RotatedBox(
                                  quarterTurns:
                                      -1, // Rotamos el RangeSlider verticalmente(
                                  child: Slider(
                                    // label: c.poiMethods!.radiusPoi.toString(),
                                    divisions: 25,
                                    value: c.poiMethods!.radiusPoi,
                                    min: 50,
                                    max: 100,
                                    onChanged: (double value) {
                                      c.poiMethods!.radiusPoi =
                                          value.round().toDouble();
                                      c.poiMethods!.radiusPoi = value;
                                      c.poiMethods!.changeRadius(
                                        fun: () {
                                          c.update(['map_section']);
                                        },
                                      );
                                      c.update(['slider_section']);
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                c.poiMethods!.radiusPoi.round().toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          );
                        }),
                  ),
                ))),
        Positioned.fill(
            child: Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                    child: Card(
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
                            //
                            cG.poiMethods!.currentPosition = value.latLng;
                            cG.poiMethods!.controller
                                .moveCamera(CameraUpdate.newLatLngZoom(
                                    value.latLng, 17))
                                .then((value) {
                              cG.poiMethods!.createUniquePOI(fun: () {
                                cG.update(['map_section']);
                              });
                            });
                          }

                          controllerSeach.focusNodeOrigin.unfocus();
                        });
                      },
                    ),
                  ),
                )))),
        /*
        Positioned.fill(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                  onPressed: () {
                    log('gola');
                  },
                  child: const Icon(Icons.save),
                )
              ],
            ),
          ),
        ))
         */
      ],
    );
  }
}
