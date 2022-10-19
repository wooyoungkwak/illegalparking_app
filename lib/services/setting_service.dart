import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_camera_description.dart';

Future<void> cameraSetting() async {
  CameraController cameraController;
  bool onecheck = true;

  try {
    if (onecheck) {
      await availableCameras().then((cameras) {
        Env.CAMERA_SETTING = cameras;
        cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
      });
      onecheck = false;
    }
  } catch (e) {
    throw Exception(e);
  }
}

void mediasizeSetting(BuildContext context) {
  Env.MEDIA_SIZE_HEIGHT = MediaQuery.of(context).size.height;
  Env.MEDIA_SIZE_WIDTH = MediaQuery.of(context).size.width;
  Env.MEDIA_SIZE_DEVICEPIXELRATIO = MediaQuery.of(context).devicePixelRatio;
  Env.MEDIA_SIZE_PADDINGTOP = MediaQuery.of(context).padding.top;
}
