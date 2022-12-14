import 'dart:io';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/states/home.dart';

import 'package:illegalparking_app/states/widgets/crop.dart';
import 'package:illegalparking_app/states/declaration_state.dart';
import 'package:illegalparking_app/states/car_number_camera_state.dart';
import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/widgets/custom_text.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/utils/time_util.dart';
// import 'package:lottie/lottie.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:get/get.dart';

class Reportcamera extends StatefulWidget {
  const Reportcamera({Key? key}) : super(key: key);

  @override
  State<Reportcamera> createState() => _ReportcameraState();
}

class _ReportcameraState extends State<Reportcamera> {
  final ReportController c = Get.put(ReportController());
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((data) async {
      _fetchData(context);
    });
  }

  void _fetchData(BuildContext context) async {
    // show the loading dialog
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createCustomText(color: AppColors.white, text: "로딩중..."),
                  const CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                ],
              ));
        });
    await Future.delayed(const Duration(seconds: 1));
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark)); // IOS = Brightness.light의 경우 글자 검정, 배경 흰색
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: AppColors.white)); // android = Brightness.light 글자 흰색, 배경색은 컬러에 영향을 받음
    }
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: _createWillPopScope(
        Stack(
          alignment: Alignment.center,
          children: [
            MaskForCameraCustomView(
                type: false,
                boxWidth: Env.MEDIA_SIZE_WIDTH! - 50,
                boxHeight: c.carnumberImage.value.isNotEmpty ? Env.MEDIA_SIZE_HEIGHT! / 2.2 : Env.MEDIA_SIZE_HEIGHT! / 2,
                appBarColor: Colors.transparent,
                takeButtonActionColor: Colors.white,
                takeButtonColor: Colors.black,
                btomhighbtn: !c.carnumberImage.value.isNotEmpty ? Env.MEDIA_SIZE_HEIGHT! / 1.45 : Env.MEDIA_SIZE_HEIGHT! / 1.5, // 버튼위치 조정
                onTake: (MaskForCameraViewResult res) {
                  c.imageTimewrite(getDateToStringForAll(getNow()));
                  if (c.carnumberImage.value.isNotEmpty) {
                    if (controller != null) {
                      Get.offAll(() => const Declaration());
                    }
                  } else {
                    Get.offAll(const Numbercamera());
                  }
                }),
            initContainerByOutlineButton(0, 0.7, "주정차관련법규보기", context),
            c.carnumberImage.value.isNotEmpty ? createContainerByAlignment(-0.75, Platform.isIOS ? -0.9 : -0.925, createContainerByTopWidget(color: AppColors.white, function: backbtn)) : Container(),
            Positioned(top: c.carnumberImage.value.isNotEmpty ? Env.MEDIA_SIZE_PADDINGTOP! + 25 : Env.MEDIA_SIZE_PADDINGTOP! + 10, child: initColumnByText(11, AppFontWeight.regular, AppColors.white)),
          ],
        ),
      ),
    );
  }

  void backbtn() {
    alertDialogByGetxtobutton("신고를 취소하시겠습니까?", gotohome);
  }

  gotohome() {
    c.initialize();
    Get.offAll(const Home());
    loginController.changePage(1);
  }

  WillPopScope _createWillPopScope(Widget widget) {
    return WillPopScope(
        onWillPop: () {
          if (c.carnumberImage.value.isNotEmpty) {
            Get.back();
            Env.CAR_CAMERA_RESHOOT_CHECK = false;
          }
          return Future(() => false);
        },
        child: Platform.isIOS ? (c.carnumberImage.value.isNotEmpty ? _createDismissibleBySwipe(widget) : widget) : widget);
  }

  Container createContainerByAlignment(double X, double Y, Widget widget) {
    return Container(alignment: Alignment(X, Y), child: widget);
  }

//위쪽 설명 text
  Column initColumnByText(double size, FontWeight weight, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: Env.TEXT_REPORT_RULE_1, weight: weight, size: size, color: color),
        CustomText(text: Env.TEXT_REPORT_RULE_2, weight: weight, size: size, color: color),
        CustomText(text: Env.TEXT_REPORT_RULE_3, weight: weight, size: size, color: color),
        CustomText(text: Env.TEXT_REPORT_RULE_4, weight: weight, size: size, color: color),
        CustomText(text: Env.TEXT_REPORT_RULE_5, weight: weight, size: size, color: color),
        CustomText(text: Env.TEXT_REPORT_RULE_6, weight: weight, size: size, color: color),
      ],
    );
  }

//불법주정차 법규 text
  Container initContainerByOutlineButton(double X, double Y, String text, BuildContext context) {
    return createContainerByAlignment(
      X,
      Y,
      OutlinedButton(
        onPressed: () {
          widgetbottomsheet(context);
        },
        style: ButtonStyle(
          side: MaterialStateProperty.all(const BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
        ),
        child: CustomText(text: text, weight: FontWeight.w600, color: Colors.white, size: 13),
      ),
    );
  }

//바텀에 검은 선
// ignore: unused_element
  Padding _createPaddingBybottomline() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: const Alignment(0, 0),
        height: 3.0,
        width: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: const Color(0xff2D2D2D),
        ),
      ),
    );
  }

  Dismissible _createDismissibleBySwipe(Widget widget) {
    return Dismissible(
      key: const ValueKey<int>(1),
      resizeDuration: null,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (c.carnumberImage.value.isNotEmpty) {
          Get.back();
        }
      },
      child: widget,
    );
  }
}
