import 'package:get/get.dart';

class MyPageController extends GetxController {
  bool _certifiedVehicle = false;
  bool get certifiedVehicle => _certifiedVehicle;

  void getCertifiedVehicle() {
    _certifiedVehicle = true;
    update();
  }
}
