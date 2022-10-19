import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/services/such_loation_service.dart';
import 'package:illegalparking_app/states/home.dart';
import 'package:illegalparking_app/states/confirmation.state.dart';
import 'package:illegalparking_app/states/car_number_camera_state.dart';
import 'package:illegalparking_app/states/car_report_camera_state.dart';
import 'package:illegalparking_app/services/save_image_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Declaration extends StatefulWidget {
  const Declaration({super.key});

  @override
  State<Declaration> createState() => _DeclarationState();
}

class _DeclarationState extends State<Declaration> {
  final ReportController controller = Get.put(ReportController());
  final ScrollController _scrollController = ScrollController();
  // ignore: non_constant_identifier_names
  late TextEditingController _NumberplateContoroller;

  // List<String> filelist = [controller.reportImage.value, controller.carnumberImage.value];

  @override
  void initState() {
    super.initState();
    // regeocoder(); //주소가져오기
    //getGPS();

    // TODO : 사용자 키 반드시 적용 할것 ..
    Env.USER_SEQ = 2;

    // 샘플
    _NumberplateContoroller = TextEditingController(text: "12가1234");

    SchedulerBinding.instance.addPostFrameCallback((data) async {
      //빌드가 끝나고 실행하는걸 예약하는 기능
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: '데이터를 생성중입니다', barrierDismissible: false);
      try {
        // await regeocoder().then((value) => pd.close());
        await getGPS().then((value) => pd.close());
        // sendFileByAI(Env.SERVER_AI_FILE_UPLOAD_URL, controller.carnumberImage.value).then((carNum) {
        //   if (carNum == null || carNum == "") {
        //     //글자가 없을 때 반환 받는 값
        //     _NumberplateContoroller = TextEditingController(text: "인식 실패");
        //     controller.carNumberwrite("인식 실패");
        //   } else {
        //     _NumberplateContoroller = TextEditingController(text: carNum);
        //     controller.carNumberwrite(carNum);
        //   }

        //   if (carNum.length > 10) {
        //     carNum = "";
        //   }
        //   carNum = carNum.replaceAll('"', '');
        //   setState(() {});
        //   Future.delayed(const Duration(milliseconds: 500), () {
        //     pd.close();
        //   });
        // });
      } catch (e) {
        showSnackBar(context, "서버 에러");
        pd.close();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _NumberplateContoroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // regeocoder().then((value) {
    //    sendFile(Env.SERVER_AI_FILE_UPLOAD_URL, filelist).then((value) {
    //    });
    // });
    List<String> filelist = [controller.reportImage.value, controller.carnumberImage.value];
    final statusBarHeight = Env.MEDIA_SIZE_PADDINGTOP!;

    return _createWillPopScope(
      Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _createContainerByTopWidget(),
                Column(
                  children: [
                    Obx((() => SizedBox(
                          width: 200,
                          // height: 150,
                          child: Image.file(
                            File(controller.reportImage.value),
                            fit: BoxFit.contain,
                            //비율 조절하면 사진 잘리거나 찌그러짐
                            //선택 1.가능 비율 유지 크게 or 2.화면 디자인에 맞춰서 작게
                          ),
                        ))),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Get.to(const Reportcamera());
                    //     // Navigator.pop(context);
                    //   },
                    //   child: const Text('재촬영'),
                    // ),
                    SizedBox(height: 10),
                    _initInkWellByOnTap(_initContainer(Color(0xff9B9B9B), "재촬영", 22.0, 210), _reportcamerabtn),
                    SizedBox(height: 10),
                    Obx((() => SizedBox(width: 200, child: Image.file(File(controller.carnumberImage.value))))),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Get.to(const Numbercamera());
                    //   },
                    //   child: const Text('재촬영'),
                    // ),
                    SizedBox(height: 10),
                    _initInkWellByOnTap(_initContainer(Color(0xff9B9B9B), "재촬영", 22.0, 210), _numbercamerabtn),
                  ],
                ),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.baseline,
                    // textBaseline: TextBaseline.ideographic,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "차량번호",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(width: 140, height: 40, child: Card(child: _createTextFormField(_NumberplateContoroller))),
                          // Obx(() {
                          //   Log.debug("carNumber: ${controller.carNumber.value}");
                          //   if (controller.carNumber.value.length > 2) {
                          //     _NumberplateContoroller = TextEditingController(text: controller.carNumber.value);
                          //     return SizedBox(width: 200, height: 50, child: Card(child: _createTextFormField(_NumberplateContoroller)));
                          //   } else {
                          //     return SizedBox(width: 200, height: 50, child: Card(child: _createTextFormField(_NumberplateContoroller)));
                          //   }
                          // })
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "접수위치",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(() {
                            return Flexible(
                              child: Text(
                                controller.imageGPS.value.address.length > 1 ? controller.imageGPS.value.address : "위치를 찾을 수 없습니다.",
                                //controller.imageGPS.value.address.substring(4),//구글 map사용해서 앞에 대한민국 붙음
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          })
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "접수시간",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          // Text(
                          //   getDateToStringForYYYYMMDDHHMMKORInNow(),
                          //   style: const TextStyle(fontSize: 12),
                          // ),
                          Obx(() {
                            return Flexible(
                              child: Text(
                                controller.imageTime.value,
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }),
                        ],
                      ),
                      // Obx(() {
                      //   return Flexible(
                      //     child: Text(
                      //       controller.imageGPS.value.latitude.toString(),
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   );
                      // }),
                      // Obx(() {
                      //   return Flexible(
                      //     child: Text(
                      //       controller.imageGPS.value.longitude.toString(),
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   );
                      // })
                    ],
                  ),
                ),

                // Expanded(
                //   flex: 1,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       ElevatedButton(
                //         onPressed: () async {
                //           if (valuenullCheck()) {
                //             await saveImageGallery();
                //             // Get.off(const Confirmation());
                //             try {
                //               alertDialogByonebutton("알림", "실행");
                //               // sendFileByReport(Env.SERVER_ADMIN_FILE_UPLOAD_URL, controller.reportImage.value).then((result) => {
                //               //       if (result == false)
                //               //         {
                //               //           // TODO : 알림창 띄우기
                //               //           alertDialogByonebutton("알림", "파일 전송에 실패했습니다")
                //               //         }
                //               //       else
                //               //         {
                //               //           sendReport(Env.USER_SEQ!, controller.imageGPS.value.address, _NumberplateContoroller.text, controller.imageTime.value, controller.reportfileName.value,
                //               //                   controller.imageGPS.value.latitude, controller.imageGPS.value.longitude)
                //               //               .then((reportInfo) => {
                //               //                     if (!reportInfo.success) {alertDialogByonebutton("알림", reportInfo.message!)}
                //               //                   })
                //               //         }
                //               //     });

                //               // sendReport(controller.imageGPS.value.address, controller.carNumber.value, controller.imageTime.value, controller.reportfileName.value,
                //               //         controller.imageGPS.value.latitude, controller.imageGPS.value.longitude)
                //               //     .then((reportInfo) => {
                //               //           alertDialogByonebutton("알림", reportInfo.toJson().toString())
                //               //           // Log.debug(reportInfo.toJson().toString())
                //               //         });
                //               Get.off(const Confirmation());
                //             } catch (e) {
                //               // TODO : 알림창 띄우기
                //               alertDialogByonebutton("알림", "신고 중 에러 발생");
                //             }
                //           }
                //         },
                //         child: const Text('신고하기'),
                //       ),
                //     ],
                //   ),
                // ),

                _initInkWellByOnTap(_initContainer(Colors.black, "신고하기", 13.0, 250), _reportbtn),
                SizedBox(height: 5),
                Container(
                  width: 200,
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: const [
                      Text(
                        "불법주정차 단속 구간에 따라 1분, 5분 이후 해당 차량에 대해 재신고가 기록되어야 과태료 대상 신고접수가 해당기관에 접수됩니다.",
                        style: TextStyle(fontSize: 10, color: Color(0xffE82525)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(width: 200, child: _createPaddingBybottomline()),
        ),
      ),
    );
  }

  Padding _createPaddingBybottomline() {
    double widthsize = (Env.MEDIA_SIZE_WIDTH! / 2) - (55);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthsize, vertical: 8),
      child: Container(
        alignment: const Alignment(0, 0),
        height: 5.0,
        width: 110.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Color(0xff2D2D2D),
        ),
      ),
    );
  }

  //탭기능
  InkWell _initInkWellByOnTap(Widget widget, Function function) {
    return InkWell(
      onTap: () {
        function();
      },
      child: widget,
    );
  }

  //버튼디자인
  Container _initContainer(Color color, String text, double radius, double width) {
    return Container(
      width: width,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 11),
          child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 14))),
        ),
      ),
    );
  }

  TextField _createTextFormField(TextEditingController controller) {
    return TextField(
        textAlign: TextAlign.start,
        controller: controller,
        style: const TextStyle(color: Colors.black, fontSize: 12),
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: '번호판 입력란',
          hintStyle: TextStyle(color: Colors.black),
        ));
  }

  WillPopScope _createWillPopScope(Widget widget) {
    return WillPopScope(
        onWillPop: () {
          // Get.offAll(() => main());
          return Future(() => false);
        },
        child: widget);
  }

  bool valuenullCheck() {
    if (Env.USER_SEQ == null || Env.USER_SEQ == "") {
      alertDialogByonebutton("알림", "USER_SEQ null");
      return false;
    } else if (controller.imageGPS.value.address == null || controller.imageGPS.value.address == "") {
      alertDialogByonebutton("알림", "주소가 없습니다");
      return false;
    } else if (_NumberplateContoroller.text == null || _NumberplateContoroller.text == "") {
      alertDialogByonebutton("알림", "차량번호가 없습니다");
      return false;
    } else if (_NumberplateContoroller.text.length > 10) {
      alertDialogByonebutton("알림", "차량번호가 문자수가 초과하였습니다.");
      return false;
    } else if (controller.imageTime.value == null || controller.imageTime.value == "") {
      alertDialogByonebutton("알림", "사진 촬영이 시간이 없습니다");
      return false;
    } else if (controller.reportfileName.value == null || controller.reportfileName.value == "") {
      alertDialogByonebutton("알림", "사진 이름이 없습니다");
      return false;
    } else if (controller.imageGPS.value.latitude == null || controller.imageGPS.value.longitude == null || controller.imageGPS.value.latitude == "" || controller.imageGPS.value.longitude == "") {
      alertDialogByonebutton("알림", "위도 경도가 없습니다");
      return false;
    }
    return true;
  }

  Container _createContainerByTopWidget() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          //좌우 대칭용
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.close_outlined), color: Colors.white),
        ),
        Text("신고하기"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () {
                controller.carreportImagewrite("");
                controller.carnumberImagewrite("");
                Get.off(const Home(
                  index: 1,
                ));
              },
              icon: const Icon(Icons.close_outlined),
              color: Color(0xff707070)),
        ),
      ]),
    );
  }

  void _reportcamerabtn() {
    Get.to(const Reportcamera());
    // Get.to(const Home(
    //   index: 1,
    // ));
    //카메라 화면에서 내정보나 맵 이동시 문제생김
  }

  void _numbercamerabtn() {
    controller.carNumberwrite("");
    Get.to(const Numbercamera());
  }

  void _reportbtn() async {
    if (valuenullCheck()) {
      await saveImageGallery();
      // Get.off(const Confirmation());
      try {
        alertDialogByonebutton("알림", "실행");
        // sendFileByReport(Env.SERVER_ADMIN_FILE_UPLOAD_URL, controller.reportImage.value).then((result) => {
        //       if (result == false)
        //         {
        //           // TODO : 알림창 띄우기
        //           alertDialogByonebutton("알림", "파일 전송에 실패했습니다")
        //         }
        //       else
        //         {
        //           sendReport(Env.USER_SEQ!, controller.imageGPS.value.address, _NumberplateContoroller.text, controller.imageTime.value, controller.reportfileName.value,
        //                   controller.imageGPS.value.latitude, controller.imageGPS.value.longitude)
        //               .then((reportInfo) => {
        //                     if (!reportInfo.success) {alertDialogByonebutton("알림", reportInfo.message!)}
        //                   })
        //         }
        //     });

        // sendReport(controller.imageGPS.value.address, controller.carNumber.value, controller.imageTime.value, controller.reportfileName.value,
        //         controller.imageGPS.value.latitude, controller.imageGPS.value.longitude)
        //     .then((reportInfo) => {
        //           alertDialogByonebutton("알림", reportInfo.toJson().toString())
        //           // Log.debug(reportInfo.toJson().toString())
        //         });
        Get.offAll(const Confirmation());
      } catch (e) {
        // TODO : 알림창 띄우기
        alertDialogByonebutton("알림", "신고 중 에러 발생");
      }
    }
  }
}
