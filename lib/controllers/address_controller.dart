import 'dart:typed_data';
import '../models/address_model.dart';
import 'package:get/get.dart';

class ReactiveController extends GetxController {
  var whole_Image = "".obs;
  var part_Image = "".obs;

  late Uint8List whole_Image_Memory;
  late Uint8List part_Image_Memory;

  var image_GPS = ImageGPS(latitude: 0, longitude: 0, address: "").obs;

  change({required double latitude, required double longitude, required String address}) {
    image_GPS.update((val) {
      val?.latitude = latitude;
      val?.longitude = longitude;
      val?.address = address;
    });
  }

  whole_Image_write(String path) {
    whole_Image = path.obs;
  }

  part_Image_write(String path) {
    part_Image = path.obs;
  }

  whole_Image_Memory_writ(Uint8List path) {
    whole_Image_Memory = path;
  }

  part_Image_Memory_writ(Uint8List path) {
    part_Image_Memory = path;
  }
}
