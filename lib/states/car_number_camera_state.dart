import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/states/widgets/crop.dart';
import 'package:illegalparking_app/states/declaration_state.dart';
import 'package:flutter/material.dart';
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
    // MaskForCameraCustomView.initialize();
    super.initState();
  }

  @override
  void dispose() {
    // cameradipose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> filelist = [controller.reportImage.value, controller.carnumberImage.value];
    ProgressDialog pd = ProgressDialog(context: context);
    return Scaffold(
      body: _createWillPopScope(Stack(
        children: [
          MaskForCameraCustomView(
              // boxWidth: 300,
              // boxHeight: 120,
              boxWidth: Env.MEDIA_SIZE_WIDTH! - 50,
              boxHeight: Env.MEDIA_SIZE_HEIGHT! / 6,
              appBarColor: const Color.fromARGB(0, 22, 15, 15),
              takeButtonActionColor: Colors.white,
              takeButtonColor: Colors.black,
              boxBorderColor: Colors.white,
              boxBorderWidth: 1,
              // btomhighbtn: 210,
              btomhighbtn: Env.MEDIA_SIZE_HEIGHT! / 1.65,
              backColor: Colors.black,
              onTake: (MaskForCameraViewResult res) {
                // pd.show(max: 100, msg: '데이터를 생성중입니다');
                // pd.close();

                // function(res, context, controller, filelist);

                // saveImageDirectory(res, true).then((value) {});
                // showSnackBar(context, controller.carNumber.toString());
                // controller.carNumberwrite("tset중 문제네;;;");
                // pd.close();

                Get.offAll(() => const Declaration());
                // Get.to(() => const Declaration());

                // sendFile(Env.SERVER_AI_FILE_UPLOAD_URL, filelist).then((value) {
                // try {
                //   sendFile(Env.SERVER_AI_FILE_UPLOAD_URL, controller.carnumberImage.value).then((value) {
                //     pd.close();
                //     Get.off(() => const Declaration());
                //   });
                // } catch (e) {
                //   Log.debug(e);
                // }
              }),
          CreateContainerByAlignment(
              0, -0.3, DefaultTextStyle(style: Theme.of(context).textTheme.headline1!, child: const Text("번호판을 네모영역 안에서 촬영해주세요", style: TextStyle(fontSize: 15, color: Colors.white)))),
          CreateContainerByAlignment(
              0,
              0.6,
              DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline1!,
                  child: Card(
                      shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 1)),
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: const Text("촬영 예시", style: TextStyle(fontSize: 15, color: Colors.white)),
                      )))),
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

  Container _initContainer(Color color, String text, double radius, double width) {
    return Container(
      width: width,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 11),
          child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 14))),
        ),
      ),
    );
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

// void function(MaskForCameraViewResult res, BuildContext context, ReportController controller, List<String> filelist) {
//   try {
//     saveImageDirectory(res, true).then((value) => suchAddress().then((value) {
//           showSnackBar(context, controller.carnumberImage.toString());

//           Get.off(() => const Declaration());
//           //파일전송 현재 서버쪽 문제라 막아둠...
//           sendFile(Env.SERVER_AI_FILE_UPLOAD_URL, filelist).then((value) {
//             Get.off(() => const Declaration());
//           });
//         }));
//   } catch (e) {
//     Log.debug("신고하기 화면 이동 실패");
//   }
// }
