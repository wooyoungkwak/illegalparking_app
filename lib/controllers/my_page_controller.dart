import 'package:get/get.dart';

class MyPageController extends GetxController {
  static MyPageController get to => Get.find();

  bool _certifiedVehicle = false;
  bool get certifiedVehicle => _certifiedVehicle;

  RxInt currentPoint = 0.obs;

  RxInt noticeIndex = 0.obs;

  void getCertifiedVehicle() {
    _certifiedVehicle = true;
    update();
  }

  void setIndex(int value) {
    noticeIndex(value);
  }

  void setCurrentPotin(int point) {
    currentPoint.value = point;
  }
}
