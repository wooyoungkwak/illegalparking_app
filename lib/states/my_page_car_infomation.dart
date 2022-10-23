import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';
import 'package:illegalparking_app/models/result_model.dart';
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
  final loginController = Get.put(LoginController());
  final myPageController = Get.put(MyPageController());

  bool checkedAlram = false;
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
    requestAlarmHistory(Env.USER_SEQ!, Env.USER_CAR_NUMBER!).then((alarmHistoryListInfo) {
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
                          Image(
                            image: carGradeImage(myPageController.carLevel),
                            height: 100,
                            width: 100,
                          ),
                          createCustomText(text: Env.USER_CAR_NUMBER),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              createCustomText(text: "내차번호 신고발생 시 바로 알림"),
                              Switch(
                                  value: checkedAlram,
                                  onChanged: (value) {
                                    requestMyCarAlarm(2, Env.USER_CAR_NUMBER!, value).then((defaultInfo) {
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
            _createAlarmHistorytList(context, alarmInfoList),
          ],
        ),
      ),
    );
  }

  Card _createAlarmHistorytList(BuildContext context, List alarmInfoList) {
    return Card(
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
                        // const Image(height: 80, width: 80, image: AssetImage("assets/noimage.jpg")),
                        // Network Error가 계속 발생해서 잠시 막아둠
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            "${Env.FILE_SERVER_URL}${alarmInfoList[index].fileName}",
                            height: 70,
                            width: 70,
                            fit: BoxFit.none,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              "assets/noimage.jpg",
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
                                size: 16.0,
                                // text: _addrTextLengthLimit(reportHistoryList[index].addr),
                                text: alarmInfoList[index].addr,
                              ),
                            ),
                            //시간
                            createCustomText(
                              padding: 0.0,
                              size: 12.0,
                              text: alarmInfoList[index].regDt,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: reportColors(alarmInfoList[index].stateType),
                            child: createCustomText(
                              weight: FontWeight.w400,
                              color: reportColors(alarmInfoList[index].stateType) == const Color(0xffffffff) ? Colors.black : Colors.white,
                              // text: alarmInfoList[index].stateType,
                              text: _setAlarmStateText(alarmInfoList[index].stateType),
                            ),
                          ),
                        )
                        // 상태
                      ],
                    ),
                  ],
                ),
                //메세지
                createCustomText(
                  left: 32.0,
                  size: 12.0,
                  color: _setCommentColor(alarmInfoList[index].stateType),
                  text: _setCommentByStateType(alarmInfoList[index].stateType, alarmInfoList[index].regDt),
                ),

                if (alarmInfoList.length != (index + 1))
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

  String _setCommentByStateType(String stateType, String regDt) {
    String comment = "";
    switch (stateType) {
      case "신고대기":
        comment = "* 불법주정차 위반 신고가되었습니다. 1분 안에 차를 이동주차해주세요.";
        break;
      case "신고불가":
        comment = "* 추가 신고가 없어 신고가 종료되었습니다.";
        break;
      case "신고종료":
        comment = "* 추가 신고가 없어 신고가 종료되었습니다.";
        break;
      case "신고접수":
        comment = "* 불법주정차 과태료 대상 접수되어 해당 부서에서 검토중입니다.";
        break;
      case "신고제외":
        comment = "* 불법주정차 과태료 대상 접수되었지만 신고에서 제외되었습니다.";
        break;
      case "과태료 대상":
        comment = "* $regDt에 과태료가 부가 되었습니다.";
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
