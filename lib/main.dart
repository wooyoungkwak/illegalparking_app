import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/states/home.dart';
import 'package:illegalparking_app/states/login.dart';
import 'package:illegalparking_app/states/my_page_infomation.dart';
import 'package:illegalparking_app/states/my_page_point.dart';
import 'package:illegalparking_app/states/my_page_registration.dart';
import 'package:illegalparking_app/states/my_page_report.dart';
import 'package:illegalparking_app/states/sign_up.dart';
import 'package:illegalparking_app/states/widgets/crop.dart';
import 'package:mask_for_camera_view/mask_for_camera_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MaskForCameraView.initialize();
  await MaskForCameraCustomView.initialize();

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
        "/registration": (BuildContext context) => const MyPageRegistration(),
        "/infomation": (BuildContext context) => const MyPageInfomation(),
        "/report": (BuildContext context) => const MyPageReport(),
        "/point": (BuildContext context) => const MyPagePoint(),
      },
    );
  }
}
