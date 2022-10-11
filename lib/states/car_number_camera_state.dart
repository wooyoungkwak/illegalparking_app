import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/crop.dart';
import 'package:illegalparking_app/services/save_image_service.dart';
import 'package:illegalparking_app/services/such_loation_service.dart';
import 'package:illegalparking_app/states/declaration_state.dart';
import 'package:flutter/material.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:get/get.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Numbercamera extends StatefulWidget {
  const Numbercamera({Key? key}) : super(key: key);

  @override
  State<Numbercamera> createState() => _NumbercameraState();
}

class _NumbercameraState extends State<Numbercamera> {
  final ReportController controller = Get.put(ReportController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    return Scaffold(
      body: _createWillPopScope(Stack(
        children: [
          MaskForCameraCustomView(
              boxWidth: 300,
              boxHeight: 150,
              appBarColor: const Color.fromARGB(0, 22, 15, 15),
              takeButtonActionColor: Colors.white,
              takeButtonColor: Colors.black,
              boxBorderColor: Colors.blue,
              boxBorderWidth: 2.8,
              backColor: Colors.black,
              onTake: (MaskForCameraViewResult res) {
                //saveImageDirectory(res, true).then((value) => addressfunction());
                pd.show(max: 100, msg: '데이터를 생성중입니다');

                try {
                  saveImageDirectory(res, true).then((value) => suchAddress().then((value) {
                        pd.close();
                        Get.off(() => const Declaration());
                        //파일전송 현재 서버쪽 문제라 막아둠...
                        // sendFile(Env.SERVER_AI_FILE_UPLOAD_URL, controller.carnumberImage.value).then((value) {
                        //   pd.close();
                        //   Get.off(() => const Declaration());
                        // });
                      }));
                } catch (e) {
                  Log.debug("신고하기 화면 이동 실패");
                }
              }),
          CreateContainerByAlignment(0, -0.3, DefaultTextStyle(style: Theme.of(context).textTheme.headline1!, child: const Text("번호판만 촬영해주세요", style: TextStyle(fontSize: 15, color: Colors.white)))),
          CreateContainerByAlignment(0, 0.9, SizedBox(height: 100, width: 200, child: Image.asset("assets/car_number.jpg")))
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
          }
          return Future(() => false);
        },
        child: widget);
  }

  // void sendfilefunction() {
  //   sendFile(Env.SERVER_AI_FILE_UPLOAD_URL, controller.carnumberImage.value).then((value) {
  //     if (value) {
  //       Log.debug("파일전송 후");
  //       Log.debug(addresscontroller.imageGPS.value.address);
  //       Get.off(() => const Declaration());
  //     } else {
  //       showAlertDialog(context, text: "파일업로드에 실패했습니다. 인터넷상태를 확인해주세요 \n 확인을 누르면 다시 시도합니다.", action: sendfilefunction);
  //     }

  //     //현재 사진저장 > 서버에 보내서 값 받아오기> 주소 검색 >  화면이동
  //   });
  // }

  // void addressfunction() {
  //   suchAddress().then((value) {
  //     if (value) {
  //       Log.debug("파일전송 전");
  //       Log.debug(addresscontroller.imageGPS.value.address);
  //       // sendfilefunction();
  //       Get.off(() => const Declaration());
  //     } else {
  //       showAlertDialog(context, text: "위치확인에 실패했습니다. GPS를 확인해주세요 \n 확인을 누르면 다시 시도합니다.", action: suchAddress);
  //     }
  //   });
  // }
}
