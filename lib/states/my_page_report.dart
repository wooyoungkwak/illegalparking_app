import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/models/result_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/time_util.dart';

class MyPageReport extends StatefulWidget {
  const MyPageReport({super.key});

  @override
  State<MyPageReport> createState() => _MyPageReportState();
}

class _MyPageReportState extends State<MyPageReport> {
  final loginController = Get.put(LoginController());
  late Future<ReportHistoryInfo> requestInfo;

  List<dynamic> reportHistoryList = [];
  List textList = [
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
    requestInfo = requestReportHistory(Env.USER_SEQ!);
    requestInfo.then((reportHistoryInfo) {
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
        backgroundColor: AppColors.appBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.appBackground,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Material(
            color: AppColors.appBackground,
            child: InkWell(
              onTap: () {
                loginController.changeRealPage(2);
              },
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.white,
                size: 40,
              ),
            ),
          ),
          title: createCustomText(
            color: AppColors.white,
            weight: AppFontWeight.bold,
            size: 16,
            text: "신고이력",
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: createMypageContainer(
                widgetList: <Widget>[
                  createCustomText(
                    weight: AppFontWeight.bold,
                    size: 16.0,
                    text: "나의 신고이력",
                  ),
                  const Spacer(),
                  createCustomText(
                    right: 0.0,
                    weight: AppFontWeight.semiBold,
                    size: 26,
                    text: "${reportHistoryList.length}",
                  ),
                  createCustomText(
                    top: 16,
                    left: 0.0,
                    weight: AppFontWeight.semiBold,
                    size: 12,
                    text: "건",
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: requestInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                    child: _createReportList(context, reportHistoryList),
                  );
                } else if (snapshot.hasError) {
                  showErrorToast(text: "데이터를 가져오는데 실패하였습니다.");
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0, left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        createCustomText(color: AppColors.black, text: "로딩중..."),
                        const CircularProgressIndicator(
                          color: AppColors.black,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _createReportList(BuildContext context, List reportHistoryList) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.0),
      ),
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
                        // 상태
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            decoration: BoxDecoration(
                              color: reportColors(reportHistoryList[index].reportState),
                              border: Border.all(color: AppColors.grey),
                              borderRadius: BorderRadius.circular(11.0),
                            ),
                            child: createCustomText(
                              weight: AppFontWeight.semiBold,
                              color: reportColors(reportHistoryList[index].reportState) == const Color(0xffffffff) ? AppColors.textGrey : AppColors.white,
                              text: reportHistoryList[index].reportState,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                //메세지
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    reportHistoryList[index].comments.length,
                    (commentIndex) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Image.asset(height: 14, width: 12, "assets/icon_comment.png"),
                        ),
                        Expanded(
                          child: createCustomText(
                            top: 0.0,
                            bottom: 0.0,
                            left: 4.0,
                            right: 4.0,
                            weight: AppFontWeight.semiBold,
                            color: AppColors.textGrey,
                            size: 12.0,
                            text: "${reportHistoryList[index].comments[commentIndex]}",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (reportHistoryList.length != (index + 1))
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
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
          // color: AppColors.grey,
          width: 66,
          height: 66,
          padding: const EdgeInsets.all(8.0),
          // child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Image.asset("assets/noimage.jpg")),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
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
        ),
        //주소 및 시간
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: addrTextWidthLimit(reportState, context),
              child: createCustomText(
                padding: 0.0,
                weight: AppFontWeight.bold,
                // text: _addrTextLengthLimit(reportHistoryList[index].addr),
                text: addr,
              ),
            ),
            createCustomText(
              padding: 0.0,
              weight: AppFontWeight.medium,
              color: AppColors.textGrey,
              size: 12.0,
              text: regDt,
            ),
          ],
        ),
      ],
    );
  }
}
