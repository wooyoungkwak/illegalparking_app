import 'dart:typed_data';
import '../models/address_model.dart';
import 'package:get/get.dart';

class ReactiveController extends GetxController {
  var wholeImage = "".obs;
  var partImage = "".obs;

  late Uint8List wholeImageMemory;
  late Uint8List partImageMemory;

  var imageGPS = ImageGPS(latitude: 0, longitude: 0, address: "").obs;

  change({required double latitude, required double longitude, required String address}) {
    imageGPS.update((val) {
      val?.latitude = latitude;
      val?.longitude = longitude;
      val?.address = address;
    });
  }

  wholeImagewrite(String path) {
    wholeImage = path.obs;
  }

  partImagewrite(String path) {
    partImage = path.obs;
  }

  wholeImageMemorywrit(Uint8List path) {
    wholeImageMemory = path;
  }

  partImageMemorywrit(Uint8List path) {
    partImageMemory = path;
  }
}
