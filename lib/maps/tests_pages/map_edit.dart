import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/controllers/controller_adit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class MapEditP extends StatelessWidget {
  final void Function()? addPoint;
  final void Function()? delPoint;
  final LatLng? target;
  final ControllerMapEdit controller = Get.put(ControllerMapEdit());

  MapEditP({super.key, this.addPoint, this.delPoint, this.target});

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
        Obx(() {
          controller.holl.value;
          return GoogleMap(
            initialCameraPosition: CameraPosition(
                target: target ?? const LatLng(20.5215443, -99.8939799),
                zoom: 12),
            onCameraMove: (position) {},
            onMapCreated: (controllermap) {
              controller.controllerL = controllermap;
            },
            markers: controller.markers,
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
                  child: Card(
                    child: Row(
                      children: [
                        IconButton(
                            iconSize: iconSize,
                            splashRadius: splashRadius,
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back_ios)),
                        IconButton(
                            iconSize: iconSize,
                            splashRadius: splashRadius,
                            onPressed: () {},
                            icon: Icon(Icons.add)),
                        IconButton(
                            iconSize: iconSize,
                            splashRadius: splashRadius,
                            onPressed: () {},
                            icon: Icon(Icons.remove)),
                        IconButton(
                            iconSize: iconSize,
                            splashRadius: splashRadius,
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                  ),
                ))),
        Positioned.fill(
            child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  color: Colors.red,
                  width: 30,
                  height: 30,
                )))
      ],
    );
  }
}
