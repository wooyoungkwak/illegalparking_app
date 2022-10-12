import 'package:get/get.dart';

class MapController extends GetxController {
  String _testText = "Web View Test"; // 이 아이는 무조건 상태관리자로 관리해야된다.;;
  String get testText => _testText;

  bool _clickedMap = true;
  bool get clickedMap => _clickedMap;

  void getTestText(String? value) {
    _testText = value ?? "";
    update();
  }

  void getClickedMap(bool value) {
    _clickedMap = value;
    update();
  }
}
