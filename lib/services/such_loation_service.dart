import 'dart:convert';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:illegalparking_app/models/kakao_model.dart';

// final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
final ReportController c = Get.put(ReportController());

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

//카카오 경도 위도로 주소
Future<void> regeocoder() async {
  Position position = await searchAddress();
  double longitude;
  double latitude;

  if (position.longitude > 1 || position.latitude > 1) {
    longitude = position.longitude;
    latitude = position.latitude;
  } else {
    longitude = 0.0;
    latitude = 0.0;
  }

  // ignore: non_constant_identifier_names
  String RESTAPIKEY = "429eb33ae5e0c87a6d5a400f262ef734"; //나중에 env에 따로 옮길것
  Kakao map;

  // c.addresswrite(latitude: latitude, longitude: longitude, address: "실패[데이터 및 WIFI를 확인해주세요]");
  String kakaourl = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$longitude&y=$latitude&input_coord=WGS84";

  final responseGps = await http.get(Uri.parse(kakaourl), headers: {"Authorization": "KakaoAK $RESTAPIKEY"});

  if (responseGps.statusCode == 200) {
    map = Kakao.fromJson(json.decode(responseGps.body));
    c.addresswrite(latitude: latitude, longitude: longitude, address: map.documents[0]['address']['address_name']);
  } else {
    throw Exception(responseGps.body);
  }
}
