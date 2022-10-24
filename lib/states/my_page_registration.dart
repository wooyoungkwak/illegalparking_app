import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
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
      const DropdownMenuItem(value: "대형", child: Text("대형")),
      const DropdownMenuItem(value: "SUV", child: Text("SUV")),
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
        appBar: AppBar(
          title: const Text("내차등록"),
          centerTitle: false,
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
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              child: Wrap(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0, bottom: 8.0),
                    child: Text("차량 번호를 입력해 주세요"),
                  ),
                  createTextFormField(
                    hintText: "예) 123가4567, 서울 12가 3456",
                    controller: carNumController,
                    validation: _carNumValidator,
                  ),
                  createElevatedButton(
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
      ),
    );
  }

  _showRegisterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0, bottom: 8.0),
                        child: createCustomText(text: "차종을 입력해 주세요"),
                      ),
                      createTextFormField(hintText: "쏘나타", controller: carNameController, validation: _carNameValidator),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        child: DropdownButton(
                            isExpanded: true,
                            value: carGradeselected,
                            items: dropDownItems,
                            onChanged: (value) {
                              setState(() {
                                carGradeselected = value!;
                              });
                            }),
                      ),
                      createElevatedButton(
                          text: "완료",
                          function: () {
                            requestCarRegister(Env.USER_SEQ!, carNumController.text, carNameController.text, carGradeselected).then((defaultInfo) {
                              Log.debug("requestCarRegister result : ${defaultInfo.message}");
                              Get.back();
                              loginController.changeRealPage(3);
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
      return "차종을 입력해 주세요";
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
