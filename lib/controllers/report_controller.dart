import 'package:get/get.dart';
import 'package:illegalparking_app/models/address_model.dart';
import 'dart:typed_data';

class ReportController extends GetxController {
  var imageGPS = ImageGPS(latitude: 0, longitude: 0, address: "").obs;
  var carNumber = "".obs;
  var reportImage = "".obs;
  var carnumberImage = "".obs;
  var reportfileName = "".obs;
  var carnumfileName = "".obs;
  var imageTime = "".obs;

  late Uint8List reportImageMemory;
  late Uint8List carnumberImageMemory;

  carNumberwrite(String number) {
    carNumber = number.obs;
    update();
  }

  reportfileNamewrite(String name) {
    reportfileName = name.obs;
    update();
  }

  carnumfileNamewrite(String name) {
    carnumfileName = name.obs;
    update();
  }

  imageTimewrite(String time) {
    imageTime = time.obs;
    update();
  }

  addresswrite({required double latitude, required double longitude, required String address}) {
    imageGPS.update((val) {
      val?.latitude = latitude;
      val?.longitude = longitude;
      val?.address = address;
      update();
    });
  }

  carreportImagewrite(String path) {
    reportImage = path.obs;
    update();
  }

  carnumberImagewrite(String path) {
    carnumberImage = path.obs;
    update();
  }

  reportImageMemorywrit(Uint8List path) {
    reportImageMemory = path;
    update();
  }

  carnumberImageMemorywrit(Uint8List path) {
    carnumberImageMemory = path;
    update();
  }

  initialize() {
    imageGPS = ImageGPS(latitude: 0, longitude: 0, address: "").obs;
    carNumber = "".obs;
    reportImage = "".obs;
    carnumberImage = "".obs;
    reportfileName = "".obs;
    carnumfileName = "".obs;
    imageTime = "".obs;
  }
}
