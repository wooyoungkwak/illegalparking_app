// ignore_for_file: unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/report_controller.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/services/such_loation_service.dart';
import 'package:illegalparking_app/states/car_report_camera_state.dart';
import 'package:illegalparking_app/states/home.dart';
import 'package:illegalparking_app/states/confirmation.state.dart';
import 'package:illegalparking_app/states/car_number_camera_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/states/widgets/crop.dart';
import 'package:illegalparking_app/states/widgets/custom_text.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:popover/popover.dart';

class Declaration extends StatefulWidget {
  const Declaration({super.key});

  @override
  State<Declaration> createState() => _DeclarationState();
}

class _DeclarationState extends State<Declaration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ReportController controller = Get.put(ReportController());
  final ScrollController _scrollController = ScrollController();
  final loginController = Get.put(LoginController());
  late TextEditingController _numberplateContoroller;
  int clickCount = 0; // 중복클릭 방지
  int testCount = 0; // Log용 카운트

  late FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    _numberplateContoroller = TextEditingController(text: controller.carNumber.isNotEmpty ? controller.carNumber.value : "");

    SchedulerBinding.instance.addPostFrameCallback((data) async {
      _fetchData(context);
    });
  }

  void _fetchData(BuildContext context) async {
    cameradispose();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createCustomText(color: AppColors.white, text: "로딩중..."),
                  const CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                ],
              ));
        });
    try {
      if (Env.CARNUMBER_CAMERA_RESHOOT_CHECK == false && Env.CAR_CAMERA_RESHOOT_CHECK == false) {
        await getGPS();
        await sendFileByAI(Env.SERVER_AI_FILE_UPLOAD_URL, controller.carnumberImage.value).then((carNum) {
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
        });
      } else if (Env.CARNUMBER_CAMERA_RESHOOT_CHECK == true && Env.CAR_CAMERA_RESHOOT_CHECK == false) {
        await sendFileByAI(Env.SERVER_AI_FILE_UPLOAD_URL, controller.carnumberImage.value).then((carNum) {
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
        });
      } else if (Env.CARNUMBER_CAMERA_RESHOOT_CHECK == false && Env.CAR_CAMERA_RESHOOT_CHECK == true) {
        await getGPS();
      } else {
        showSnackBar(context, "재촬영 체크 에러");
      }
      Get.back();
      Env.CAR_CAMERA_RESHOOT_CHECK = false;
      Env.CARNUMBER_CAMERA_RESHOOT_CHECK = false;
      Future.delayed(const Duration(milliseconds: 1000), () {});
    } catch (e) {
      Get.back();
      _numberplateContoroller = TextEditingController(text: "인식실패");
      // showSnackBar(context, "서버 에러 or 타임아웃");
    }

    // alertDialogByGetxonebutton("GPS", "longitude : ${controller.imageGPS.value.longitude}     latitude: ${controller.imageGPS.value.latitude}");
    setState(() {});
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
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark)); // IOS = Brightness.light의 경우 글자 검정, 배경 흰색
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: AppColors.white)); // android = Brightness.light 글자 흰색, 배경색은 컬러에 영향을 받음
    }

    final statusBarHeight = Env.MEDIA_SIZE_PADDINGTOP!;
    return GestureDetector(
      onTap: () => myFocusNode.unfocus(),
      child: _createWillPopScope(
        Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Scaffold(
            backgroundColor: AppColors.white,
            resizeToAvoidBottomInset: true,
            body: Form(
              key: _formKey,
              child: _createscrollView(Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    createContainerByTopWidget(text: "신고하기", function: backbtn),
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
                                  text: Env.MSG_REPORT_RULE,
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

  void backbtn() {
    alertDialogByGetxtobutton("신고를 취소하시겠습니까?", gotohome);
  }

  gotohome() {
    controller.initialize();
    Get.offAll(const Home());
    loginController.changePage(1);
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
        FocusManager.instance.primaryFocus?.unfocus();
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
          backbtn();
          return Future(() => false);
        },
        child: widget);
  }

  bool valuenullCheck() {
    final validSpecial = RegExp(r'^[0-9]{2,3}[가-힣]{1}[0-9]{4}$');

    if (Env.USER_SEQ == null || Env.USER_SEQ == "") {
      alertDialogByGetxonebutton("알림", Env.MSG_REPORT_NOT_USER);
      return false;
    } else if (controller.imageGPS.value.address == null || controller.imageGPS.value.address == "") {
      alertDialogByGetxonebutton("알림", Env.MSG_REPORT_NOT_ADDRESS);
      return false;
    } else if (_numberplateContoroller.text == "인식실패") {
      alertDialogByGetxonebutton("알림", Env.MSG_REPORT_NOT_CARNUMBER);
      return false;
    } else if (_numberplateContoroller.text == null || _numberplateContoroller.text == "") {
      alertDialogByGetxonebutton("알림", Env.MSG_REPORT_NOT_CARNUMBER);
      return false;
    } else if (_numberplateContoroller.text.length > 10) {
      alertDialogByGetxonebutton("알림", Env.MSG_REPORT_OVER_CARNUMBER);
      return false;
    } else if (controller.imageTime.value == null || controller.imageTime.value == "") {
      alertDialogByGetxonebutton("알림", Env.MSG_REPORT_NOT_CARIMG);
      return false;
    } else if (controller.reportfileName.value == null || controller.reportfileName.value == "" || File(controller.reportfileName.value).existsSync()) {
      alertDialogByGetxonebutton("알림", Env.MSG_REPORT_NOT_CARIMG);
      return false;
    } else if (controller.imageGPS.value.latitude == null || controller.imageGPS.value.longitude == null || controller.imageGPS.value.latitude == "" || controller.imageGPS.value.longitude == "") {
      alertDialogByGetxonebutton("알림", Env.MSG_REPORT_NOT_GPS);
      return false;
    } else if (validSpecial.hasMatch(_numberplateContoroller.text) == false) {
      alertDialogByGetxonebutton("알림", Env.MSG_REPORT_CHECK_CARNUMBER);
      return false;
    }
    return true;
  }

  void back() {
    Get.back();
  }

  void _reportcamerabtn() {
    Get.to(const Reportcamera());
    Env.CAR_CAMERA_RESHOOT_CHECK = true;
  }

  void _numbercamerabtn() {
    Get.to(const Numbercamera());
    Env.CARNUMBER_CAMERA_RESHOOT_CHECK = true;
  }

  void _reportbtn() async {
    if (valuenullCheck()) {
      if (clickCount == 0) {
        clickCount++;
        _endData(context);
      }
    }
  }

  void showRetryDialog(BuildContext context, {String? text}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('알림'),
        content: Text(text ?? ""),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              _endData(context);
            },
            child: const Text('확인'),
          ),
          TextButton(
            onPressed: () {
              clickCount--;
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  void _endData(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CustomText(
                    weight: AppFontWeight.bold,
                    text: Env.MSG_REPORT_ENDING_PROGRESSDIALOG,
                    color: Colors.black,
                    size: 22,
                  ),
                  CircularProgressIndicator(),
                  // SizedBox(
                  //   height: 50,
                  //   child: Lottie.asset(
                  //     'assets/loading.json',
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                  // SizedBox(width: 75, height: 75, child: Lottie.network('https://assets9.lottiefiles.com/packages/lf20_HmCBZ0IIXU.json', fit: BoxFit.fill)),
                  // Some text
                ],
              ),
            ),
          );
        });

    try {
      String text = _numberplateContoroller.text;
      text = text.replaceAll(' ', '');
      sendFileByReport(Env.SERVER_ADMIN_FILE_UPLOAD_URL, controller.reportImage.value).then((result) {
        if (result == false) {
          // Env.REPORT_RESPONSE_MSG = Env.MSG_REPORT_FILE_ERROR;
          alertDialogByGetxonebutton("신고알림", Env.MSG_REPORT_FILE_ERROR);
          clickCount--;
        } else {
          sendReport(Env.USER_SEQ!, controller.imageGPS.value.address, _numberplateContoroller.text, controller.imageTime.value, controller.reportfileName.value, controller.imageGPS.value.latitude,
                  controller.imageGPS.value.longitude)
              .then((reportInfo) {
            if (Env.isDebug) {
              //보내는 위도 경도 확인용
              Log.debug("longitude :${controller.imageGPS.value.longitude}");
              Log.debug("latitude : ${controller.imageGPS.value.latitude}");
              //중복 횟수 확인용
              testCount++;
              Log.debug("upload {$testCount}");
            }
            if (!reportInfo.success) {
              Env.REPORT_RESPONSE_MSG = reportInfo.message!;
              if (Env.REPORT_RESPONSE_MSG!.contains("초과했습니다.")) {
                // pd.close();
                // showRetryDialog(context, text: Env.MSG_REPORT_DIALOG_SELECT);
                // alertDialogByGetxonebutton("신고알림", Env.REPORT_RESPONSE_MSG!);
                Get.offAll(const Confirmation());
              } else {
                // pd.close();
                Get.offAll(const Confirmation());
              }
            } else {
              Env.REPORT_RESPONSE_MSG = reportInfo.data!;
              // pd.close();
              Get.offAll(const Confirmation());
            }
          });
        }
      });
    } catch (e) {
      // Env.REPORT_RESPONSE_MSG = Env.MSG_REPORT_FILE_ERROR;
      alertDialogByGetxonebutton("신고알림", "서버 오류입니다.");
      clickCount--;
    }
    Get.back();
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400, decoration: TextDecoration.underline, color: AppColors.blue)),
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
                  color: Colors.transparent,
                  child: Center(
                      child: Text(controller.imageGPS.value.address.length > 1 ? controller.imageGPS.value.address : "위치를 찾을 수 없습니다.",
                          overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontFamily: "NotoSansKR", fontWeight: FontWeight.w600))),
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
