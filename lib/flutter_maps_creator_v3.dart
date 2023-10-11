// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'flutter_maps_creator_v3_platform_interface.dart';

class FlutterMapsCreatorV3 {
  Future<String?> getPlatformVersion() {
    return FlutterMapsCreatorV3Platform.instance.getPlatformVersion();
  }
}
