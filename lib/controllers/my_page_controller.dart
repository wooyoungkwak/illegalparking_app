import 'package:get/get.dart';

class MyPageController extends GetxController {
  bool _certifiedVehicle = false;
  bool get certifiedVehicle => _certifiedVehicle;
  RxInt noticeIndex = 0.obs;

  void getCertifiedVehicle() {
    _certifiedVehicle = true;
    update();
  }

  void setIndex(int value) {
    noticeIndex(value);
  }
}
