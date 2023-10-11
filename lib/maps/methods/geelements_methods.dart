import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/customs_markers/marker_generator.dart';
import 'package:flutter_maps_creator_v3/maps/customs_markers/marker_img.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as UI;

class GeoelementsMethods {
  late GoogleMapController controller;

  BitmapDescriptor iconMark = BitmapDescriptor.defaultMarker;
  bool modEdition = false;

  Future<void> setIcon(String urlImg, Color color, double size) async {
    UI.Image img = await MarkerGenerator.getImageNetWork(urlImg);
    iconMark = await MarkerGenerator.createBitmapDescriptor(
        sizeMarker: size,
        canvasFuntion: (canvas, size) {
          MarkerWithImage(color: color, image: img).paint(canvas, size);
        });
  }

  Future<void> moveAnimated(LatLng latLng) async {
    await controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  Future<void> moveWithOutAnimated(LatLng latLng) async {
    await controller.moveCamera(CameraUpdate.newLatLng(latLng));
  }
}

enum Operation { add, suscratract }
