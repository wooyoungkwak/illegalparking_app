import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/services/save_image_service.dart';
import 'package:illegalparking_app/states/widgets/crop.dart';
import 'package:illegalparking_app/states/declaration_state.dart';
import 'package:illegalparking_app/states/car_number_camera_state.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MaskForCameraCustomView(
              type: false,
              boxWidth: 300,
              boxHeight: 300,
              appBarColor: Colors.transparent,
              takeButtonActionColor: Colors.white,
              takeButtonColor: Colors.black,
              boxBorderColor: Colors.blue,
              boxBorderWidth: 1.0,
              onTake: (MaskForCameraViewResult res) {
                c.imageTimewrite(getDateToStringForYYMMDDHHMM(getNow()));
                Log.debug(getDateToStringForYYMMDDHHMM(getNow()));

                if (c.carnumberImage.value.isNotEmpty) {
                  Get.off(const Declaration());
                } else {
                  Get.to(const Numbercamera());
                }
              }),
          initContainerByOutlineButton(0, 0.95, "불법주정차 법규", context),
          Positioned(top: statusBarHeight + 20, child: initColumnByText(10))
        ],
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Container CreateContainerByAlignment(double X, double Y, Widget widget) {
  return Container(alignment: Alignment(X, Y), child: widget);
}

//위쪽 설명 text
Column initColumnByText(double size) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "·사진만 찍으면 자동 정보 분석 후 신고가 진행됩니다.",
        style: TextStyle(
          fontSize: size,
          color: Colors.white,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        "·불법주정차 단속구역 분석",
        style: TextStyle(
          fontSize: size,
          color: Colors.white,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        "·불법주정차 단속시간 분석",
        style: TextStyle(
          fontSize: size,
          color: Colors.white,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        "·차량번호판 활영은 필수입니다.",
        style: TextStyle(
          fontSize: size,
          color: Colors.white,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        "·노란색 실선 지역은 1분 이상 간격으로 신고가\n 한번 더 작성되어야 합니다.",
        style: TextStyle(
          fontSize: size,
          color: Colors.white,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        "·노란색 점선 지역은 5분 이상 간격으로 신고가\n 한번 더 작성되어야 합니다.",
        style: TextStyle(
          fontSize: size,
          color: Colors.white,
        ),
      ),
    ],
  );
}

//불법주정차 법규 text
Container initContainerByOutlineButton(double X, double Y, String text, BuildContext context) {
  return CreateContainerByAlignment(
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
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        )),
  );
}

//바텀sheet 불법 주정차 기준 창
void widgetbottomsheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: Column(
            children: [
              const SizedBox(width: 50, child: Divider(color: Colors.blueGrey, thickness: 4.0)),
              const SizedBox(height: 15),
              const Expanded(
                flex: 1,
                child: Text(
                  '불법주정차 법규',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(flex: 8, child: Image.asset("assets/parking _rule.png")), //불법주정차에 대한 법규 이미지 넣을 부분
              const SizedBox(height: 10),
              Expanded(
                  flex: 1,
                  child: Center(
                      child: ElevatedButton(
                          child: const Text('확 인'),
                          onPressed: () {
                            Get.back();
                          }))),
              const SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );
}
