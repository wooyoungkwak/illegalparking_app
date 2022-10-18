import 'package:flutter/material.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/utils/time_util.dart';

class MyPageReport extends StatefulWidget {
  const MyPageReport({super.key});

  @override
  State<MyPageReport> createState() => _MyPageReportState();
}

class _MyPageReportState extends State<MyPageReport> {
  List testList = [
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고대기",
      "message": "1분 이후 추가 접수가 필요합니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고종료",
      "message": "추가 신고가 없어 종료되었습니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고종료",
      "message": "동일 차량번호 불법주정차 신고 접수가 타인에 의해 먼저 접수되었습니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고종료",
      "message": "불법 주정차 추가 신고 시간이 초과했습니다. \n * 최초신고 이후 1분 이후 10분이내 추가 신고가 되어야 합니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고접수",
      "message": "불법주정차 신고 접수 완료되어 해당 부서에 전송되었습니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고제외",
      "message": "불법주정차 과태료 대산 접수되었지만 최종 신고에 제외되었습니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "과태료대상",
      "message": "해당 불법 주정차 차량에 과태료가 부가되었습니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고불가",
      "message": "불법주정차 대상지역이 아닙니다.",
    },
    {
      "image": "assets/noimage.jpg",
      "address": "01 가 1234 광양시 중동",
      "time": getDateToStringForAll(getNow()),
      "state": "신고불가",
      "message": "불법주정차 단속시간이 아닙니다.",
    },
  ];

  @override
  void initState() {
    super.initState();
    requestReportHistory(2).then((value) {
      Log.debug(value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: createCustomText(
          text: "신고이력",
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          createMypageCard(
            route: () {
              Navigator.pushNamed(context, "/report");
            },
            widgetList: <Widget>[
              createCustomText(
                weight: FontWeight.w400,
                text: "나의 신고 이력",
              ),
              const Spacer(),
              createCustomText(
                padding: 0.0,
                size: 32.0,
                text: "${testList.length}",
              ),
              createCustomText(
                padding: 0.0,
                weight: FontWeight.w400,
                text: "건",
              ),
            ],
          ),
          createReportList(context, testList)
        ],
      ),
    );
  }
}
