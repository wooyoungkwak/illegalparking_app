import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:illegalparking_app/config/env.dart';

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
