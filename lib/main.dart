import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/services/permission_service.dart';
import 'package:illegalparking_app/states/home.dart';
import 'package:illegalparking_app/states/login.dart';
import 'package:illegalparking_app/states/my_page_car_infomation.dart';
import 'package:illegalparking_app/states/my_page_infomation.dart';
import 'package:illegalparking_app/states/my_page_point.dart';
import 'package:illegalparking_app/states/my_page_registration.dart';
import 'package:illegalparking_app/states/my_page_report.dart';
import 'package:illegalparking_app/states/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  callPermissions();
  runApp(const MyApp());
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
      initialRoute: "/login",
      routes: <String, WidgetBuilder>{
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
