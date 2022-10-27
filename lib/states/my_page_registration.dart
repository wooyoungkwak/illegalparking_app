import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';
import 'package:illegalparking_app/services/server_service.dart';

import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';

class MyPageRegistration extends StatefulWidget {
  const MyPageRegistration({super.key});

  @override
  State<MyPageRegistration> createState() => _MyPageRegistrationState();
}

class _MyPageRegistrationState extends State<MyPageRegistration> {
  final myPageController = Get.put(MyPageController());
  final loginController = Get.put(LoginController());
  final carNumController = TextEditingController();
  final carNameController = TextEditingController();
  final carGradeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String carGradeselected = "소형";

  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "소형", child: Text("소형")),
      const DropdownMenuItem(value: "중형", child: Text("중형")),
      const DropdownMenuItem(value: "SuV", child: Text("SUV")),
      const DropdownMenuItem(value: "트럭", child: Text("트럭")),
      const DropdownMenuItem(value: "중장비", child: Text("중장비")),
    ];
    return menuItems;
  }

  bool _formChanged = false;
  String carName = "";

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
            text: "내차등록",
          ),
        ),
        body: Wrap(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 228,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          createCustomText(
                            top: 16.0,
                            left: 16.0,
                            right: 0,
                            bottom: 0,
                            color: AppColors.blue,
                            weight: AppFontWeight.bold,
                            size: 16.0,
                            text: "차량 번호",
                          ),
                          createCustomText(
                            top: 16.0,
                            left: 0,
                            right: 16.0,
                            bottom: 0,
                            weight: AppFontWeight.bold,
                            size: 16.0,
                            text: "를 입력해 주세요",
                          ),
                        ],
                      ),
                      createTextFormField(
                        controller: carNumController,
                        fillColor: AppColors.textField,
                        hintText: "예) 123가4567, 65호4321",
                        validation: _carNumValidator,
                      ),
                      createElevatedButton(
                        color: AppColors.black,
                        text: "다음",
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            _showRegisterDialog();
                          } else {
                            showErrorToast(text: "차량 번호를 확인해 주세요.");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showRegisterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              backgroundColor: AppColors.appBackground,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: AppColors.appBackground,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: createCustomText(
                  color: AppColors.white,
                  weight: FontWeight.bold,
                  size: 16.0,
                  text: "내차등록",
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        carNameController.text = "";
                        carGradeselected = "소형";
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.white,
                      ))
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          createCustomText(
                            top: 16.0,
                            left: 16.0,
                            right: 0,
                            bottom: 0,
                            color: AppColors.blue,
                            weight: AppFontWeight.bold,
                            size: 16.0,
                            text: "차량 모델",
                          ),
                          createCustomText(
                            top: 16.0,
                            left: 0,
                            right: 16.0,
                            bottom: 0,
                            weight: AppFontWeight.bold,
                            size: 16.0,
                            text: "를 입력해주세요",
                          ),
                        ],
                      ),
                      createTextFormField(
                        fillColor: AppColors.textField,
                        controller: carNameController,
                        hintText: "쏘나타",
                        validation: _carNameValidator,
                      ),
                      Row(
                        children: [
                          createCustomText(
                            top: 16.0,
                            left: 16.0,
                            right: 0,
                            bottom: 0,
                            color: AppColors.blue,
                            weight: AppFontWeight.bold,
                            size: 16.0,
                            text: "차량 분류",
                          ),
                          createCustomText(
                            top: 16.0,
                            left: 0,
                            right: 16.0,
                            bottom: 0,
                            weight: AppFontWeight.bold,
                            size: 16.0,
                            text: "를 선택해주세요.",
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(4.0),
                        color: AppColors.textField,
                        width: double.infinity,
                        child: DropdownButton(
                            items: dropDownItems,
                            isExpanded: true,
                            value: carGradeselected,
                            style: const TextStyle(fontSize: 14.0, color: AppColors.black),
                            onChanged: (value) {
                              setState(() {
                                carGradeselected = value!;
                              });
                            }),
                      ),
                      createElevatedButton(
                          color: AppColors.black,
                          text: "완료",
                          function: () {
                            requestCarRegister(Env.USER_SEQ!, carNumController.text, carNameController.text, carGradeselected).then((defaultInfo) {
                              if (defaultInfo.success) {
                                Get.back();
                                loginController.changeRealPage(3);
                                showToast(text: "차량 등록이 완료되었습니다.");
                                carNumController.text = "";
                                carNameController.text = "";
                                carGradeselected = "소형";
                              } else {
                                showErrorToast(text: "등록하신 차량 정보를 확인해주세요.");
                              }
                            });
                          }),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  String? _carNameValidator(String? text) {
    final validSpecial = RegExp(r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|a-z|A-Z|0-9]+$'); // 한글, 영어, 숫자만
    if (text!.isEmpty) {
      return "차량 모델을 입력해 주세요";
    }

    if (!validSpecial.hasMatch(text)) {
      return "특수문자는 사용 불가능 합니다.";
    }
    return null;
  }

  String? _carNumValidator(String? text) {
    final validCarNum = RegExp(r'^\d{2,3}[가-힣]{1}\d{4}$'); // 숫자 2-3자리, 한글 1자, 숫자 4자리
    if (text!.isEmpty) {
      return "차량 번호를 입력해 주세요";
    }

    if (!validCarNum.hasMatch(text)) {
      return "차량 번호를 확인해 주세요.";
    }
    return null;
  }
}
