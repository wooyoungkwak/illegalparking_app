import '../states/whole_camera_state.dart';
import '../states/widgets/crop.dart';
import '../services/save_image_service.dart';
import '../services/such_loation_service.dart';
import '../states/declaration_state.dart';
import '../controllers/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';
import 'package:get/get.dart';

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
    determinePosition();
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
                suchAddress().then((value) => saveImageDirectory(res, true).then((value) => Future.delayed(
                  const Duration(minutes: 1), () {
                      Get.off(() => Declaration());
                    }))); // GPS, 주소 검색 후 저장
              }),
          CreateContainerByAlignment(0, -0.3, DefaultTextStyle(style: Theme.of(context).textTheme.headline1!, child: Text("번호판만 촬영해주세요", style: TextStyle(fontSize: 15, color: Colors.white)))),
          CreateContainerByAlignment(0, 0.9, SizedBox(height: 100, width: 200, child: Image.asset("assets/car_number.jpg")))
        ],
      )),
    );
  }
}

Container CreateContainerByAlignment(double X, double Y, Widget widget) {
  return Container(alignment: Alignment(X, Y), child: widget);
}

WillPopScope _createWillPopScope(Widget widget) {
  return WillPopScope(
      onWillPop: () {
        // Get.off(() => Wholecamera());
        return Future(() => false);
      },
      child: widget);
}
