import 'package:flutter/material.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/utils/time_util.dart';

class MyPageCarInfomatino extends StatefulWidget {
  const MyPageCarInfomatino({super.key});

  @override
  State<MyPageCarInfomatino> createState() => _MyPageCarInfomatinoState();
}

class _MyPageCarInfomatinoState extends State<MyPageCarInfomatino> {
  bool checkedAlram = false;
  List testList = [
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고발생",
      "message": "불법주정차 위반 신고되었습니다. 1분 안에 차를 이동주차해주세요.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고누락",
      "message": "추가 신고가 없어 신고가 종료되었습니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고접수",
      "message": "불법주정차 과태료 대상 접수되어 해당부서에서 검토중 입니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고제외",
      "message": "불법주정차 과태료 대상 접수되었지만 최종 신고에서 제외되었습니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "과태료대상",
      "message": "${getDateToStringForAll(getNow())}에 과태료가 부가 되었습니다.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: createCustomText(text: "내차정보"),
      ),
      body: ListView(
        children: [
          // 차량정보
          Stack(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage("assets/testVehicle.jpg"),
                          height: 100,
                          width: 100,
                        ),
                        createCustomText(text: "123가 4567"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            createCustomText(text: "내차번호 신고발생 시 바로 알림"),
                            Switch(
                                value: checkedAlram,
                                onChanged: (value) {
                                  requestMyCarAlarm(2, "123가1234", value).then((defaultInfo) {
                                    if (defaultInfo.success) {
                                      setState(() {
                                        checkedAlram = value;
                                      });
                                    } else {
                                      Log.debug("${defaultInfo.message}");
                                    }
                                  });
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 15,
                left: 15,
                child: Text(
                  "인증 완료",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: IconButton(
                  iconSize: 32.0,
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          // 차량추가 버튼
          createElevatedButton(text: "차량 추가"),
          // 신고된 내용 리스트
          createReportList(context, testList),
        ],
      ),
    );
  }
}
