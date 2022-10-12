import 'dart:io';
import 'package:app_settings/app_settings.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> callPermissions() async {
  if (await getState()) {
    return true;
  }

  if (Platform.isAndroid) {
    AppSettings.openAppSettings();
  }
  return false;
}

List<Permission> _getPermissions() {
  List<Permission> permissions = [Permission.location];
  permissions.add(Permission.camera);
  permissions.add(Permission.locationWhenInUse);

  return permissions;
}

Future<bool> getState() async {
  List<Permission> permissions = _getPermissions();
  Map<Permission, PermissionStatus> statuses = await permissions.request();
  if (statuses.values.every((element) => element.isGranted)) {
    return true;
  }

  return false;
}

Future<bool> checkDeviceLocationIsOn() async {
  if (Platform.isAndroid) {
    return await Permission.location.serviceStatus.isDisabled;
  }
  return false;
}

// //위치권한 확인용!
// Future<Position> determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return Future.error('Location services are disabled.');
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return Future.error('Location permissions are denied');
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     return Future.error('Location permissions are permanently denied, we cannot request permissions.');
//   }
//   return await Geolocator.getCurrentPosition();
// }
