import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';
import 'package:illegalparking_app/services/server_service.dart';

import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/log_util.dart';

class MyPageRegistration extends StatefulWidget {
  const MyPageRegistration({super.key});

  @override
  State<MyPageRegistration> createState() => _MyPageRegistrationState();
}

class _MyPageRegistrationState extends State<MyPageRegistration> {
  final controller = Get.put(MyPageController());
  final loginController = Get.put(LoginController());
  final carNumController = TextEditingController();

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              elevation: 5,
              child: Wrap(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0, bottom: 8.0),
                    child: Text("차량 번호를 입력해 주세요"),
                  ),
                  createTextFormField(hintText: "예) 123가4567, 서울 12가 3456", controller: carNumController),
                  createElevatedButton(
                      text: "다음",
                      function: () {
                        requestCarRegister(Env.USER_SEQ!, "123가1234", "투산ix", "SUV").then((defaultInfo) {
                          Log.debug("requestCarRegister $defaultInfo");
                          if (defaultInfo.success) {
                            loginController.changeRealPage(2);
                          } else {
                            // TODO : 등록 실패 알림
                            Log.debug(" message : ${defaultInfo.message} ");
                          }
                        });
                      })
                ],
              )),
        ),
      ),
    );
  }
}
