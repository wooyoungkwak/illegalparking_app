import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Row(
            children: [
              createCustomText(
                padding: 0.0,
                size: 24.0,
                color: Colors.red,
                text: " 불법주정차 신고",
              ),
              createCustomText(
                padding: 0.0,
                size: 16.0,
                text: "를 위해서",
              ),
            ],
          ),
          createCustomText(
            padding: 0.0,
            size: 16.0,
            text: "  로그인이 필요합니다.",
          ),

          createElevatedButton(
            text: "바로가기",
            function: () {
              loginController.changePage(2);
            },
          ),

          // 불법주정차 신고 프로세스
          createCustomText(
            size: 16.0,
            text: "불법주정차 신고 프로세스",
          ),
          _createProcessItem(text: "사진만 찍으면 자동 정보 분석후 신고가 진행됩니다."),
          _createProcessItem(text: "불법주정차 단속구역 분석"),
          _createProcessItem(text: "불법주정차 단속시간 분석"),
          _createProcessItem(text: "차량번호판 활영은 필수 입니다."),
          _createProcessItem(text: "노란색 실선 지역은 1분 이산 간격으로 신고가 한번더 작성되어야 합니다."),
          _createProcessItem(text: "노란색 점선 지역은 5분 이상 간격으로 사진이 신고가 한번 더 작성되어야 합니다."),
        ],
      ),
    );
  }

  Padding _createProcessItem({String? text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 11.0, right: 0.0),
            child: Icon(
              Icons.fiber_manual_record_sharp,
              size: 12.0,
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 92),
            child: createCustomText(
              size: 16.0,
              weight: FontWeight.w400,
              text: text ?? "",
            ),
          ),
        ],
      ),
    );
  }
}
