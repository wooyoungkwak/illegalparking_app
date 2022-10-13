import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/main.dart';
import 'package:illegalparking_app/states/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/states/widgets/crop.dart';
import 'my_page_report.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({super.key});

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
    final ReportController controller = Get.put(ReportController());
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return _createWillPopScope(Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Scaffold(
          body: Column(
            children: [
              Container(
                alignment: const Alignment(1, 1),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      onPressed: () {
                        controller.carreportImagewrite("");
                        controller.carnumberImagewrite("");
                        Get.off(const Home(
                          index: 1,
                        ));
                      },
                      icon: const Icon(Icons.close_outlined),
                      color: Colors.black),
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
                          controller.initialize();
                          Get.offAll(const Home(index: 2));
                          Get.toNamed("/report");
                        },
                        child: const Text('신고이력'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.initialize();
                          // MaskForCameraCustomView.initialize().then((value) =>);
                          Get.off(const Home(index: 1));
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
