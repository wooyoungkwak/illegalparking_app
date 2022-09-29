import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool _isAutoLogin = false;

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
                        Checkbox(
                          value: _isAutoLogin,
                          onChanged: (bool? value) {
                            setState(() {
                              _isAutoLogin = value!;
                            });
                          },
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
            createElevatedButton(
                text: "회원가입",
                function: () {
                  Navigator.pushNamed(context, "/sign_up");
                }),
            createElevatedButton(text: "GUEST 입장"),
          ],
        ),
      ),
    );
  }
}
