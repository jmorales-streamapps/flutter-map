import 'package:flutter/material.dart';
import 'package:flutter_maps_creator_v3/maps/controllers/controller_search_route.dart';
import 'package:flutter_maps_creator_v3/maps/tests_pages/map_edit_pois.dart';
import 'package:flutter_maps_creator_v3/maps/tests_pages/map_edit_polygones.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Get Route Managment',
      initialRoute: '/home',
      getPages: appRoutes(),
    );
  }
}

appRoutes() => [
      GetPage(
          name: '/home',
          page: () => const GEOLEMENTS(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(milliseconds: 500),
          binding: HomeBinding()),
    ];

class GEOLEMENTS extends StatelessWidget {
  const GEOLEMENTS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapEditPOIS(),
    );
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerSearchRoute());
    // Get.put(ControllerMapEditPolyline());
  }
}
