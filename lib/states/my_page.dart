import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';
import 'package:illegalparking_app/models/result_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

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
      myPagecontroller.setCarLevel(myPageInfo.carLevel);
      setState(() {
        // 차량 정보
        if (myPageInfo.carNum != null) {
          carName = myPageInfo.carName;
          carLevel = myPageInfo.carLevel;
          carNum = myPageInfo.carNum.toString();
          Env.USER_CAR_NUMBER = myPageInfo.carNum.toString();
          Env.USER_CAR_ALARM = myPageInfo.isAlarm;
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
    return Container(
      color: AppColors.appBackground,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createCustomText(
                      padding: 0.0,
                      color: AppColors.white,
                      weight: AppFontWeight.semiBold,
                      size: 24,
                      text: "안녕하세요",
                    ),
                    Row(
                      children: [
                        createCustomText(
                          padding: 0.0,
                          color: AppColors.blue,
                          weight: AppFontWeight.bold,
                          size: 24,
                          text: Env.USER_NAME,
                        ),
                        createCustomText(
                          padding: 0.0,
                          color: AppColors.white,
                          weight: AppFontWeight.semiBold,
                          size: 24,
                          text: "님",
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: AppColors.black,
                    size: 32,
                  ),
                  onPressed: () {
                    loginController.changeRealPage(3);
                  },
                ),
              ],
            ),
          ),
          // 등록, 신고, 포인트
          // if (carNum == "" || carNum == null)
          createMypageContainer(
            route: () {
              loginController.changeRealPage(4);
            },
            widgetList: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createCustomText(
                    padding: 0.0,
                    color: AppColors.textBlack,
                    weight: AppFontWeight.bold,
                    size: 16.0,
                    text: "내 차 등록을 진행해 주세요",
                  ),
                  createCustomText(
                    padding: 0.0,
                    color: AppColors.textGrey,
                    weight: AppFontWeight.medium,
                    size: 10.0,
                    text: "실시간 신고 알림을 받을 수 있습니다",
                  ),
                ],
              ),
              const Spacer(),
              chevronRight(),
            ],
          ),

          // 인증 완료
          if (carNum != "" && carNum != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Stack(
                children: [
                  Container(
                    height: 148,
                    decoration: BoxDecoration(
                      color: AppColors.carRegistBackground,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  Positioned(
                    top: 68,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 80,
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
                          constraints: const BoxConstraints(minHeight: 100),
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
                                        image: carGradeImage(carLevel),
                                        height: 80,
                                        width: 160,
                                      ),
                                      createCustomText(
                                        padding: 0.0,
                                        weight: AppFontWeight.semiBold,
                                        size: 12,
                                        text: carName,
                                      ),
                                      createCustomText(
                                        padding: 0.0,
                                        weight: AppFontWeight.bold,
                                        size: 24,
                                        text: carNum,
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
          createMypageContainer(
            route: () {
              loginController.changeRealPage(6);
            },
            widgetList: <Widget>[
              Image.asset(
                "assets/icon_report.png",
                height: 18,
                width: 18,
              ),
              createCustomText(
                left: 4.0,
                weight: AppFontWeight.bold,
                size: 16.0,
                text: "신고이력",
              ),
              const Spacer(),
              createCustomText(
                right: 0.0,
                weight: AppFontWeight.semiBold,
                size: 26,
                text: reportCount,
              ),
              createCustomText(
                top: 16,
                left: 0.0,
                weight: AppFontWeight.semiBold,
                size: 12,
                text: "건",
              ),
              chevronRight(),
            ],
          ),
          createMypageContainer(
            route: () {
              loginController.changeRealPage(7);
            },
            widgetList: <Widget>[
              Image.asset(
                "assets/icon_point.png",
                height: 18,
                width: 18,
              ),
              createCustomText(
                left: 4.0,
                weight: AppFontWeight.bold,
                size: 16.0,
                text: "내포인트",
              ),
              const Spacer(),
              createCustomText(
                right: 0.0,
                weight: AppFontWeight.semiBold,
                size: 26,
                text: currentPoint,
              ),
              createCustomText(
                top: 16,
                left: 0.0,
                weight: AppFontWeight.semiBold,
                size: 12,
                text: "P",
              ),
              chevronRight(),
            ],
          ),
          // 공지
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icon_infomation.png",
                          height: 18,
                          width: 18,
                        ),
                        createCustomText(
                          left: 4.0,
                          weight: AppFontWeight.bold,
                          size: 16.0,
                          text: "공지사항",
                        ),
                      ],
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
                            Row(
                              children: [
                                // createCustomText(
                                //   color: Colors.blue,
                                //   text: noticeList[index].noticeType,
                                // ),
                                createCustomText(
                                  top: 16.0,
                                  left: 24.0,
                                  right: 24.0,
                                  bottom: 4.0,
                                  weight: AppFontWeight.semiBold,
                                  size: 16.0,
                                  text: noticeList[index].subject,
                                ),
                              ],
                            ),

                            // 내용(contents)
                            createCustomText(
                              top: 4.0,
                              left: 24.0,
                              right: 24.0,
                              bottom: 0.0,
                              // text: _textLengthValidation(noticeList[index].content!) ? noticeList[index].content! : _textSlice(noticeList[index].content!),
                              text: _textSlice(noticeList[index].content!),
                            ),

                            // 날짜(regDt)
                            Row(
                              children: [
                                createCustomText(
                                  top: 4.0,
                                  left: 24.0,
                                  right: 24.0,
                                  bottom: 8.0,
                                  weight: AppFontWeight.regula,
                                  color: AppColors.textGrey,
                                  text: noticeList[index].regDt,
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    _showNoticeDialog(context: context, index: index);
                                  },
                                  child: createCustomText(
                                    top: 4.0,
                                    left: 24.0,
                                    right: 24.0,
                                    bottom: 8.0,
                                    weight: FontWeight.w400,
                                    color: AppColors.textGrey,
                                    text: "더보기 >",
                                  ),
                                ),
                              ],
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
      ),
    );
  }

  _showNoticeDialog({required BuildContext context, required int index}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int noticeIndex = index;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Scaffold(
                  appBar: AppBar(
                    shape: const Border(
                      bottom: BorderSide(
                        color: AppColors.textGrey,
                        width: 1,
                      ),
                    ),
                    elevation: 0,
                    backgroundColor: AppColors.white,
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: createCustomText(
                      weight: AppFontWeight.bold,
                      size: 18.0,
                      text: "공지",
                    ),
                    actions: [
                      IconButton(
                        color: AppColors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  body: Padding(
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
                              icon: chevronLeft(),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (noticeIndex < noticeList.length - 1) {
                                    noticeIndex++;
                                  }
                                });
                              },
                              icon: chevronRight(),
                            ),
                          ],
                        ),
                        // 공지/소식
                        Dismissible(
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
                          child: Container(
                            height: MediaQuery.of(context).size.height - 170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // createCustomText(
                                    //   color: Colors.blue,
                                    //   text: noticeList[noticeIndex].noticeType,
                                    // ),
                                    createCustomText(
                                      bottom: 0.0,
                                      weight: AppFontWeight.semiBold,
                                      size: 16,
                                      text: noticeList[noticeIndex].subject,
                                    ),
                                  ],
                                ),

                                createCustomText(
                                  top: 0.0,
                                  left: 16.0,
                                  weight: AppFontWeight.regula,
                                  color: AppColors.textGrey,
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
                                  weight: AppFontWeight.medium,
                                  text: noticeList[noticeIndex].content!,
                                ),

                                // // 빈공간
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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

// class _RoundedContainer extends StatelessWidget {
//   final Widget child;
//   const _RoundedContainer({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(
//           Radius.circular(18),
//         ),
//       ),
//       child: child,
//     );
//   }
// }
