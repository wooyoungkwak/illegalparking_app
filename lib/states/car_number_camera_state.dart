import 'dart:io';

import 'package:flutter/scheduler.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/states/home.dart';
import 'package:illegalparking_app/states/widgets/crop.dart';
import 'package:illegalparking_app/states/declaration_state.dart';
import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/widgets/custom_text.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:lottie/lottie.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:get/get.dart';

class Numbercamera extends StatefulWidget {
  const Numbercamera({Key? key}) : super(key: key);

  @override
  State<Numbercamera> createState() => _NumbercameraState();
}

class _NumbercameraState extends State<Numbercamera> {
  final ReportController controller = Get.put(ReportController());
  final loginController = Get.put(LoginController());
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((data) async {
      // 테스트용으로 막아둠
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
              )
              // child: Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 20),

              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const [
              //         CircularProgressIndicator(
              //           color: AppColors.black,
              //         ),
              //         SizedBox(width: 15),
              //         CustomText(
              //           weight: AppFontWeight.bold,
              //           text: "로딩중",
              //           color: Colors.black,
              //           size: 20,
              //         ),
              //         // SizedBox(width: 50, height: 100, child: Lottie.asset('assets/loading_black.json', fit: BoxFit.fill)),
              //       ],
              //     ),
              //     ),
              );
        });
    await Future.delayed(const Duration(seconds: 1));
    Get.back();
  }

  @override
  void dispose() {
    super.dispose();
    cameradispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createWillPopScope(Stack(
        children: [
          MaskForCameraCustomView(
              boxWidth: Env.MEDIA_SIZE_WIDTH! - 50,
              boxHeight: Env.MEDIA_SIZE_HEIGHT! / 6,
              appBarColor: const Color.fromARGB(0, 22, 15, 15),
              takeButtonActionColor: Colors.white,
              takeButtonColor: Colors.black,
              boxBorderColor: Colors.white,
              boxBorderWidth: 1,
              btomhighbtn: Env.MEDIA_SIZE_HEIGHT! / 1.65,
              backColor: Colors.black,
              onTake: (MaskForCameraViewResult res) {
                controller.carNumberwrite("");
                Get.offAll(() => const Declaration());
              }),
          CreateContainerByAlignment(-0.8, -0.9, createContainerByTopWidget(color: AppColors.white, function: backbtn)),
          CreateContainerByAlignment(0, -0.3,
              DefaultTextStyle(style: Theme.of(context).textTheme.headline1!, child: const CustomText(text: "번호판을 네모영역 안에서 촬영해주세요", weight: AppFontWeight.regular, size: 14, color: AppColors.white))),
          CreateContainerByAlignment(
              0,
              0.6,
              DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline1!,
                  child: const Card(
                      shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 1)),
                      color: Colors.transparent,
                      child:
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8), child: CustomText(text: "촬영 예시", weight: AppFontWeight.semiBold, size: 14, color: AppColors.white))))),
          // CreateContainerByAlignment(0, 0.9, SizedBox(height: 100, width: 200, child: Image.asset("assets/car_number.jpg")))
          CreateContainerByAlignment(0, 0.9, SizedBox(width: Env.MEDIA_SIZE_HEIGHT! / 4, child: Image.asset("assets/car_number.jpg")))
        ],
      )),
    );
  }

  // ignore: non_constant_identifier_names
  Container CreateContainerByAlignment(double X, double Y, Widget widget) {
    return Container(alignment: Alignment(X, Y), child: widget);
  }

  WillPopScope _createWillPopScope(Widget widget) {
    return WillPopScope(
        onWillPop: () {
          if (controller.carnumberImageMemory.length > 1) {
            Get.back();
            Env.CARNUMBER_CAMERA_RESHOOT_CHECK = false;
          }
          return Future(() => false);
        },
        child: Platform.isIOS ? _createDismissibleBySwipe(widget) : widget);
  }

  // ignore: unused_element
  Container _initContainer(Color color, String text, double radius, double width) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: width,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Center(
              child: CustomText(text: text, weight: FontWeight.w200, size: 14, color: Colors.white),
            )),
      ),
    );
  }

  void backbtn() {
    alertDialogByGetxtobutton("신고를 취소하시겠습니까?", gotohome);
  }

  gotohome() {
    controller.initialize();
    Get.offAll(const Home());
    loginController.changePage(0);
  }

  Dismissible _createDismissibleBySwipe(Widget widget) {
    return Dismissible(
      key: ValueKey<int>(1),
      resizeDuration: null,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (controller.carNumber.isNotEmpty) {
          Get.back();
        } else {
          Get.to(Home());
          loginController.changePage(1);
        }
      },
      child: widget,
    );
  }
}
