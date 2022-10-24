import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/sign_up_controller.dart';
import 'package:illegalparking_app/models/result_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _idFocusNode = FocusNode();

  late TextEditingController _idController = TextEditingController();
  late TextEditingController _passController = TextEditingController();
  final singUpController = Get.put(SignUpController());
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    if (Env.isDebug) {
      _idController = TextEditingController(text: "hong@gmail.com");
      _passController = TextEditingController(text: "qwer1234");
    } else {
      _idController = TextEditingController(text: "");
      _passController = TextEditingController(text: "");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (loginController.isGuestMode == true)
              Row(
                children: [
                  createCustomText(
                    bottom: 0.0,
                    right: 0.0,
                    left: 8.0,
                    size: 24.0,
                    color: Colors.blue,
                    text: " 로그인",
                  ),
                  createCustomText(
                    top: 12.0,
                    bottom: 0.0,
                    left: 0.0,
                    size: 16.0,
                    text: "이 필요한",
                  ),
                ],
              ),
            if (loginController.isGuestMode == true)
              createCustomText(
                top: 0.0,
                left: 8.0,
                size: 16.0,
                text: "  서비스입니다.",
              ),
            Card(
              elevation: 5,
              child: Column(
                children: [
                  // 아이디
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextFormField(
                  //     controller: _idController,
                  //     // obscureText: true,
                  //     decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: "아이디",
                  //       hintText: "예) example@example.com",
                  //     ),
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     validator: (text) {
                  //       if (text!.isEmpty) {
                  //         return "아이디를 입력해 주세요";
                  //       }

                  //       if (text.length < 2) {
                  //         return "필수 입력 사항입니다.";
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  createTextFormField(
                    labelText: "아이디",
                    controller: _idController,
                    validation: idValidator,
                    focusNode: _idFocusNode,
                  ),
                  createTextFormField(labelText: "비밀번호", controller: _passController, validation: passwordValidator),
                  // 자동 로그인
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        GetBuilder<SignUpController>(
                          builder: (controller) => Checkbox(
                            value: controller.checkedAutoLogin,
                            onChanged: (bool? value) {
                              controller.getAutoLogin(value ?? false);
                            },
                          ),
                        ),
                        const Text("자동 로그인")
                      ],
                    ),
                  ),
                  // 로그인 버튼
                  GetBuilder<LoginController>(
                    builder: (controller) => createElevatedButton(
                      text: "로그인",
                      function: () {
                        // Navigator.pushNamed(context, "/home");
                        // hong@gmail.com
                        // qwer1234
                        if (_formKey.currentState!.validate()) {
                          login(_idController.text, _passController.text).then(
                            (loginInfo) {
                              if (loginInfo.success) {
                                // 유저 정보 등록
                                Env.USER_NAME = loginInfo.getKrName();
                                Env.USER_SEQ = loginInfo.getUserSeq();
                                Env.USER_PHOTO_NAME = loginInfo.getPhotoName();
                                Env.USER_PHONE_NUMBER = loginInfo.getPhoneNumber();
                                controller.offGuesMode();
                                loginController.currentIndex(0);
                                loginController.currentPageIdex(0);
                                Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                              } else {
                                // TODO : 확인 해바 ..
                                alertDialogByonebutton("알림", loginInfo.message!);
                              }
                            },
                          );
                        } else {
                          showToast(
                            text: "아이디 또는 비밀번호를 확인해 주세요.",
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            GetBuilder<SignUpController>(
              builder: (controller) => createElevatedButton(
                text: "회원가입",
                function: () {
                  controller.getAutoLogin(false);
                  Navigator.pushNamed(context, "/sign_up");
                },
              ),
            ),
            if (loginController.isGuestMode == false)
              GetBuilder<LoginController>(
                builder: (controller) => createElevatedButton(
                  text: "GUEST 입장",
                  function: () {
                    controller.onGuesMode();
                    Navigator.pushNamed(context, "/home");
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  String? idValidator(String? text) {
    final validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (text!.isEmpty) {
      return "아이디를 입력해 주세요";
    }

    if (!validEmail.hasMatch(text)) {
      return "아이디를 확인해 주세요.";
    }
    return null;
  }

  String? passwordValidator(String? text) {
    final validSpecial = RegExp(r'^[a-zA-Z0-9]{8,}$'); // 영어만

    if (text!.isEmpty) {
      return "비밀번호를 입력해 주세요";
    }

    if (!validSpecial.hasMatch(text)) {
      return "영문, 숫자 포함 8자 이상 가능합니다. ";
    }

    return null;
  }
}
