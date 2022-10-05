import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/utils/log_util.dart';

import '../states/widgets/crop.dart';
import '../services/save_image_service.dart';
import '../services/such_loation_service.dart';
import '../states/declaration_state.dart';
import '../controllers/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:get/get.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Partcamera extends StatefulWidget {
  const Partcamera({Key? key}) : super(key: key);

  @override
  State<Partcamera> createState() => _PartcameraState();
}

class _PartcameraState extends State<Partcamera> {
  final ReactiveController c = Get.put(ReactiveController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReactiveController());
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
              onTake: (MaskForCameraViewResult res) async {
                pd.show(max: 100, msg: '데이터 생성 중');
                saveImageDirectory(res, true).then((value) => suchAddress().then((value) {
                      Get.off(() => const Declaration());
                      // 현재 사진저장 > 주소검색 > 화면이동
                      // 나중에 사진저장 > 서버에 보내서 값 받아오는 동안 주소 검색 > 2개 다 완료되면 화면이동
                      sendFile(Env.SERVER_AI_FILE_UPLOAD_URL, controller.partImage.value);
                }));
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
          if (c.partImageMemory.length > 1) {
            Get.back();
          }
          return Future(() => false);
        },
        child: widget);
  }
}
