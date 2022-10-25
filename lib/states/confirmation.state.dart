import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/main.dart';
import 'package:illegalparking_app/states/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/states/widgets/custom_text.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({super.key});

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  final ReportController controller = Get.put(ReportController());
  final loginController = Get.put(LoginController());

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
              _createContainerByTopWidget(),
              Expanded(
                flex: 20,
                child: Container(
                  alignment: const Alignment(0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(text: "신고가 기록되어 데이터 분석이 진행됩니다.", weight: FontWeight.w200),
                      const CustomText(text: "감사합니다.", weight: FontWeight.w400),
                      const SizedBox(
                        height: 50,
                      ),
                      _initInkWellByOnTap(_initContainer(Colors.black, "신고이력"), _reportlistbtn),
                      const SizedBox(height: 15),
                      _initInkWellByOnTap(_initContainer(const Color(0xffC9C9C9), "홈"), _homebtn),
                    ],
                  ),
                ),
              ),
              _createPaddingBybottomline()
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

  //신고이력, 홈 버튼
  Container _initContainer(Color color, String text) {
    return Container(
      width: 250,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 11),
          // child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 14))),
          child: Center(
              child: CustomText(
            text: text,
            weight: FontWeight.w400,
            color: Colors.white,
          )),
        ),
      ),
    );
  }

  Container _createContainerByTopWidget() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          //좌우 대칭용
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.close_outlined), color: Colors.white),
        ),
        const CustomText(text: "신고하기", weight: FontWeight.w200),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () {
                controller.carreportImagewrite("");
                controller.carnumberImagewrite("");
                Get.off(const Home(
                  index: 1,
                ));
              },
              icon: const Icon(Icons.close_outlined),
              color: const Color(0xff707070)),
        ),
      ]),
    );
  }

  InkWell _initInkWellByOnTap(Widget widget, Function function) {
    return InkWell(
      onTap: () {
        function();
      },
      child: widget,
    );
  }

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

  void _reportlistbtn() {
    controller.initialize();
    Get.offAll(const Home());
    loginController.changePage(2);
    loginController.changeRealPage(6);
  }

  void _homebtn() {
    controller.initialize();
    // MaskForCameraCustomView.initialize().then((value) =>);
    Get.off(const Home());
    loginController.changePage(1);
  }
}
