import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/utils/log_util.dart';

Future<void> cameraSetting() async {
  try {
    await availableCameras().then((cameras) {
      Env.CAMERA_SETTING = cameras;
    });
  } catch (e) {
    throw Exception(e);
  }
}

void mediasizeSetting(BuildContext context) {
  Env.MEDIA_SIZE_HEIGHT = MediaQuery.of(context).size.height;
  Env.MEDIA_SIZE_WIDTH = MediaQuery.of(context).size.width;
  Env.MEDIA_SIZE_DEVICEPIXELRATIO = MediaQuery.of(context).devicePixelRatio;
  Env.MEDIA_SIZE_PADDINGTOP = MediaQuery.of(context).padding.top;
  Env.APP_BAR_HEIGHT = AppBar().preferredSize.height;
}

Future<void> getMobileInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};
  String machine;

  try {
    if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      machine = deviceData["utsname.machine"];
      Env.USER_PHONE_MODEL = _mapToDevice(machine);
      Log.debug(Env.USER_PHONE_MODEL);
    }
  } catch (e) {
    throw Exception("Failed to get device info");
  }
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname': data.utsname.sysname,
    'utsname.nodename': data.utsname.nodename,
    'utsname.release': data.utsname.release,
    'utsname.version': data.utsname.version,
    'utsname.machine': data.utsname.machine,
  };
}

String _mapToDevice(String machine) {
  switch (machine) {
    case "iPhone3,1":
    case "iPhone3,2":
    case "iPhone3,3":
      return "iPhone 4";
    case "iPhone4,1":
      return "iPhone 4s";
    case "iPhone5,1":
    case "iPhone5,2":
      return "iPhone 5";
    case "iPhone5,3":
    case "iPhone5,4":
      return "iPhone 5c";
    case "iPhone6,1":
    case "iPhone6,2":
      return "iPhone 5s";
    case "iPhone7,2":
      return "iPhone 6";
    case "iPhone7,1":
      return "iPhone 6 Plus";
    case "iPhone8,1":
      return "iPhone 6s";
    case "iPhone8,2":
      return "iPhone 6s Plus";
    case "iPhone9,1":
    case "iPhone9,3":
      return "iPhone 7";
    case "iPhone9,2":
    case "iPhone9,4":
      return "iPhone 7 Plus";
    case "iPhone10,1":
    case "iPhone10,4":
      return "iPhone 8";
    case "iPhone10,2":
    case "iPhone10,5":
      return "iPhone 8 Plus";
    case "iPhone10,3":
    case "iPhone10,6":
      return "iPhone X";
    case "iPhone11,2":
      return "iPhone XS";
    case "iPhone11,4":
    case "iPhone11,6":
      return "iPhone XS Max";
    case "iPhone11,8":
      return "iPhone XR";
    case "iPhone12,1":
      return "iPhone 11";
    case "iPhone12,3":
      return "iPhone 11 Pro";
    case "iPhone12,5":
      return "iPhone 11 Pro Max";
    case "iPhone13,1":
      return "iPhone 12 mini";
    case "iPhone13,2":
      return "iPhone 12";
    case "iPhone13,3":
      return "iPhone 12 Pro";
    case "iPhone13,4":
      return "iPhone 12 Pro Max";
    case "iPhone14,4":
      return "iPhone 13 mini";
    case "iPhone14,5":
      return "iPhone 13";
    case "iPhone14,2":
      return "iPhone 13 Pro";
    case "iPhone14,3":
      return "iPhone 13 Pro Max";
    case "iPhone14,7":
      return "iPhone 14";
    case "iPhone14,8":
      return "iPhone 14 Plus";
    case "iPhone15,2":
      return "iPhone 14 Pro";
    case "iPhone15,3":
      return "iPhone 14 Pro Max";
    case "iPhone8,4":
      return "iPhone SE";
    case "iPhone12,8":
      return "iPhone SE (2nd generation)";
    case "iPhone14,6":
      return "iPhone SE (3rd generation)";
    case "i386":
    case "x86_64":
    case "arm64":
      return "Simulator";
    default:
      return "";
  }
}
