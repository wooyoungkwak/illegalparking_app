import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

class MyPageInfomation extends StatefulWidget {
  const MyPageInfomation({super.key});

  @override
  State<MyPageInfomation> createState() => _MyPageInfomationState();
}

class _MyPageInfomationState extends State<MyPageInfomation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: createCustomText(text: "내정보"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage("assets/noimage.jpg"),
              ),
            ),
            createCustomText(text: "홍길동"),
            createCustomText(text: "010-1234-4568"),
            const SizedBox(
              height: 32,
            ),
            createElevatedButton(
              padding: 16.0,
              text: "비밀번호 변경",
              function: () {
                showCustomDialog(
                  context: context,
                  title: "비밀번호 변경",
                  widget: Column(
                    children: [
                      createTextFormField(
                        labelText: "기존 비밀번호",
                      ),
                      createElevatedButton(
                        padding: 24.0,
                        text: "비밀번호 확인",
                      ),
                      createTextFormField(
                        labelText: "변경할 비밀번호",
                      ),
                      createTextFormField(
                        labelText: "변경할 비밀번호 확인",
                      ),
                      createElevatedButton(
                        padding: 24.0,
                        text: "변경하기",
                        function: () {
                          // 공통적으로 쓰는 다이얼로그면 하나 통합해서 만들기
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('알림'),
                              content: createCustomText(text: "비밀번호가 변경되었습니다."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                    Navigator.popUntil(context, ModalRoute.withName('/infomation'));
                                    // Navigator.pushNamed(context, '/infomation');
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            createElevatedButton(
                padding: 16.0,
                text: "로그아웃",
                function: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }),
          ],
        ),
      ),
    );
  }
}
