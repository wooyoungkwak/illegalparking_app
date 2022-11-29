import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/services/setting_service.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';

class Home extends StatefulWidget {
  final int? index;
  const Home({Key? key, this.index}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final loginController = Get.put(LoginController());

  double _initBottomHeight() {
    if (Env.USER_PHONE_MODEL == "iPhone XR") {
      return 94.0;
    } else {
      return 105.0;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // home에서 나가면 게스트 모드 해제(무조건)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginController.offGuesMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.light)); // IOS = Brightness.light의 경우 글자 검정, 배경 흰색
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: AppColors.white)); // android = Brightness.light 글자 흰색, 배경색은 컬러에 영향을 받음
    }
    mediasizeSetting(context);
    return Obx(
      () => WillPopScope(
        onWillPop: () {
          if (loginController.isBottomOpen.value) {
            loginController.offBottomNav();
            Get.back();
          }

          if (loginController.currentPageIdex > 3) {
            loginController.changeRealPage(loginController.currentIndex.value);
          } else {
            alertDialogByGetxtobutton("앱을 종료하시겠습니까?", appExit);
          }

          return Future(() => false);
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: loginController.isGuestMode ? AppColors.white : AppColors.appBackground,
          body: loginController.currentPages,
          bottomNavigationBar: Container(
            // height: _initBottomHeight(),
            height: 105.0,
            decoration: BoxDecoration(
                color: Colors.grey,
                border: loginController.isBottomOpen.value ? null : Border.all(color: Colors.grey, width: 1),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(29),
                  topLeft: Radius.circular(29),
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(loginController.isBottomOpen.value ? 0 : 29),
                topLeft: Radius.circular(loginController.isBottomOpen.value ? 0 : 29),
              ),
              child: BottomNavigationBar(
                backgroundColor: AppColors.appBackground,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map_outlined),
                    label: "지도",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.camera_alt_outlined),
                    label: "신고",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: "내정보",
                  ),
                ],
                currentIndex: loginController.currentIndex.value,
                selectedItemColor: AppColors.bottomNavSelected,
                unselectedItemColor: Colors.white,
                iconSize: 27,
                onTap: loginController.changePage,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void appExit() {
    SystemNavigator.pop();
  }

  // onWillPop() {
  //   DateTime? currentBackPressTime;
  //   DateTime now = DateTime.now();
  //   if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
  //     currentBackPressTime = now;
  //     showToast(text: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.");
  //     // Fluttertoast.showToast(msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.", gravity: ToastGravity.BOTTOM, backgroundColor: const Color(0xff6E6E6E), fontSize: 20, toastLength: Toast.LENGTH_SHORT);
  //     return false;
  //   }
  //   return true;
  // }
}
