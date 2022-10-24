import 'package:get/get.dart';

class MyPageController extends GetxController {
  static MyPageController get to => Get.find();
  // bool _validCarNum = false;
  // bool get validCarNum => _validCarNum;

  RxBool validCarNum = false.obs;

  String _carLevel = "소형";
  String get carLevel => _carLevel;

  bool _certifiedVehicle = false;
  bool get certifiedVehicle => _certifiedVehicle;

  RxInt currentPoint = 0.obs;
  RxInt noticeIndex = 0.obs;

  // void setValidCarNum(bool value) {
  //   _validCarNum = value;
  //   update();
  // }

  void setsetValidCarNum(bool value) {
    validCarNum(value);
  }

  void getCertifiedVehicle() {
    _certifiedVehicle = true;
    update();
  }

  void setCarLevel(String value) {
    _carLevel = value;
    update();
  }

  void setIndex(int value) {
    noticeIndex(value);
  }

  void setCurrentPotin(int point) {
    currentPoint.value = point;
  }
}
