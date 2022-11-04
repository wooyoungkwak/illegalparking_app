import 'package:get/get.dart';

class MapController extends GetxController {
  String _resivedDatatype = "Web View Test"; // 이 아이는 무조건 상태관리자로 관리해야된다.;;
  String get resivedDatatype => _resivedDatatype;
  double _latitude = 0.0;
  double get latitude => _latitude;
  double _longitude = 0.0;
  double get longitude => _longitude;

  bool _clickedMap = true;
  bool get clickedMap => _clickedMap;

  void setDataType(String? value) {
    _resivedDatatype = value ?? "";
    update();
  }

  void getClickedMap(bool value) {
    _clickedMap = value;
    update();
  }

  void setLatitude(double? value) {
    _latitude = value ?? 0.0;
    update();
  }

  void setLongitude(double? value) {
    _longitude = value ?? 0.0;
    update();
  }
}
