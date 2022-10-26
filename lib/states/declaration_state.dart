import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
import 'package:illegalparking_app/states/widgets/custom_text.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Declaration extends StatefulWidget {
  const Declaration({super.key});

  @override
  State<Declaration> createState() => _DeclarationState();
}

class _DeclarationState extends State<Declaration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ReportController controller = Get.put(ReportController());
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _numberplateContoroller;
  @override
  void initState() {
    super.initState();
    _numberplateContoroller = TextEditingController(text: "");

    SchedulerBinding.instance.addPostFrameCallback((data) async {
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: '데이터를 생성중입니다', barrierDismissible: false);
      try {
        await getGPS();
        sendFileByAI(Env.SERVER_AI_FILE_UPLOAD_URL, controller.carnumberImage.value).then((carNum) {
          carNum = carNum.replaceAll('"', '');
          // ignore: unnecessary_null_comparison
          if (carNum == null || carNum == "") {
            _numberplateContoroller = TextEditingController(text: "인식실패");
            controller.carNumberwrite("인식실패");
          } else {
            _numberplateContoroller = TextEditingController(text: carNum);
            controller.carNumberwrite(carNum);
          }

          if (carNum.length > 10) {
            carNum = "";
          }

          setState(() {});
          Future.delayed(const Duration(milliseconds: 1000), () {
            pd.close();
          });
        });
      } catch (e) {
        showSnackBar(context, "서버 에러");
        pd.close();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _numberplateContoroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = Env.MEDIA_SIZE_PADDINGTOP!;
    return Container(
      child: _createWillPopScope(
        Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Form(
              key: _formKey,
              child: _createscrollView(Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _createContainerByTopWidget(),
                    Column(
                      children: [
                        Obx((() => SizedBox(
                              width: 200,
                              child: Image.file(
                                File(controller.reportImage.value),
                                fit: BoxFit.contain,
                              ),
                            ))),
                        const SizedBox(height: 10),
                        _initInkWellByOnTap(_initContainer(const Color(0xff9B9B9B), "재촬영", 22.0, 210), _reportcamerabtn),
                        const SizedBox(height: 10),
                        Obx((() => SizedBox(width: 200, child: Image.file(File(controller.carnumberImage.value))))),
                        const SizedBox(height: 10),
                        _initInkWellByOnTap(_initContainer(const Color(0xff9B9B9B), "재촬영", 22.0, 210), _numbercamerabtn),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      height: 100,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: "차량번호",
                                weight: FontWeight.w700,
                                size: 12,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 140,
                                height: 40,
                                child: Card(
                                    // child: _createTextFormField(_numberplateContoroller),
                                    child: _createTextFormField(_numberplateContoroller)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CustomText(text: "접수위치", weight: FontWeight.w700, size: 12, color: Colors.black),
                              const SizedBox(
                                width: 10,
                              ),
                              Obx(() {
                                return Flexible(
                                  child: Text(
                                    controller.imageGPS.value.address.length > 1 ? controller.imageGPS.value.address : "위치를 찾을 수 없습니다.",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 10, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
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
                              const CustomText(text: "접수시간", weight: FontWeight.w700, size: 12, color: Colors.black),
                              const SizedBox(
                                width: 12,
                              ),
                              Obx(() {
                                return Flexible(
                                  child: CustomText(text: controller.imageTime.value, weight: FontWeight.w400, size: 12, color: Colors.black),
                                  // Text(
                                  //   controller.imageTime.value,
                                  //   style: const TextStyle(fontSize: 12),
                                  // ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _initInkWellByOnTap(_initContainer(Colors.black, "신고하기", 13.0, 250), _reportbtn),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 210,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        children: const [
                          CustomText(
                            text: "불법주정차 단속 구간에 따라 1분, 5분 이후 해당 차량에 대해 재신고가 기록되어야 과태료 대상 신고접수가 해당기관에 접수됩니다.",
                            weight: FontWeight.w500,
                            size: 10,
                            color: Color(0xffE82525),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ),
            bottomNavigationBar: SizedBox(width: 200, child: _createPaddingBybottomline()),
          ),
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
          color: const Color(0xff2D2D2D),
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
    // ignore: sized_box_for_whitespace
    return Container(
        width: width,
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Center(
              child: CustomText(text: text, weight: FontWeight.w400, color: Colors.white, size: 14),
              // Text(text, style: const TextStyle(color: Colors.white, fontSize: 14))),
            ),
          ),
        ));
  }

  SingleChildScrollView _createscrollView(Widget widget) {
    return SingleChildScrollView(child: Container(child: widget));
  }

  TextFormField _createTextFormField(TextEditingController controller) {
    return TextFormField(
        textAlign: TextAlign.start,
        controller: controller,
        style: const TextStyle(color: Colors.black, fontSize: 12),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|0-9]'))],
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.black),
        ),
        validator: (text) => passwordValidator(text));
  }

  String? passwordValidator(String? text) {
    if (text!.isEmpty) {
      return "차량번호를 입력해주세요";
    }

    return null;
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
    final validSpecial = RegExp(r'^[0-9]{2,3}[가-힣]{1}[0-9]{4}$');
    // ignore: unrelated_type_equality_checks
    if (Env.USER_SEQ == null || Env.USER_SEQ == "") {
      alertDialogByonebutton("알림", "USER_SEQ null");
      return false;
    } else if (controller.imageGPS.value.address == null || controller.imageGPS.value.address == "") {
      alertDialogByonebutton("알림", "주소가 없습니다");
      return false;
    } else if (_numberplateContoroller.text == "인식실패") {
      alertDialogByonebutton("알림", "차량번호가 없습니다");
      return false;
    } else if (_numberplateContoroller.text == null || _numberplateContoroller.text == "") {
      alertDialogByonebutton("알림", "차량번호가 없습니다");
      return false;
    } else if (_numberplateContoroller.text.length > 10) {
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
    } else if (validSpecial.hasMatch(_numberplateContoroller.text) == false) {
      alertDialogByonebutton("알림", "차량번호 형식에 문제가 있습니다");
      return false;
    }
    return true;
  }

  Container _createContainerByTopWidget() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          //좌우 대칭용
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.close_outlined), color: Colors.white),
        ),
        const CustomText(
          text: "신고하기",
          size: 16,
          weight: FontWeight.w500,
          color: Colors.black,
        ),
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
              color: const Color(0xff707070)),
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
      try {
        String text = _numberplateContoroller.text;
        text = text.replaceAll(' ', '');
        alertDialogByonebutton("알림", "실행");
        sendFileByReport(Env.SERVER_ADMIN_FILE_UPLOAD_URL, controller.reportImage.value).then((result) => {
              if (result == false)
                {
                  // TODO : 알림창 띄우기
                  alertDialogByonebutton("알림", "파일 전송에 실패했습니다")
                }
              else
                {
                  sendReport(Env.USER_SEQ!, controller.imageGPS.value.address, _numberplateContoroller.text, controller.imageTime.value, controller.reportfileName.value,
                          controller.imageGPS.value.latitude, controller.imageGPS.value.longitude)
                      .then((reportInfo) => {
                            if (!reportInfo.success) {alertDialogByonebutton("알림", reportInfo.message!)} else {alertDialogByonebutton("신고알림", reportInfo.data!)}
                          })
                }
            });
        Get.offAll(const Confirmation());
      } catch (e) {
        // TODO : 알림창 띄우기
        alertDialogByonebutton("알림", "신고 중 에러 발생");
      }
    }
  }
}
