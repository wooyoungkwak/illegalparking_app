import '../main.dart';
import '../controllers/address_controller.dart';
import '../states/whole_camera_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Confirmation extends StatefulWidget {
  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return _createWillPopScope(Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Scaffold(
          body: Column(
            children: [
              Container(
                alignment: Alignment(1, 1),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      onPressed: () {
                        // Get.offAll(main());
                      },
                      icon: const Icon(Icons.close_outlined),
                      color: Colors.white),
                ]),
              ),
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 20,
                child: Container(
                  alignment: const Alignment(0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("신고가 기록되어 데이터 분석이 진행됩니다.\n\n감사합니다"),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //Get.off(?????)홈 이동 넣어주세요
                        },
                        child: const Text('신고이력'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final ReactiveController c = Get.put(ReactiveController());
                          c.whole_Image_write("");
                          c.part_Image_write("");
                          // Get.offAll(main());
                          //임시로 카메라 다시 시작
                          //Get.offAll(?????)홈 이동 넣어주세요
                        },
                        child: const Text('홈'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  WillPopScope _createWillPopScope(Widget widget) {
    return WillPopScope(
        onWillPop: () {
          Get.offAll(() => main());
          return Future(() => false);
        },
        child: widget);
  }
}
