import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../location/controller/location_controller.dart';

class HomeController extends GetxController {
  final LocationController locationController = Get.put(LocationController());
  var isBottomSheetOpen = false.obs;
  var markerPosition = LatLng(37.7749, -122.4194).obs;
  var customMarkerIcon = BitmapDescriptor.defaultMarker.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _loadCustomMarkerWithLabel("You");
  }

  // Update marker position
  void updateMarkerPosition(LatLng position) {
    markerPosition.value = position;
  }

  Future<void> _loadCustomMarkerWithLabel(String label) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final ByteData data = await rootBundle.load(
      'assets/images/my_location.png',
    );
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 250,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ui.Image image = fi.image;

    Paint paint = Paint();
    canvas.drawImage(image, Offset(0, 0), paint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: label,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        backgroundColor: Colors.yellow,
      ),
    );

    textPainter.layout();

    final double textX = (image.width - textPainter.width) / 2;
    final double textY = image.height.toDouble() + 4;

    textPainter.paint(canvas, Offset(textX, textY));

    final ui.Image finalImage = await pictureRecorder.endRecording().toImage(
      image.width,
      image.height + textPainter.height.toInt() + 8,
    );

    final ByteData? finalByteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List finalBytes = finalByteData!.buffer.asUint8List();

    customMarkerIcon.value = BitmapDescriptor.fromBytes(finalBytes);
  }
}
