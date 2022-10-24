import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/services/setting_service.dart';
import 'package:illegalparking_app/services/permission_service.dart';
import 'package:illegalparking_app/states/home.dart';
import 'package:illegalparking_app/states/login.dart';
import 'package:illegalparking_app/states/my_page_car_infomation.dart';
import 'package:illegalparking_app/states/my_page_infomation.dart';
import 'package:illegalparking_app/states/my_page_point.dart';
import 'package:illegalparking_app/states/my_page_registration.dart';
import 'package:illegalparking_app/states/my_page_report.dart';
import 'package:illegalparking_app/states/sign_up.dart';
import 'package:illegalparking_app/states/first_use_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  callPermissions();
  cameraSetting();
  runApp(const MyApp());
  await SharedPreferences.getInstance().then((value) {
    Env.BOOL_FIRSTUSE = value.getBool(Env.KEY_FIRSTUSE);
    if (Env.BOOL_FIRSTUSE == null) {
      Env.BOOL_FIRSTUSE = false;
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Env.BOOL_FIRSTUSE == true ? "/login" : "/Firstuse",
      // initialRoute: "/login",
      routes: <String, WidgetBuilder>{
        "/Firstuse": (BuildContext context) => Firstuse(),
        "/login": (BuildContext context) => const Login(),
        "/sign_up": (BuildContext context) => const SignUp(),
        "/home": (BuildContext context) => const Home(),
        "/infomation": (BuildContext context) => const MyPageInfomation(),
        "/car_infomation": (BuildContext context) => const MyPageCarInfomatino(),
        "/registration": (BuildContext context) => const MyPageRegistration(),
        "/report": (BuildContext context) => const MyPageReport(),
        "/point": (BuildContext context) => const MyPagePoint(),
      },
    );
  }
}
