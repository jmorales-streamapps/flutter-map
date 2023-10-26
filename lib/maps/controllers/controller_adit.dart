import 'dart:developer';

import 'package:flutter_maps_creator_v3/maps/methods/pois_methods.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ControllerMapEdit extends GetxController {
  late GoogleMapController controllerL;
  RxBool holl = false.obs;

  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;
  POIMethods? poiMethods;

  @override
  void onInit() async {
    poiMethods =
        POIMethods(markers, circles, 50, const LatLng(20.5215443, -99.8939799));
    super.onInit();
    poiMethods?.createUniquePOI(
      fun: () => holl.refresh(),
    );
  }

  void onCameraMove(CameraPosition cameraPosition) {
    log("onCameraMove");

    poiMethods?.createUniquePOI(
      position: cameraPosition.target,
      fun: () {
        update(['map_section']);
      },
    );
  }
}
