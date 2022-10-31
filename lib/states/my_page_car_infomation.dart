import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';
import 'package:illegalparking_app/models/result_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/utils/time_util.dart';

class MyPageCarInfomatino extends StatefulWidget {
  const MyPageCarInfomatino({super.key});

  @override
  State<MyPageCarInfomatino> createState() => _MyPageCarInfomatinoState();
}

class _MyPageCarInfomatinoState extends State<MyPageCarInfomatino> {
  final loginController = Get.put(LoginController());
  final myPageController = Get.put(MyPageController());

  late Future<AlarmHistoryListInfo> requestInfo;

  bool checkedAlram = Env.USER_CAR_ALARM ?? false;
  List<dynamic> alarmInfoList = [];
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
  void initState() {
    super.initState();
    requestInfo = requestAlarmHistory(Env.USER_SEQ!, Env.USER_CAR_NUMBER!);
    requestInfo.then((alarmHistoryListInfo) {
      setState(() {
        alarmInfoList = alarmHistoryListInfo.alarmHistoryInfos!;
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
            weight: AppFontWeight.bold,
            color: AppColors.white,
            size: 16,
            text: "내차정보",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // 차량정보
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Stack(
                  children: [
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        color: AppColors.carRegistBackground,
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    Positioned(
                      top: 85,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        height: 145,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      borderRadius: BorderRadius.circular(18.0),
                      child: Ink(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18.0),
                          onTap: () {
                            loginController.changeRealPage(5);
                          },
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 230),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Image(
                                          image: carGradeImage(myPageController.carLevel),
                                          height: 80,
                                          width: 160,
                                        ),
                                        createCustomText(
                                          padding: 0.0,
                                          weight: AppFontWeight.semiBold,
                                          size: 12,
                                          text: Env.USER_CAR_NAME,
                                        ),
                                        createCustomText(
                                          padding: 0.0,
                                          weight: AppFontWeight.bold,
                                          size: 24,
                                          text: Env.USER_CAR_NUMBER,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            createCustomText(
                                              right: 0.0,
                                              text: "내차번호 신고발생 시 바로 알림",
                                            ),
                                            Switch(
                                              activeColor: AppColors.blue,
                                              value: checkedAlram,
                                              onChanged: (value) {
                                                requestMyCarAlarm(Env.USER_SEQ!, Env.USER_CAR_NUMBER!, value).then(
                                                  (defaultInfo) {
                                                    if (defaultInfo.success) {
                                                      setState(() {
                                                        checkedAlram = value;
                                                      });
                                                      showToast(text: "알람 설정이 설정되었습니다.");
                                                    } else {
                                                      Log.debug("${defaultInfo.message}");
                                                      showErrorToast(text: "알람 설정에 실패하였습니다.");
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 인증 마크
                    Positioned(
                      left: 20,
                      child: Container(
                        height: 80,
                        width: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            createCustomText(
                              weight: AppFontWeight.semiBold,
                              text: "인증\n완료",
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 4,
                      left: 32,
                      child: Icon(
                        Icons.gpp_good,
                        color: AppColors.passIcon,
                      ),
                    )
                  ],
                ),
              ),

              // 차량추가 버튼
              createElevatedButton(
                color: AppColors.white,
                textColors: AppColors.black,
                text: "차량 추가",
                function: () {},
              ),
              // 신고된 내용 리스트
              FutureBuilder(
                future: requestInfo,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _createAlarmHistorytList(context, alarmInfoList);
                  } else if (snapshot.hasError) {
                    showErrorToast(text: "데이터를 가져오는데 실패하였습니다.");
                  }
                  return Container(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _createAlarmHistorytList(BuildContext context, List alarmInfoList) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(
          alarmInfoList.length,
          (index) => SizedBox(
            child: Wrap(
              children: [
                Column(
                  children: [
                    //주 정보
                    Row(
                      children: [
                        // 이미지
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
                              "${Env.FILE_SERVER_URL}${alarmInfoList[index].fileName}",
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                "assets/noimage.jpg",
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //주소
                            Container(
                              constraints: addrTextWidthLimit(alarmInfoList[index].stateType, context),
                              child: createCustomText(
                                padding: 0.0,
                                weight: AppFontWeight.bold,
                                // text: _addrTextLengthLimit(reportHistoryList[index].addr),
                                text: alarmInfoList[index].addr,
                              ),
                            ),
                            //시간
                            createCustomText(
                              padding: 0.0,
                              weight: AppFontWeight.medium,
                              color: AppColors.textGrey,
                              size: 12.0,
                              text: alarmInfoList[index].regDt,
                            ),
                          ],
                        ),
                        const Spacer(),
                        // 상태
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            decoration: BoxDecoration(
                              color: reportColors(alarmInfoList[index].stateType),
                              border: Border.all(color: AppColors.grey),
                              borderRadius: BorderRadius.circular(11.0),
                            ),
                            child: createCustomText(
                              weight: FontWeight.w400,
                              color: reportColors(alarmInfoList[index].stateType) == const Color(0xffffffff) ? AppColors.textGrey : Colors.white,
                              // text: alarmInfoList[index].stateType,
                              text: _setAlarmStateText(alarmInfoList[index].stateType),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                //메세지
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        color: _setCommentColor(alarmInfoList[index].stateType),
                        Icons.arrow_right,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 70),
                      child: createCustomText(
                        top: 2.0,
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        weight: AppFontWeight.semiBold,
                        color: _setCommentColor(alarmInfoList[index].stateType),
                        size: 12.0,
                        text: _setCommentByStateType(alarmInfoList[index].stateType, alarmInfoList[index].regDt),
                      ),
                    ),
                  ],
                ),

                if (alarmInfoList.length != (index + 1))
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

  String _setCommentByStateType(String stateType, String regDt) {
    String comment = "";
    switch (stateType) {
      case "신고대기":
        comment = "불법주정차 위반 신고가되었습니다. 1분 안에 차를 이동주차해주세요.";
        break;
      case "신고불가":
        comment = "추가 신고가 없어 신고가 종료되었습니다.";
        break;
      case "신고종료":
        comment = "추가 신고가 없어 신고가 종료되었습니다.";
        break;
      case "신고접수":
        comment = "불법주정차 과태료 대상 접수되어 해당 부서에서 검토중입니다.";
        break;
      case "신고제외":
        comment = "불법주정차 과태료 대상 접수되었지만 신고에서 제외되었습니다.";
        break;
      case "과태료 대상":
        comment = "$regDt에 과태료가 부가 되었습니다.";
        break;
    }
    return comment;
  }

  String _setAlarmStateText(String stateType) {
    String changedState = stateType;
    switch (stateType) {
      case "신고대기":
        changedState = "신고발생";
        break;
      case "신고불가":
        changedState = "신고누락";
        break;
      case "신고종료":
        changedState = "신고누락";
        break;
    }
    return changedState;
  }

  Color _setCommentColor(String stateType) {
    Color changedColor = Colors.black;
    switch (stateType) {
      case "신고대기":
        changedColor = const Color(0xff1B9132);
        break;
      case "신고불가":
        changedColor = const Color(0xff909090);
        break;
      case "신고종료":
        changedColor = const Color(0xff909090);
        break;
      case "신고접수":
        changedColor = const Color(0xffE6940F);
        break;
      case "신고제외":
        changedColor = const Color(0xff272727);
        break;
      case "과태료 대상":
        changedColor = const Color(0xffE23636);
        break;
    }
    return changedColor;
  }
}
