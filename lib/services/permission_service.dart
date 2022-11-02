import 'dart:io';
import 'package:illegalparking_app/utils/log_util.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> callPermissions() async {
  if (await getState()) {
    return true;
  }

  // if (Platform.isAndroid) {
  //   AppSettings.openAppSettings();
  // }
  return false;
}

List<Permission> _getPermissions() {
  List<Permission> permissions = [Permission.location];
  permissions.add(Permission.camera);
  permissions.add(Permission.locationAlways);
  permissions.add(Permission.locationWhenInUse);

  return permissions;
}

Future<bool> getState() async {
  var locationPermssion = await checkDeviceLocationIsOn();
  if (!locationPermssion) {
    Geolocator.requestPermission();
    // AppSettings.openLocationSettings();
  }
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

  if (Platform.isIOS) {
    if (await Permission.location.serviceStatus.isEnabled) {
      Log.debug("isEnabled");
      var status = await Permission.location.status;
      if (status.isGranted) {
        Log.debug("is Granted");
      } else {
        Log.debug("is not Granted");
        return false;
      }
    } else {
      Log.debug("is not Enabled");
      return false;
    }
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
