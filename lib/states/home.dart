import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/services/setting_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

class Home extends StatefulWidget {
  final int? index;
  const Home({Key? key, this.index}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          appBar: loginController.currentIndex.value == 2 && !loginController.isGuestMode && loginController.currentPageIdex.value == 2
              ? AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      createCustomText(padding: 0.0, text: "안녕하세요"),
                      Row(
                        children: [
                          createCustomText(padding: 0.0, color: Colors.blue, text: Env.USER_NAME),
                          createCustomText(padding: 0.0, text: "님"),
                        ],
                      ),
                    ],
                  ),
                  // centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          loginController.changeRealPage(3);
                        },
                        color: Colors.black,
                        icon: const Icon(Icons.settings))
                  ],
                )
              : null,
          body: loginController.currentPages,
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: "지도",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_outlined),
                label: "카메라",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: "내정보",
              ),
            ],
            currentIndex: loginController.currentIndex.value,
            selectedItemColor: Colors.amber,
            onTap: loginController.changePage,
          ),
        ),
      ),
    );
  }
}
