import 'dart:convert';
import '../controllers/address_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/address_model.dart';
import '../models/kakao_model.dart';

final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
final ReactiveController c = Get.put(ReactiveController());

Future<void> suchAddress() async {
  // final position = await _geolocatorPlatform.getCurrentPosition();
  final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, timeLimit: Duration(minutes: 1));
  // GeoData data = await Geocoder2.getDataFromCoordinates(latitude: position.latitude, longitude: position.longitude, googleMapApiKey: "AIzaSyCPXBQbfyDDJq20h9V_ZJcCuwfItyPmru4", language: "ko");
  //카카오는 경도 위도 / 구글,네이버는 위도 경도
  //c.change(latitude: position.latitude, longitude: position.longitude, address: "테스트중!");

  regeocoder(position.longitude, position.latitude);
}

//위치권한 확인...
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

//카카오 경도 위도로 주소
Future<String> regeocoder(double longitude, double latitude) async {
  String REST_API_KEY = "429eb33ae5e0c87a6d5a400f262ef734";

  String kakaourl = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$longitude&y=$latitude&input_coord=WGS84";
  // , headers: {"Authorization: KakaoAK ${REST_API_KEY}"}

  final responseGps = await http.get(Uri.parse(kakaourl), headers: {"Authorization": "KakaoAK $REST_API_KEY"});
  print("###############");
  Kakao map;
  map = Kakao.fromJson(json.decode(responseGps.body));
  print("latitude:${latitude}");
  print("longitude:${longitude}");
  print(map.documents[0]['road_address']['address_name']);
  print("##############");
  c.change(latitude: latitude, longitude: longitude, address: map.documents[0]['road_address']['address_name']);

  return "";
}
