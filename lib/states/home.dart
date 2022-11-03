import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/services/setting_service.dart';

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
      return 70.0;
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
    mediasizeSetting(context);
    return Obx(
      () => WillPopScope(
        onWillPop: () {
          if (loginController.isBottomOpen) {
            loginController.offBottomNav();
            Get.back();
          }
          loginController.changeRealPage(loginController.currentIndex.value);
          return Future(() => false);
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: loginController.isGuestMode ? AppColors.white : AppColors.appBackground,
          body: loginController.currentPages,
          bottomNavigationBar: Container(
            height: _initBottomHeight(),
            decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(29),
                  topLeft: Radius.circular(29),
                )),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(29),
                topLeft: Radius.circular(29),
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
}
