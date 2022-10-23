import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';
import 'package:illegalparking_app/models/result_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/home.dart';

import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/log_util.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final myPagecontroller = Get.put(MyPageController());
  final loginController = Get.put(LoginController());

  late List<NoticeInfo> noticeList = [];
  late String carName;
  late String carLevel = myPagecontroller.carLevel;
  String? carNum;
  late String reportCount = "0";
  late String currentPoint = "0";

  @override
  void initState() {
    super.initState();
    requestMyPage(Env.USER_SEQ!).then((myPageInfo) {
      Log.debug("carLevel : ${myPageInfo.carLevel}");
      myPagecontroller.setCarLevel(myPageInfo.carLevel);
      setState(() {
        // 차량 정보
        if (myPageInfo.carNum != null) {
          carName = myPageInfo.carName;
          carLevel = myPageInfo.carLevel;
          carNum = myPageInfo.carNum.toString();
          Env.USER_CAR_NUMBER = myPageInfo.carNum.toString();
        }
        //신고 건수
        reportCount = myPageInfo.reportCount.toString();
        //내 포인트
        currentPoint = myPageInfo.currentPoint.toString();
        myPagecontroller.setCurrentPotin(myPageInfo.currentPoint);
        // 공지 사항
        noticeList = myPageInfo.notices;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        // 등록, 신고, 포인트
        if (carNum == "")
          createMypageCard(
            route: () {
              loginController.changeRealPage(4);
            },
            widgetList: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createCustomText(
                    weight: FontWeight.w400,
                    text: "내 차 등록을 진행해 주세요",
                  ),
                  createCustomText(
                    weight: FontWeight.w400,
                    text: "실시간 신고 알림을 받을 수 있습니다",
                  ),
                ],
              ),
              const Spacer(),
              createCustomText(weight: FontWeight.w400, text: ">")
            ],
          ),
        // 인증 완료
        if (carNum != "")
          Stack(
            children: [
              Card(
                elevation: 4,
                child: Material(
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        loginController.changeRealPage(5);
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 100),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: carGradeImage(carLevel),
                                      height: 100,
                                      width: 100,
                                    ),
                                    createCustomText(
                                      weight: FontWeight.w400,
                                      text: Env.USER_CAR_NUMBER,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              createCustomText(
                                weight: FontWeight.w400,
                                text: ">",
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: createCustomText(
                  weight: FontWeight.w400,
                  text: "인증 완료",
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        createMypageCard(
          route: () {
            loginController.changeRealPage(6);
          },
          widgetList: <Widget>[
            createCustomText(
              weight: FontWeight.w400,
              text: "신고이력",
            ),
            const Spacer(),
            createCustomText(
              weight: FontWeight.w400,
              text: "$reportCount건",
            ),
            createCustomText(
              weight: FontWeight.w400,
              text: ">",
            ),
          ],
        ),
        createMypageCard(
          route: () {
            loginController.changeRealPage(7);
          },
          widgetList: <Widget>[
            createCustomText(
              weight: FontWeight.w400,
              text: "내포인트",
            ),
            const Spacer(),
            createCustomText(
              weight: FontWeight.w400,
              text: "${currentPoint}P",
            ),
            createCustomText(
              weight: FontWeight.w400,
              text: ">",
            ),
          ],
        ),
        // 공지
        Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
                child: createCustomText(
                  text: "소식",
                ),
              ),
              Container(
                color: Colors.grey,
                height: 1,
                width: MediaQuery.of(context).size.width,
              ),
              // 공지사항 content
              Wrap(
                children: List.generate(
                  noticeList.length,
                  (index) => SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목(subject)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 4.0,
                          ),
                          child: Row(
                            children: [
                              createCustomText(
                                text: noticeList[index].noticeType,
                              ),
                              createCustomText(
                                weight: FontWeight.w400,
                                text: noticeList[index].subject,
                              ),
                            ],
                          ),
                        ),
                        // 내용(contents)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4.0,
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: createCustomText(
                            weight: FontWeight.w400,
                            // text: _textLengthValidation(noticeList[index].content!) ? noticeList[index].content! : _textSlice(noticeList[index].content!),
                            text: _textSlice(noticeList[index].content!),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4.0,
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: Row(
                            children: [
                              // 날짜(regDt)
                              createCustomText(
                                weight: FontWeight.w400,
                                text: noticeList[index].regDt,
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  _showNoticeDialog(context: context, index: index);
                                },
                                child: createCustomText(
                                  weight: FontWeight.w400,
                                  color: Colors.grey,
                                  text: "더보기 >",
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (noticeList.length != (index + 1))
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
            ],
          ),
        ),
        createElevatedButton(
            text: "더보기",
            function: () {
              requestNotice(Env.USER_SEQ!, noticeList.length, 5).then((noticeListInfo) {
                setState(() {
                  noticeList.addAll(noticeListInfo.noticeInfos);
                });
              });
            })
      ],
    );
  }

  _showNoticeDialog({required BuildContext context, required int index}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          int noticeIndex = index;
          return StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: const Text("소식"),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel_outlined))
                ],
              ),
              body: Dismissible(
                key: ValueKey<int>(noticeIndex),
                resizeDuration: null,
                confirmDismiss: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    if (noticeIndex == (noticeList.length - 1)) {
                      requestNotice(Env.USER_SEQ!, noticeList.length, 5).then((noticeListInfo) {
                        setState(() {
                          noticeList.addAll(noticeListInfo.noticeInfos);
                        });
                      });
                      return Future.value(false);
                    }
                  }

                  if (direction == DismissDirection.startToEnd) {
                    if (noticeIndex == 0) {
                      return Future.value(false);
                    }
                  }

                  return Future.value(true);
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    setState(() {
                      if (noticeIndex < noticeList.length - 1) {
                        noticeIndex++;
                      }
                    });
                  }

                  if (direction == DismissDirection.startToEnd) {
                    setState(() {
                      if (noticeIndex > 0) {
                        noticeIndex--;
                      }
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (noticeIndex > 0) {
                                    noticeIndex--;
                                  }
                                });
                              },
                              icon: const Icon(Icons.chevron_left)),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (noticeIndex < noticeList.length - 1) {
                                    noticeIndex++;
                                  }
                                });
                              },
                              icon: const Icon(Icons.chevron_right)),
                        ],
                      ),
                      // 공지/소식
                      Row(
                        children: [
                          createCustomText(
                            text: noticeList[noticeIndex].noticeType,
                          ),
                          createCustomText(
                            text: noticeList[noticeIndex].subject,
                          ),
                        ],
                      ),

                      createCustomText(
                        weight: FontWeight.w400,
                        text: noticeList[noticeIndex].regDt,
                      ),
                      // // 빈공간
                      // Expanded(
                      //   flex: 5,
                      //   child: ConstrainedBox(
                      //     constraints: const BoxConstraints(),
                      //   ),
                      // ),
                      createCustomText(
                        weight: FontWeight.w400,
                        text: noticeList[noticeIndex].content!,
                      ),
                      // 빈공간
                      // Expanded(
                      //   flex: 5,
                      //   child: ConstrainedBox(
                      //     constraints: const BoxConstraints(),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<bool?> setTrue() {
    return Future.value(false);
  }

  bool _textLengthValidation(String text) {
    if (text.length > 20) {
      return false;
    }
    return true;
  }

  String _textSlice(String text) {
    List textList = text.split('\n');
    String sliceText = "";
    // 한 줄이 너무 길 경우
    int maxLineLength = 27;
    if (textList[0].length > 2 * maxLineLength) {
      // TODO : 자를 텍스트 길이는 화면 비율 확인후 결정
      sliceText += textList[0].substring(0, 2 * (maxLineLength - 1));
      sliceText += "...";
    } else {
      sliceText += textList[0];
      // 첫 째 줄은 짧고 둘째 줄 부터 긴경우
      if (textList.length > 1) {
        if (textList[1].length > maxLineLength) {
          sliceText += "\n${textList[1].substring(0, maxLineLength)}";
          sliceText += "...";
        } else {
          sliceText += "\n${textList[1]}";
        }
      }
    }
    return sliceText;
  }
}
