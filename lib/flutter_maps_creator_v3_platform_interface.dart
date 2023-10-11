import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_maps_creator_v3_method_channel.dart';

abstract class FlutterMapsCreatorV3Platform extends PlatformInterface {
  /// Constructs a FlutterMapsCreatorV3Platform.
  FlutterMapsCreatorV3Platform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMapsCreatorV3Platform _instance = MethodChannelFlutterMapsCreatorV3();

  /// The default instance of [FlutterMapsCreatorV3Platform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMapsCreatorV3].
  static FlutterMapsCreatorV3Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMapsCreatorV3Platform] when
  /// they register themselves.
  static set instance(FlutterMapsCreatorV3Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
