import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/states/widgets/custom_text.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

class SignUpConsent extends StatefulWidget {
  const SignUpConsent({super.key});

  @override
  State<SignUpConsent> createState() => _SignUpConsentState();
}

class _SignUpConsentState extends State<SignUpConsent> {
  final ScrollController _termsSummaryController = ScrollController();
  final ScrollController _termsController = ScrollController();
  final ScrollController _termsSummaryPersonalInformationController = ScrollController();
  final ScrollController _termsPersonalInformationController = ScrollController();
  bool serviceTerms = false;
  bool serviceTermsPersonalInformation = false;

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
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.light)); // IOS = Brightness.light의 경우 글자 검정, 배경 흰색
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: AppColors.white)); // android = Brightness.light 글자 흰색, 배경색은 컬러에 영향을 받음
    }
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
          title: createCustomText(
            weight: AppFontWeight.bold,
            size: 16,
            text: "회원가입",
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 약관
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(text: "서비스이용 약관", size: 18, weight: AppFontWeight.bold, color: AppColors.black),
            ),
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _termsSummaryController,
                  child: ListView.builder(
                    itemCount: 1,
                    controller: _termsSummaryController,
                    itemBuilder: (BuildContext context, int index) {
                      return const Text(Env.USER_TERMS);
                    },
                  ),
                ),
              ),
            ),
            // 약관동의
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith((states) => AppColors.blue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    value: serviceTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        serviceTerms = value!;
                      });
                    },
                  ),
                  createCustomText(
                    padding: 0.0,
                    text: "약관 동의",
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      showServiceTermsDialog();
                    },
                    child: Row(children: [
                      createCustomText(
                        padding: 0.0,
                        text: "더보기",
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(text: "개인정보처리 방침", size: 18, weight: AppFontWeight.bold, color: AppColors.black),
            ),
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _termsSummaryPersonalInformationController,
                  child: ListView.builder(
                    itemCount: 1,
                    controller: _termsSummaryPersonalInformationController,
                    itemBuilder: (BuildContext context, int index) {
                      return const Text(Env.USER_TERMS_PERSONALINFORMATION);
                    },
                  ),
                ),
              ),
            ),
            // 약관동의
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith((states) => AppColors.blue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    value: serviceTermsPersonalInformation,
                    onChanged: (bool? value) {
                      setState(() {
                        serviceTermsPersonalInformation = value!;
                      });
                    },
                  ),
                  createCustomText(padding: 0.0, text: "약관 동의", color: AppColors.black),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      showServiceTermsPersonalInformationDialog();
                    },
                    child: Row(children: [
                      createCustomText(
                        padding: 0.0,
                        text: "더보기",
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            createElevatedButton(
              color: Colors.black,
              text: "동의",
              function: (serviceTerms == true && serviceTermsPersonalInformation == true)
                  ? () {
                      Navigator.pushNamed(context, "/sign_up");
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  showServiceTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: createCustomText(
            color: AppColors.black,
            weight: FontWeight.bold,
            size: 16.0,
            text: "서비스 약관",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.black,
                ))
          ],
        ),
        body: Container(
          color: AppColors.white,
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _termsController,
                  child: ListView.builder(
                    itemCount: 1,
                    controller: _termsController,
                    itemBuilder: (BuildContext context, int index) {
                      return const Text(Env.USER_TERMS);
                    },
                  ),
                ),
              ),
              createElevatedButton(
                color: AppColors.blue,
                text: "약관동의하기",
                function: () {
                  setState(() {
                    serviceTerms = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  showServiceTermsPersonalInformationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: createCustomText(
            color: AppColors.black,
            weight: FontWeight.bold,
            size: 16.0,
            text: "개인정보처리 방침",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.black,
                ))
          ],
        ),
        body: Container(
          color: AppColors.white,
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _termsPersonalInformationController,
                  child: ListView.builder(
                    itemCount: 1,
                    controller: _termsPersonalInformationController,
                    itemBuilder: (BuildContext context, int index) {
                      return const Text(Env.USER_TERMS_PERSONALINFORMATION);
                    },
                  ),
                ),
              ),
              createElevatedButton(
                color: AppColors.blue,
                text: "약관동의하기",
                function: () {
                  setState(() {
                    serviceTermsPersonalInformation = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
