import 'package:flutter/material.dart';
import 'package:illegalparking_app/config/env.dart';

class Log {

  static void log(var message) {
    debugPrint(message);
  }

  static void debug(var message) {
    if(Env.isDebug) debugPrint(message);
  }

  static void error(var message) {
    debugPrint("error : $message");
  }

}