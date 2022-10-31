import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
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
  callPermissions();
  cameraSetting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
  late SecureStorage secureStorage;
  final loginController = Get.put(LoginController());

  String result = "";

  @override
  void initState() {
    super.initState();
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
                showErrorToast(text: "자동로그인에 실패하였습니다.");
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
    return const Scaffold(
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
