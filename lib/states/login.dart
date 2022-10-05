import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/sign_up_controller.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final singUpController = Get.put(SignUpController());
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
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
                  createTextFormField(labelText: "아이디"),
                  createTextFormField(labelText: "비밀번호"),
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
                        Navigator.pushNamed(context, "/home");
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
