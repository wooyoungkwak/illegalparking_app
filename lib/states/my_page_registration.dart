import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';

import 'package:illegalparking_app/states/widgets/form.dart';

class MyPageRegistration extends StatefulWidget {
  const MyPageRegistration({super.key});

  @override
  State<MyPageRegistration> createState() => _MyPageRegistrationState();
}

class _MyPageRegistrationState extends State<MyPageRegistration> {
  final controller = Get.put(MyPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("내차등록"),
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
                  createTextFormField(hintText: "예) 123가4567, 서울 12가 3456"),
                  createElevatedButton(
                      text: "다음",
                      function: () {
                        Navigator.pop(context);
                        controller.getCertifiedVehicle();
                      })
                ],
              )),
        ));
  }
}
