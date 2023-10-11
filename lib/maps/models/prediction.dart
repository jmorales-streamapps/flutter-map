import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Predictions extends ModelPre {
  List<Prediction> predictions = [];
  late String searchText; // texto con el que se obtuvieron las predicciones
  late String status;

  @override
  toModel(data) {
    data['predictions'].forEach((element) {
      predictions.add(Prediction()
        ..toModel(element)
        ..predictionsAntesor = this);
    });

    log('predictions.length:: ${predictions.length}');
    // log(data.toString());
  }
}

class Prediction extends ModelPre {
  late String description;
  late LatLng latLng;
  late String placeId;
  late Predictions predictionsAntesor;
  @override
  toModel(data) {
    description = data['description'] ?? '';
    placeId = data['place_id'] ?? '';
  }

  setLatLg(double latitude, double longitude) {
    latLng = LatLng(
      latitude,
      longitude,
    );
  }
}

abstract class ModelPre {
  toModel(dynamic data);
}
