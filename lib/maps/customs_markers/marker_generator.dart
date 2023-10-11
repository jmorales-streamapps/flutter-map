import 'dart:async';

import 'dart:ui' as UI;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarkerGenerator {
  MarkerGenerator._();

  static Future<BitmapDescriptor> createBitmapDescriptor(
      {required double sizeMarker,
      Size? sizeCustom2, //
      required Function(Canvas canvas, Size size) canvasFuntion}) async {
    /*
    
    
     */
    Size sizeCustom = sizeCustom2 ?? Size(sizeMarker, sizeMarker + 20);
    final pictureRecorder = UI.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    canvasFuntion(canvas, sizeCustom);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(
        sizeCustom.width.round(), sizeCustom.height.round());
    ByteData? bytes = await image.toByteData(format: UI.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /*
  Para cargar imagenes locales
   */
  static Future<UI.Image> getImageAsset(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<UI.Image> completer = Completer();
    UI.decodeImageFromList(Uint8List.view(data.buffer), (UI.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static Future<UI.Image> getSvgAsset(String svgAssetPath, String key,
      {Size size = const Size(25, 25), String color = '#0d0d0d'}) async {
    String svgString = await rootBundle.loadString(svgAssetPath);
    //String exa = '#${color.value.toRadixString(16)}';
    svgString = svgString.replaceAll('#0d0d0d', color);
    //Draws string representation of svg to DrawableRoot
    // DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, key);
    final ratio = UI.window.devicePixelRatio.ceil();
    final width = size.width.ceil() * ratio;
    final height = size.height.ceil() * ratio;
    final PictureInfo pictureInfo =
        await vg.loadPicture(SvgStringLoader(svgString), null);

    final picture = pictureInfo.picture.toImage(
      width,
      height,
    );
    return picture;
  }

  /*
  Para cargar imagenes de la red
   */
  static Future<UI.Image> getImageNetWork(String path) async {
    // log('Falla');
    Completer<ImageInfo> completer = Completer();
    var img = NetworkImage(path);
    await img.evict();
    img
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    //log('Aqui $path');
    ImageInfo imageInfo = await completer.future;
    UI.Image imagen = imageInfo.image;

    return imagen;
  }

//   888b     d888                                             888               8888888                          8888888b.           888
//   8888b   d8888                                             888                 888                            888  "Y88b          888
//   88888b.d88888                                             888                 888                            888    888          888
//   888Y88888P888  8888b.  888d888 .d8888b  8888b.        .d88888  .d88b.         888   .d8888b .d88b.  88888b.  888    888  8888b.  888888  8888b.
//   888 Y888P 888     "88b 888P"  d88P"        "88b      d88" 888 d8P  Y8b        888  d88P"   d88""88b 888 "88b 888    888     "88b 888        "88b
//   888  Y8P  888 .d888888 888    888      .d888888      888  888 88888888        888  888     888  888 888  888 888    888 .d888888 888    .d888888
//   888   "   888 888  888 888    Y88b.    888  888      Y88b 888 Y8b.            888  Y88b.   Y88..88P 888  888 888  .d88P 888  888 Y88b.  888  888
//   888       888 "Y888888 888     "Y8888P "Y888888       "Y88888  "Y8888       8888888 "Y8888P "Y88P"  888  888 8888888P"  "Y888888  "Y888 "Y888888

  static Future<BitmapDescriptor> createBitmapDescriptorFromIconDataMedium(
      IconData iconData, Color iconColor) async {
    final pictureRecorder = UI.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintIcon(canvas, iconColor, iconData);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(200.round(), 200.round());
    final bytes = await image.toByteData(format: UI.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Paints the icon
  static void _paintIcon(Canvas canvas, Color color, IconData iconData) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: 200,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0, 100));
  }

  static Future<BitmapDescriptor> createBitmapDescriptor2(
      {required double sizeMarker,
      required Function(Canvas canvas, Size size) canvasFuntion}) async {
    /*
    
    Sin Altura adicional
     */
    Size sizeCustom = Size(sizeMarker, sizeMarker);
    final pictureRecorder = UI.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    canvasFuntion(canvas, sizeCustom);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(
        sizeCustom.width.round(), sizeCustom.height.round());
    ByteData? bytes = await image.toByteData(format: UI.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> createBitmapDescriptorFromIconSvg(
      {required UI.Image image}) async {
    ByteData? bytes = await image.toByteData(format: UI.ImageByteFormat.png);
    if (bytes != null) {
      return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    }
    return BitmapDescriptor.defaultMarker;
  }

  static Future<BitmapDescriptor> createBitmapDescriptorFromIconData(
      IconData iconData, Color iconColor) async {
    final pictureRecorder = UI.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintIconData(canvas, iconColor, iconData);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(40, 40);
    final bytes = await image.toByteData(format: UI.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  static void _paintIconData(Canvas canvas, Color color, IconData iconData) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: 40,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0, 0));
  }
}
