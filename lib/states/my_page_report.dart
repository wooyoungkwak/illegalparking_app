import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
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
  final loginController = Get.put(LoginController());
  List<dynamic> reportHistoryList = [];
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
    requestReportHistory(Env.USER_SEQ!).then((reportHistoryInfo) {
      Log.debug("requestReportHistory ${reportHistoryInfo.reportResultInfos[0].toString()}");
      setState(() {
        reportHistoryList = reportHistoryInfo.reportResultInfos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        loginController.changeRealPage(2);
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Material(
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                loginController.changeRealPage(2);
              },
              child: const Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
          title: createCustomText(
            text: "신고이력",
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            createMypageCard(
              widgetList: <Widget>[
                createCustomText(
                  weight: FontWeight.w400,
                  text: "나의 신고 이력",
                ),
                const Spacer(),
                createCustomText(
                  padding: 0.0,
                  size: 32.0,
                  text: "${reportHistoryList.length}",
                ),
                createCustomText(
                  padding: 0.0,
                  weight: FontWeight.w400,
                  text: "건",
                ),
              ],
            ),
            createReportList(context, reportHistoryList)
          ],
        ),
      ),
    );
  }

  Card createReportList(BuildContext context, List reportHistoryList) {
    return Card(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(
          reportHistoryList.length,
          (index) => SizedBox(
            child: Wrap(
              children: [
                Column(
                  children: [
                    //주 정보
                    Row(
                      children: [
                        // 이미지
                        const Image(height: 80, width: 80, image: AssetImage("assets/noimage.jpg")),
                        // Network Error가 계속 발생해서 잠시 막아둠
                        // Image.network(
                        //   height: 80,
                        //   width: 80,
                        //   fit: BoxFit.cover,
                        //   "http://49.50.166.205:8090/${reportHistoryList[index].fileName}",
                        //   errorBuilder: (context, error, stackTrace) => Image.asset(
                        //     height: 80,
                        //     width: 80,
                        //     fit: BoxFit.cover,
                        //     "assets/noimage.jpg",
                        //   ),
                        // ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //주소
                            Container(
                              constraints: _addrTextWidthLimit(reportHistoryList[index].reportState),
                              child: createCustomText(
                                padding: 0.0,
                                size: 16.0,
                                // text: _addrTextLengthLimit(reportHistoryList[index].addr),
                                text: reportHistoryList[index].addr,
                              ),
                            ),
                            //시간
                            createCustomText(
                              padding: 0.0,
                              size: 12.0,
                              text: reportHistoryList[index].firstRegDt,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: reportColors(reportHistoryList[index].reportState),
                            child: createCustomText(
                              weight: FontWeight.w400,
                              color: reportColors(reportHistoryList[index].reportState) == const Color(0xffffffff) ? Colors.black : Colors.white,
                              text: reportHistoryList[index].reportState,
                            ),
                          ),
                        )
                        // 상태
                      ],
                    ),
                  ],
                ),
                //메세지
                Column(
                  children: List.generate(
                    reportHistoryList[index].comments.length,
                    (commentIndex) => createCustomText(
                      left: 32.0,
                      size: 12.0,
                      text: "* ${reportHistoryList[index].comments[commentIndex]}",
                    ),
                  ),
                ),

                if (reportHistoryList.length != (index + 1))
                  Container(
                    color: Colors.grey,
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color reportColors(String state) {
    Color color = const Color(0xffffffff);
    switch (state) {
      case "신고발생":
        color = const Color(0xffffc107);
        break;
      case "신고대기":
        color = const Color(0xffffc107);
        break;
      case "신고접수":
        color = const Color(0xffd84315);
        break;
      case "신고제외":
        color = const Color(0xff9e9e9e);
        break;
      case "과태료 대상":
        color = const Color(0xffbf360c);
        break;
    }
    return color;
  }

  BoxConstraints _addrTextWidthLimit(String state) {
    if (state.length > 5) {
      Log.debug("report state 5: $state");
      return const BoxConstraints(maxWidth: 198); // 4글자 : 218, 5글자 : 198
    }
    Log.debug("report state 4 : $state");
    return const BoxConstraints(maxWidth: 218);
  }
}
