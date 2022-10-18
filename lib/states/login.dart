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
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              child: Column(
                children: [
                  createTextFormField(labelText: "아이디", controller: _idController),
                  createTextFormField(labelText: "비밀번호", controller: _passController),
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
                  createElevatedButton(
                      text: "로그인",
                      function: () {
                        // Navigator.pushNamed(context, "/home");
                        // hong@gmail.com
                        // qwer1234
                        login(_idController.text, _passController.text).then((loginInfo) {
                          if (loginInfo.success) {
                            // 유저 정보 등록
                            Env.USER_NAME = loginInfo.getKrName();
                            Env.USER_SEQ = loginInfo.getUserSeq();
                            Env.USER_PHOTO_NAME = loginInfo.getPhotoName();
                            Env.USER_PHONE_NUMBER = loginInfo.getPhoneNumber();
                            Navigator.pushNamed(context, "/home");
                          } else {
                            // TODO : 확인 해바 ..
                            alertDialogByonebutton("알림", loginInfo.message!);
                          }
                        });
                      }),
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
}
