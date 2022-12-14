import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

class GuestCamera extends StatefulWidget {
  const GuestCamera({super.key});

  @override
  State<GuestCamera> createState() => _GuestCameraState();
}

class _GuestCameraState extends State<GuestCamera> {
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.light)); // IOS = Brightness.light의 경우 글자 검정, 배경 흰색
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: AppColors.white)); // android = Brightness.light 글자 흰색, 배경색은 컬러에 영향을 받음
    }
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
          elevation: 0,
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          leading: Material(
            color: AppColors.white,
            child: InkWell(
              onTap: () {
                loginController.offGuesMode();
                loginController.changePage(0);
                loginController.changeRealPage(0);
                Get.delete<LoginController>();
                Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
              },
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.black,
                size: 40,
              ),
            ),
          ),
          title: createCustomText(
            weight: AppFontWeight.bold,
            color: AppColors.black,
            size: 16.0,
            text: "돌아가기",
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createCustomText(
                        padding: 0.0,
                        weight: AppFontWeight.bold,
                        size: 20.0,
                        text: " 불법주정차 신고",
                      ),
                      createCustomText(
                        padding: 0.0,
                        weight: AppFontWeight.medium,
                        size: 20.0,
                        text: "를 위해서",
                      ),
                    ],
                  ),
                  createCustomText(
                    padding: 0.0,
                    weight: AppFontWeight.medium,
                    size: 20.0,
                    text: "로그인이 필요합니다.",
                  ),
                  createElevatedButton(
                    color: AppColors.black,
                    textColors: AppColors.white,
                    text: "바로가기",
                    function: () {
                      loginController.changePage(2);
                    },
                  ),
                  // 불법주정차 신고 프로세스
                  createCustomText(
                    color: AppColors.textGrey,
                    weight: AppFontWeight.bold,
                    size: 18.0,
                    text: "불법주정차 신고 프로세스",
                  ),
                  _createProcessItem(text: "사진만 찍으면 자동 정보 분석후 신고가 진행됩니다."),
                  _createProcessItem(text: "불법주정차 단속구역 분석"),
                  _createProcessItem(text: "불법주정차 단속시간 분석"),
                  _createProcessItem(text: "차량번호판 촬영은 필수 입니다."),
                  _createProcessItem(text: "노란색 실선 지역은 1분 이산 간격으로 신고가 한번 더 작성되어야 합니다."),
                  _createProcessItem(text: "노란색 점선 지역은 5분 이상 간격으로 신고가 한번 더 작성되어야 합니다."),

                  createElevatedButton(
                      padding: 16,
                      color: AppColors.white,
                      textColors: AppColors.black,
                      width: 170,
                      text: "주정차관련법규보기",
                      function: () {
                        widgetbottomsheet(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _createProcessItem({String? text}) {
    return Container(
      width: 260,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12.0, right: 2.0),
            child: Icon(
              Icons.maximize,
              size: 5.0,
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 180),
            child: createCustomText(
              top: 4.0,
              bottom: 4.0,
              left: 0.0,
              right: 0.0,
              color: AppColors.textGrey,
              weight: AppFontWeight.medium,
              text: text ?? "",
            ),
          ),
        ],
      ),
    );
  }
}
