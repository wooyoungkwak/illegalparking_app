import 'package:get/get.dart';
import 'package:illegalparking_app/utils/log_util.dart';

class LoginController extends GetxController {
  // static LoginController get to => Get.find();
  bool _isGuestMode = false;
  bool get isGuestMode => _isGuestMode;

  void onGuesMode() {
    Log.debug("onGuesMode");
    _isGuestMode = true;
    update();
  }

  void offGuesMode() {
    Log.debug("offGuesMode");
    _isGuestMode = false;
    update();
  }
}
