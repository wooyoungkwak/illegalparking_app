import 'package:get/get.dart';
import 'package:illegalparking_app/models/address_model.dart';
import 'dart:typed_data';

class SettingController extends GetxController {
  var hidepasswordLogin = true.obs;
  var hidepasswordSign = true.obs;
  var hidepasswordSign2 = true.obs;
  var hidepasswordMypage = true.obs;
  var hidepasswordMypage2 = true.obs;
  var hidepasswordMypage3 = true.obs;

  hidepasswordLoginwrite(bool value) {
    hidepasswordLogin = value.obs;
    update();
  }

  hidepasswordSignwrite(bool value) {
    hidepasswordSign = value.obs;
    update();
  }

  hidepasswordSign2write(bool value) {
    hidepasswordSign2 = value.obs;
    update();
  }

  hidepasswordMypagewrite(bool value) {
    hidepasswordMypage = value.obs;
    update();
  }

  hidepasswordMypage2write(bool value) {
    hidepasswordMypage2 = value.obs;
    update();
  }

  hidepasswordMypage3write(bool value) {
    hidepasswordMypage3 = value.obs;
    update();
  }
}
