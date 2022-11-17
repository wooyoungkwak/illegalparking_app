import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/models/storage_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
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
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: AppColors.black, statusBarBrightness: Brightness.light));
  callPermissions();
  cameraSetting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.light)); // IOS = Brightness.light의 경우 글자 검정, 배경 흰색
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: AppColors.white)); // android = Brightness.light 글자 흰색, 배경색은 컬러에 영향을 받음
    }
    final theme = ThemeData(
      fontFamily: "NotoSansKR",
      // appBarTheme: const AppBarTheme(
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarColor: Colors.black,
      //     statusBarIconBrightness: Brightness.dark,
      //     statusBarBrightness: Brightness.dark,
      //   ),
      // ),
    );

    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        routes: <String, WidgetBuilder>{
          "/Firstuse": (BuildContext context) => const Firstuse(),
          "/login": (BuildContext context) => const Login(),
          "/sign_up": (BuildContext context) => const SignUp(),
          "/home": (BuildContext context) => const Home(),
          "/infomation": (BuildContext context) => const MyPageInfomation(),
          "/car_infomation": (BuildContext context) => const MyPageCarInfomatino(),
          "/registration": (BuildContext context) => const MyPageRegistration(),
          "/report": (BuildContext context) => const MyPageReport(),
          "/point": (BuildContext context) => const MyPagePoint(),
        },
        home: const MyHomePage());
  }
}

// deprecated
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final loginController = Get.put(LoginController());
  late SecureStorage secureStorage;
  String result = "";
  @override
  void initState() {
    super.initState();
    // 아이폰 모델명 확인
    getMobileInfo();
    secureStorage = SecureStorage();
    _checkInstall().then((value) {
      if (Env.BOOL_FIRSTUSE == true) {
        _checkAutoLogin().then((loginState) {
          if (loginState != null && loginState == "true") {
            login(Env.USER_ID!, Env.USER_PASSWORD!).then((loginInfo) {
              if (loginInfo.success) {
                Env.USER_NAME = loginInfo.getKrName();
                Env.USER_SEQ = loginInfo.getUserSeq();
                Env.USER_PHOTO_NAME = loginInfo.getPhotoName();
                Env.USER_PHONE_NUMBER = loginInfo.getPhoneNumber();
                loginController.offGuesMode();
                loginController.currentIndex(0);
                loginController.currentPageIdex(0);
                Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
              } else {
                showErrorToast(text: "아이디 또는 비밀번호를 확인해 주세요.");
                Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
              }
            });
          } else {
            Get.off(const Login());
          }
        });
      } else {
        Get.off(const Firstuse());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
      ),
      body: null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<bool?> _checkInstall() async {
    await SharedPreferences.getInstance().then((value) {
      Env.BOOL_FIRSTUSE = value.getBool(Env.KEY_FIRSTUSE);
      Env.BOOL_FIRSTUSE ??= false;
    });
    return Env.BOOL_FIRSTUSE;
  }

  Future<String?> _checkAutoLogin() async {
    Env.USER_ID = await secureStorage.read(Env.LOGIN_ID);
    Env.USER_PASSWORD = await secureStorage.read(Env.LOGIN_PW);
    return await secureStorage.read(Env.KEY_AUTO_LOGIN);
  }
}
