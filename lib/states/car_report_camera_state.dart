import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/states/widgets/crop.dart';
import 'package:illegalparking_app/states/declaration_state.dart';
import 'package:illegalparking_app/states/car_number_camera_state.dart';
import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/widgets/custom_text.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/utils/time_util.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:get/get.dart';

class Reportcamera extends StatefulWidget {
  const Reportcamera({Key? key}) : super(key: key);

  @override
  State<Reportcamera> createState() => _ReportcameraState();
}

class _ReportcameraState extends State<Reportcamera> {
  final ReportController c = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          MaskForCameraCustomView(
              type: false,
              // boxWidth: Env.MEDIA_SIZE_WIDTH! / 1.5,
              boxWidth: Env.MEDIA_SIZE_WIDTH! - 50,
              boxHeight: c.carnumberImage.value.isNotEmpty ? Env.MEDIA_SIZE_HEIGHT! / 2.2 : Env.MEDIA_SIZE_HEIGHT! / 2,
              appBarColor: Colors.transparent,
              takeButtonActionColor: Colors.white,
              takeButtonColor: Colors.black,
              // btomhighbtn: 630,
              // btomhighbtn: 140, // 버튼위치 조정
              btomhighbtn: !c.carnumberImage.value.isNotEmpty ? Env.MEDIA_SIZE_HEIGHT! / 1.45 : Env.MEDIA_SIZE_HEIGHT! / 1.5, // 버튼위치 조정
              onTake: (MaskForCameraViewResult res) {
                c.imageTimewrite(getDateToStringForYYMMDDHHMM(getNow()));
                Log.debug(getDateToStringForYYMMDDHHMM(getNow()));
                if (c.carnumberImage.value.isNotEmpty) {
                  Get.offAll(const Declaration());
                } else {
                  Get.off(const Numbercamera());
                }
              }),
          initContainerByOutlineButton(0, 0.7, "주정차관련법규보기", context),
          Positioned(top: Env.MEDIA_SIZE_PADDINGTOP! + 10, child: initColumnByText(11, AppFontWeight.regular, AppColors.white))
        ],
      ),
    );
  }
}

Container createContainerByAlignment(double X, double Y, Widget widget) {
  return Container(alignment: Alignment(X, Y), child: widget);
}

//위쪽 설명 text
Column initColumnByText(double size, FontWeight weight, Color color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomText(text: "·사진만 찍으면 자동 정보 분석 후 신고가 진행됩니다.", weight: weight, size: size, color: color),
      CustomText(text: "·불법주정차 단속구역 분석", weight: weight, size: size, color: color),
      CustomText(text: "·불법주정차 단속시간 분석", weight: weight, size: size, color: color),
      CustomText(text: "·차량번호판 활영은 필수입니다.", weight: weight, size: size, color: color),
      CustomText(text: "·노란색 실선 지역은 1분 이상 간격으로 신고가\n  한번 더 작성되어야 합니다.", weight: weight, size: size, color: color),
      CustomText(text: "·노란색 점선 지역은 5분 이상 간격으로 신고가\n  한번 더 작성되어야 합니다.", weight: weight, size: size, color: color),
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
