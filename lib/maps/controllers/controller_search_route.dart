import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/models/prediction.dart';
import 'package:get/get.dart';

class ControllerSearchRoute extends GetxController {
  Prediction? originPlace;
  Prediction? destinyPlace;
  final FocusNode focusNodeOrigin = FocusNode();
  final FocusNode focusNodeDestiny = FocusNode();
  final TextEditingController controllerOrigin = TextEditingController();
  final TextEditingController controllerDestiny = TextEditingController();
}
