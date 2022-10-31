// ignore_for_file: unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
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
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:popover/popover.dart';
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
  late FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _numberplateContoroller = TextEditingController(text: "");

    SchedulerBinding.instance.addPostFrameCallback((data) async {
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: '데이터를 생성중입니다', barrierDismissible: false);
      try {
        await getGPS();
        sendFileByAI(Env.SERVER_AI_FILE_UPLOAD_URL, controller.carnumberImage.value).then((carNum) {
          carNum = carNum.replaceAll('"', '');

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
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = Env.MEDIA_SIZE_PADDINGTOP!;
    return GestureDetector(
      onTap: () => myFocusNode.unfocus(),
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
                    createContainerByTopWidget(text: "신고하기", function: _escbtn),
                    Column(
                      children: [
                        (Obx((() => _initInkWellByImageTap(controller.reportImage.value, Env.MEDIA_SIZE_HEIGHT! / 5)))),
                        const SizedBox(height: 10),
                        _initInkWellByOnTap(_initContainer(const Color(0xff9B9B9B), "재촬영", 22.0, Env.MEDIA_SIZE_WIDTH! / 1.5), _reportcamerabtn),
                        const SizedBox(height: 10),
                        Obx((() => _initInkWellByImageTap(controller.carnumberImage.value, Env.MEDIA_SIZE_HEIGHT! / 10))),
                        const SizedBox(height: 10),
                        _initInkWellByOnTap(_initContainer(const Color(0xff9B9B9B), "재촬영", 22.0, Env.MEDIA_SIZE_WIDTH! / 1.5), _numbercamerabtn),
                        const SizedBox(height: 30),
                      ],
                    ),
                    SizedBox(
                      width: Env.MEDIA_SIZE_WIDTH! / 1.5,
                      height: Env.MEDIA_SIZE_HEIGHT! / 2.9,
                      child: Column(
                        children: [
                          _initRowByData("차량번호", SizedBox(width: Env.MEDIA_SIZE_WIDTH! / 2.3, height: Env.MEDIA_SIZE_HEIGHT! / 20, child: _createTextFormField(_numberplateContoroller))),
                          const SizedBox(height: 5),
                          // _initRowByData(
                          //     "접수위치",
                          //     SizedBox(
                          //       width: Env.MEDIA_SIZE_WIDTH! / 2.3,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           showPopover(
                          //             context: context,
                          //             bodyBuilder: (context) => Text("test"),
                          //             onPop: () => print('Popover was popped!'),
                          //             direction: PopoverDirection.bottom,
                          //             width: 200,
                          //             height: 400,
                          //             arrowHeight: 15,
                          //             arrowWidth: 30,
                          //           );
                          //         },
                          //         child: Text(controller.imageGPS.value.address.length > 1 ? controller.imageGPS.value.address : "위치를 찾을 수 없습니다.",
                          //             maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400)),
                          //       ),
                          //     )),
                          Poptext(),
                          const SizedBox(
                            height: 5,
                          ),
                          _initRowByData("접수시간", CustomText(text: controller.imageTime.value, weight: FontWeight.w400, size: 16, color: Colors.black)),
                          const SizedBox(height: 30),
                          _initInkWellByOnTap(_initContainer(Colors.black, "신고하기", 13.0, 250), _reportbtn),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: Env.MEDIA_SIZE_WIDTH! / 1.5,
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
                    ),
                  ],
                ),
              )),
            ),
            bottomNavigationBar: SizedBox(width: Env.MEDIA_SIZE_WIDTH! / 2.5, child: _createPaddingBybottomline()),
          ),
        ),
      ),
    );
  }

  InkWell _initInkWellByImageTap(String path, double height) {
    return InkWell(
      onTap: () {
        showDialog(
            barrierColor: AppColors.black,
            context: context,
            builder: (BuildContext context) => Dialog(
                  child: GestureDetector(
                    onTap: () {
                      navigator?.pop();
                    },
                    child: Image.file(
                      width: Env.MEDIA_SIZE_WIDTH! - 50,
                      File(path),
                      fit: BoxFit.contain,
                    ),
                  ),
                ));
      },
      child: _initSizedBoxByImage(path, height),
    );
  }

  SizedBox _initSizedBoxByImage(String path, double height) {
    return SizedBox(
      width: Env.MEDIA_SIZE_WIDTH! / 1.5,
      height: height,
      child: Image.file(
        File(path),
        fit: BoxFit.fill,
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
        width: Env.MEDIA_SIZE_WIDTH! / 4,
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
  SizedBox _initContainer(Color color, String text, double radius, double width) {
    return SizedBox(
        width: width,
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Center(
              child: CustomText(text: text, weight: FontWeight.w400, color: Colors.white, size: 14),
            ),
          ),
        ));
  }

  SingleChildScrollView _createscrollView(Widget widget) {
    return SingleChildScrollView(child: Container(child: widget));
  }

  TextFormField _createTextFormField(TextEditingController controller) {
    return TextFormField(
        // autofocus: true,
        focusNode: myFocusNode,
        textAlign: TextAlign.center,
        controller: controller,
        style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w500),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|0-9]'))],
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 8.0, right: 8.0),
          border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Color(0xff9B9B9B))),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Color(0xff9B9B9B))),
          filled: false,
          fillColor: Color.fromARGB(20, 180, 169, 169),
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
      alertDialogByonebutton("알림", "접수시간이 없습니다");
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

  void _escbtn() {
    controller.carreportImagewrite("");
    controller.carnumberImagewrite("");
    Get.off(const Home(
      index: 1,
    ));
  }

  void back() {
    Get.back();
  }

  void _reportcamerabtn() {
    Get.to(const Reportcamera());
  }

  void _numbercamerabtn() {
    controller.carNumberwrite("");
    Get.to(const Numbercamera());
  }

  void _reportbtn() async {
    if (valuenullCheck()) {
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: '신고를 처리중입니다', barrierDismissible: false);
      await saveImageGallery();
      try {
        String text = _numberplateContoroller.text;
        text = text.replaceAll(' ', '');
        // Get.offAll(const Confirmation()); //테스트용

        sendFileByReport(Env.SERVER_ADMIN_FILE_UPLOAD_URL, controller.reportImage.value).then((result) => {
              if (result == false)
                {Env.REPORT_RESPONSE_MSG = "파일 전송에 실패했습니다"}
              else
                {
                  sendReport(Env.USER_SEQ!, controller.imageGPS.value.address, _numberplateContoroller.text, controller.imageTime.value, controller.reportfileName.value,
                          controller.imageGPS.value.latitude, controller.imageGPS.value.longitude)
                      .then((reportInfo) {
                    if (!reportInfo.success) {
                      Env.REPORT_RESPONSE_MSG = reportInfo.message!;
                    } else {
                      Env.REPORT_RESPONSE_MSG = reportInfo.data!;
                    }
                    pd.close();
                    Get.offAll(const Confirmation());
                  })
                }
            });
      } catch (e) {
        Env.REPORT_RESPONSE_MSG = "파일 전송에 실패했습니다";
      }
    }
  }
}

class Poptext extends StatelessWidget {
  Poptext({Key? key}) : super(key: key);
  final ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return _initRowByData(
        "접수위치",
        SizedBox(
            width: Env.MEDIA_SIZE_WIDTH! / 2.3,
            child: GestureDetector(
              child: Text(controller.imageGPS.value.address.length > 1 ? controller.imageGPS.value.address : "위치를 찾을 수 없습니다.",
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400)),
              onTap: () {
                showPopover(
                  context: context,
                  bodyBuilder: (context) => ListItems(),
                  onPop: () => Log.debug('Popover was popped!'),
                  direction: PopoverDirection.bottom,
                  width: Env.MEDIA_SIZE_WIDTH! - 30,
                  height: 75,
                  arrowHeight: 15,
                  arrowWidth: 30,
                );
              },
            )));
  }
}

class ListItems extends StatelessWidget {
  ListItems({Key? key}) : super(key: key);
  final ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            InkWell(
                onTap: () {
                  Navigator.of(context)
                    ..pop()
                    ..push(
                      MaterialPageRoute<SecondRoute>(
                        builder: (context) => const SecondRoute(),
                      ),
                    );
                },
                child: Container(
                  height: 50,
                  color: Colors.amber[200],
                  child: Center(
                      child: Text(controller.imageGPS.value.address.length > 1 ? controller.imageGPS.value.address : "위치를 찾을 수 없습니다.",
                          overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontFamily: "NotoSansKR", fontWeight: FontWeight.w500))),
                )),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

Row _initRowByData(String text, Widget widget) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CustomText(
        text: text,
        weight: FontWeight.w700,
        size: 16,
        color: Colors.black,
      ),
      const SizedBox(
        width: 10,
      ),
      widget,
    ],
  );
}
