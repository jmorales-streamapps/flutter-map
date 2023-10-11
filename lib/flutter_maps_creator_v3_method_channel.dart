import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_maps_creator_v3_platform_interface.dart';

/// An implementation of [FlutterMapsCreatorV3Platform] that uses method channels.
class MethodChannelFlutterMapsCreatorV3 extends FlutterMapsCreatorV3Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_maps_creator_v3');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
