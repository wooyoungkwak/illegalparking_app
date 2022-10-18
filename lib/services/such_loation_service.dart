import 'dart:convert';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:illegalparking_app/models/kakao_model.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';

// final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
final ReportController controller = Get.put(ReportController());

Future<Position> searchAddress() async {
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}

// Future<void> suchAddress() async {
//   // final position = await _geolocatorPlatform.getCurrentPosition();
//   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((position) {
//     if (position.longitude > 1 || position.latitude > 1) {
//       regeocoder(position.longitude, position.latitude);
//     }
//   });
//   // GeoData data = await Geocoder2.getDataFromCoordinates(latitude: position.latitude, longitude: position.longitude, googleMapApiKey: "AIzaSyCPXBQbfyDDJq20h9V_ZJcCuwfItyPmru4", language: "ko");
//   //카카오는 경도 위도 / 구글,네이버는 위도 경도
//   //c.change(latitude: position.latitude, longitude: position.longitude, address: "테스트중!");
// }

Future<void> getGPS() async {
  Position position = await searchAddress();
  double longitude; //테스트 값
  double latitude;
  if (position.longitude > 1 || position.latitude > 1) {
    longitude = position.longitude;
    latitude = position.latitude;
    // longitude = 126.793539;
    // latitude = 35.0202257;
    controller.addresswrite(latitude: latitude, longitude: longitude, address: "TEST");
    regeocoder(longitude, latitude).then((value) => controller.addresswrite(latitude: latitude, longitude: longitude, address: value));
    //주소 받아오기
  } else {
    alertDialogByonebutton("알림", "GPS 위도경도 실패!");
    longitude = 0.0;
    latitude = 0.0;
  }
}

//카카오 경도 위도로 주소
Future<String> regeocoder(double longitude, double latitude) async {
  // ignore: non_constant_identifier_names
  String RESTAPIKEY = "429eb33ae5e0c87a6d5a400f262ef734"; //나중에 env에 따로 옮길것
  Kakao map;
//35.0202257 126.793539
  // c.addresswrite(latitude: latitude, longitude: longitude, address: "실패[데이터 및 WIFI를 확인해주세요]");
  String kakaourl = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$longitude&y=$latitude&input_coord=WGS84";

  try {
    final responseGps = await http.get(Uri.parse(kakaourl), headers: {"Authorization": "KakaoAK $RESTAPIKEY"});

    if (responseGps.statusCode == 200) {
      map = Kakao.fromJson(json.decode(responseGps.body));
      // String loadAddr = map.documents[0]['road_address']['address_name'];
      String lnmAddr = map.documents[0]['address']['address_name'];
      // List<String> temp1 = loadAddr.split(" ");
      List<String> temp2 = lnmAddr.split(" ");

      String changeAddr = temp2.first;
      String address = lnmAddr.replaceAll(changeAddr, _getSiName(changeAddr));
      Log.debug(" ************** address = $address");

      // c.addresswrite(latitude: latitude, longitude: longitude, address: address);
      return address;
    } else {
      throw Exception("주소검색 실패!");
    }
  } catch (e) {
    alertDialogByonebutton("알림", "카카오맵 실패!");
    Log.debug(e.toString());
    // return "";
    throw Exception("주소검색 실패!");
  }
}

String _getSiName(String si) {
  String result = "";

  switch (si) {
    case "전남":
      result = "전라남도";
      break;
    case "전북":
      result = "전라북도";
      break;
    case "충남":
      result = "충정남도";
      break;
    case "충북":
      result = "충정북도";
      break;
    case "경남":
      result = "경상남도";
      break;
    case "경북":
      result = "경상북도";
      break;
  }

  return result;
}
