import 'dart:io';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/services/save_image_service.dart';
import 'package:illegalparking_app/states/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/states/widgets/custom_text.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({super.key});

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  final ReportController controller = Get.put(ReportController());
  final loginController = Get.put(LoginController());
  int testcount = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((data) async {
      // ignore: unnecessary_null_comparison
      if (Env.REPORT_RESPONSE_MSG! == "" || Env.REPORT_RESPONSE_MSG! == null) {
        alertDialogByGetxonebutton("신고알림", Env.MSG_REPORT_NOT_RESPONSE);
      } else {
        alertDialogByGetxonebutton("신고알림", Env.REPORT_RESPONSE_MSG!);
      }
      testcount++;
      Log.debug("state {$testcount}");
      // saveImageGallery();
      controller.initialize();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark)); // IOS = Brightness.light의 경우 글자 검정, 배경 흰색
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: AppColors.white)); // android = Brightness.light 글자 흰색, 배경색은 컬러에 영향을 받음
    }
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return _createWillPopScope(Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              createContainerByTopWidget(text: "신고하기", function: backbtn),
              Expanded(
                flex: 20,
                child: Container(
                  alignment: const Alignment(0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        child: _initColumnBy2Text(Env.TEXT_REPORT_SUCCESS_1, Env.TEXT_REPORT_SUCCESS_2),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _initInkWellByOnTap(_initContainer(Colors.black, "신고이력"), _reportlistbtn),
                      const SizedBox(height: 15),
                      _initInkWellByOnTap(_initContainer(const Color(0xffC9C9C9), "홈"), _homebtn),
                    ],
                  ),
                ),
              ),
              _createPaddingBybottomline()
            ],
          ),
        )));
  }

  Column _initColumnBy2Text(String text1, String text2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: text1,
          weight: FontWeight.w400,
          color: Colors.black,
          size: 14,
        ),
        const SizedBox(height: 10),
        CustomText(
          text: text2,
          weight: FontWeight.w600,
          color: Colors.black,
          size: 16,
        ),
      ],
    );
  }

  WillPopScope _createWillPopScope(Widget widget) {
    return WillPopScope(
        onWillPop: () {
          backbtn();
          return Future(() => false);
        },
        child: widget);
  }

  //신고이력, 홈 버튼
  SizedBox _initContainer(Color color, String text) {
    return SizedBox(
      width: 250,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 11),
          // child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 14))),
          child: Center(
              child: CustomText(
            text: text,
            weight: FontWeight.w500,
            color: Colors.white,
          )),
        ),
      ),
    );
  }

  // Container _createContainerByTopWidget() {
  //   // ignore: avoid_unnecessary_containers
  //   return Container(
  //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //       Padding(
  //         //좌우 대칭용
  //         padding: const EdgeInsets.all(8.0),
  //         child: IconButton(onPressed: () {}, icon: const Icon(Icons.close_outlined), color: Colors.white),
  //       ),
  //       const CustomText(text: "신고하기", weight: FontWeight.w500, color: Colors.black),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: IconButton(
  //             onPressed: () {
  // controller.carreportImagewrite("");
  // controller.carnumberImagewrite("");
  // Get.off(const Home(
  //   index: 1,
  // ));
  //             },
  //             icon: const Icon(Icons.close_outlined),
  //             color: const Color(0xff707070)),
  //       ),
  //     ]),
  //   );
  // }

  InkWell _initInkWellByOnTap(Widget widget, Function function) {
    return InkWell(
      onTap: () {
        function();
      },
      child: widget,
    );
  }

  Padding _createPaddingBybottomline() {
    double widthsize = (Env.MEDIA_SIZE_WIDTH! / 2) - (55);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthsize, vertical: 8),
      child: Container(
        alignment: const Alignment(0, 0),
        height: 5.0,
        width: Env.MEDIA_SIZE_WIDTH! / 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: const Color(0xff2D2D2D),
        ),
      ),
    );
  }

  void _reportlistbtn() {
    controller.initialize();
    Get.offAll(const Home());
    loginController.changePage(2);
    loginController.changeRealPage(6);
  }

  void _homebtn() {
    controller.initialize();
    // MaskForCameraCustomView.initialize().then((value) =>);
    Get.off(const Home());
    loginController.changePage(1);
  }

  // void _escbtn() {
  //   controller.initialize();
  //   Get.off(const Home(
  //     index: 1,
  //   ));
  // }

  void backbtn() {
    alertDialogByGetxtobutton("홈으로 이동하시겠습니까?", gotohome);
  }

  gotohome() {
    controller.initialize();
    Get.offAll(const Home());
    loginController.changePage(1);
  }
}
