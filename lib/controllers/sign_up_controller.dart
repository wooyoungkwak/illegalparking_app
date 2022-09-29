import 'package:get/get.dart';

class SignUpController extends GetxController {
  bool _checkedAutoLogin = false; // 이 아이는 무조건 상태관리자로 관리해야된다.;;
  bool get checkedAutoLogin => _checkedAutoLogin;

  void getAutoLogin(bool value) {
    _checkedAutoLogin = value;
    update();
  }
}
