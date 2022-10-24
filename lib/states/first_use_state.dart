import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/services/setting_service.dart';
import 'package:illegalparking_app/states/login.dart';
import 'package:illegalparking_app/states/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Firstuse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    mediasizeSetting(context);
    double devicHeight = Env.MEDIA_SIZE_HEIGHT!;
    double devicWidth = Env.MEDIA_SIZE_WIDTH!;
    double devicePaddingtop = Env.MEDIA_SIZE_PADDINGTOP!;

    return MaterialApp(
        home: Scaffold(
      body: Column(
        children: [
          SizedBox(
              height: devicHeight / 1.6,
              width: devicWidth,
              child: Image.asset(
                "assets/Firstuse_img.png",
                fit: BoxFit.fill,
              )),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xff1A1C1E), Colors.black], begin: Alignment.topCenter, end: Alignment.bottomCenter), border: Border.all(color: Color(0xff1A1C1E))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [initContainerBytitle(), _initInkWellByOnTap(_initContainer(Color(0xffFFFFFF), "시작하기", 30.0, devicWidth - 30, Colors.black), startbtn), _createPaddingBybottomline()],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Container initContainerBytitle() {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "주차의정석,",
            weight: FontWeight.w700,
            size: 25,
          ),
          Row(
            children: [
              CustomText(
                text: "SOP",
                weight: FontWeight.w900,
                size: 46,
              ),
              CustomText(
                text: "(Standard of parking)",
                weight: FontWeight.w500,
                size: 17,
                color: Color(0xff848484),
              )
            ],
          ),
          SizedBox(height: 10),
          CustomText(
            text: "SOP는 새로운 이동 기준을 제시하는 모빌리티 앱 입니다.\n우리의 이동은 도로 위 스트레스 없는 세상을 만들어 갑니다.",
            weight: FontWeight.w500,
            size: 12,
            color: Color(0xff848484),
          )
        ],
      ),
    );
  }

  //탭기능
  InkWell _initInkWellByOnTap(Widget widget, Function function) {
    return InkWell(
      onTap: () {
        function();
      },
      child: widget,
    );
  }

  //버튼디자인
  Container _initContainer(Color color, String text, double radius, double width, Color textcolor) {
    return Container(
        width: width,
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Center(
                child: CustomText(
              text: text,
              weight: FontWeight.w700,
              size: 14,
              color: textcolor,
            )),
          ),
        ));
  }

  Padding _createPaddingBybottomline() {
    double widthsize = (Env.MEDIA_SIZE_WIDTH! / 2) - (55);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthsize, vertical: 8),
      child: Container(
        alignment: const Alignment(0, 0),
        height: 5.0,
        width: 110.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Color(0xff2D2D2D),
        ),
      ),
    );
  }

  startbtn() {
    firstusecheck();
    Get.off(Login());
  }

  firstusecheck() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Env.KEY_FIRSTUSE, true);
    Env.BOOL_FIRSTUSE = true;
  }
}
