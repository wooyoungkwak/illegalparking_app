import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/models/result_model.dart';
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
      setState(() {
        reportHistoryList = reportHistoryInfo.reportResultInfos;
      });
      for (int i = 0; i < reportHistoryList.length - 1; i++) {
        Log.debug("firstfileName $i: ${reportHistoryList[i].firstFileName}");
        Log.debug("secondfileName $i: ${reportHistoryList[i].secondFileName}");
        Log.debug("firstRegDt $i: ${reportHistoryList[i].firstRegDt}");
        Log.debug("secondRegDt $i: ${reportHistoryList[i].secondRegDt}");
      }
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
            createMypageContainer(
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
            _createReportList(context, reportHistoryList)
          ],
        ),
      ),
    );
  }

  Card _createReportList(BuildContext context, List reportHistoryList) {
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
                    Row(
                      children: [
                        Column(
                          children: [
                            _createReportInfo(
                              reportHistoryList[index].firstFileName,
                              reportHistoryList[index].firstRegDt,
                              reportHistoryList[index].addr,
                              reportHistoryList[index].reportState,
                            ),
                            // 두 번재 이미지, 주소, 사진
                            if (reportHistoryList[index].secondFileName != null && reportHistoryList[index].secondRegDt != null)
                              _createReportInfo(
                                reportHistoryList[index].secondFileName,
                                reportHistoryList[index].secondRegDt,
                                reportHistoryList[index].addr,
                                reportHistoryList[index].reportState,
                              )
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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

  Row _createReportInfo(String fileName, String regDt, String addr, String reportState) {
    return Row(
      // 이미지
      // const Image(height: 80, width: 80, image: AssetImage("assets/noimage.jpg")),
      // Network Error가 계속 발생해서 잠시 막아둠
      children: [
        Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            height: 70,
            width: 70,
            fit: BoxFit.cover,
            "${Env.FILE_SERVER_URL}$fileName",
            errorBuilder: (context, error, stackTrace) => Image.asset(
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              "assets/noimage.jpg",
            ),
          ),
        ),
        //주소 및 시간
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: addrTextWidthLimit(reportState, context),
              child: createCustomText(
                padding: 0.0,
                size: 16.0,
                // text: _addrTextLengthLimit(reportHistoryList[index].addr),
                text: addr,
              ),
            ),
            createCustomText(
              padding: 0.0,
              size: 12.0,
              text: regDt,
            ),
          ],
        ),
      ],
    );
  }
}
