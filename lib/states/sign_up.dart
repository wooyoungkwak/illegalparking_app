import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/services/network_service.dart';
import 'package:illegalparking_app/services/server_service.dart';

import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ScrollController _termsSummaryController = ScrollController();
  final ScrollController _termsController = ScrollController();

  final FocusNode _idfocusNode = FocusNode();

  final idController = TextEditingController();
  final passController = TextEditingController();
  final nameCotroller = TextEditingController();
  final phoneNumController = TextEditingController();
  final authKeyController = TextEditingController();

  String photoName = "assets/profile_1.jpg";
  String? idHelperText = "사용 가능한 아이디입니다.";
  String? idErrorText = "사용 가능한 아이디입니다.";
  String authenticationSendText = "인증번호 발송";
  int limitTime = 180;
  bool serviceTerms = false;
  bool sendAuthentication = false;
  bool authVerification = false;
  bool duplicatedId = false;
  Timer? timer;
  int? authNum;

  List profileCharicterList = [
    {
      "value": true,
      "asset": "assets/profile_1.jpg",
    },
    {
      "value": false,
      "asset": "assets/profile_2.jpg",
    },
    {
      "value": false,
      "asset": "assets/profile_3.jpg",
    },
    {
      "value": false,
      "asset": "assets/profile_4.jpg",
    },
    {
      "value": false,
      "asset": "assets/profile_5.jpg",
    },
  ];

  void getSetTime() {
    secToTime(limitTime);
    limitTime -= 1;
  }

  void secToTime(int sec) {
    int minute = (sec % 3600) ~/ 60;
    int second = (sec % 3600) % 60;

    if (second < 10) {
      setState(() {
        authenticationSendText = "인증번호 발송됨 $minute : 0$second";
      });
    } else {
      setState(() {
        authenticationSendText = "인증번호 발송됨 $minute : $second";
      });
    }
    if (limitTime != 0) {
      timer = Timer(const Duration(seconds: 1), () {
        getSetTime();
      });
    } else if (limitTime <= 0) {
      setState(() {
        authNum = null;
        sendAuthentication = false;
        authenticationSendText = "인증번호 발송";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _idfocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    nameCotroller.dispose();
    phoneNumController.dispose();
    authKeyController.dispose();
    if (timer != null) {
      timer!.cancel();
    }
    _idfocusNode.removeListener(_onFocusChange);
    _idfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          title: createCustomText(text: "회원가입"),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  // 아이디
                  createCustomText(
                    top: 0.0,
                    bottom: 0.0,
                    left: 8.0,
                    size: 12.0,
                    text: "아이디(이메일)",
                  ),
                  createTextFormField(
                    focusNode: _idfocusNode,
                    fillColor: AppColors.textField,
                    hintText: "아이디 또는 이메일을 입력해주세요.",
                    helperText: duplicatedId ? idHelperText : null,
                    errorText: duplicatedId ? idErrorText : null,
                    controller: idController,
                    validation: idValidator,
                    onChanged: idChanged,
                  ),
                  // 비밀번호
                  createCustomText(
                    top: 0.0,
                    bottom: 0.0,
                    left: 8.0,
                    size: 12.0,
                    text: "비밀번호",
                  ),
                  createTextFormField(
                    controller: passController,
                    obscureText: true,
                    fillColor: AppColors.textField,
                    hintText: "비밀번호를 입력해주세요.",
                    helperText: "보안에 안전한 암호 입니다.",
                    validation: passwordValidator,
                  ),
                  createTextFormField(
                    fillColor: AppColors.textField,
                    obscureText: true,
                    hintText: "비밀번호를 한번 더 입력해주세요.",
                    validation: passwordConfirmValidator,
                  ),
                  // 이름
                  createCustomText(
                    top: 0.0,
                    bottom: 0.0,
                    left: 8.0,
                    size: 12.0,
                    text: "이름",
                  ),
                  createTextFormField(
                    fillColor: AppColors.textField,
                    controller: nameCotroller,
                    hintText: "이름을 입력해주세요.",
                    validation: nameValidator,
                  ),

                  //전화번호
                  createCustomText(
                    top: 0.0,
                    bottom: 0.0,
                    left: 8.0,
                    size: 12.0,
                    text: "전화번호",
                  ),
                  createTextFormField(
                    fillColor: AppColors.textField,
                    hintText: "전화번호를 입력해주세요.",
                    // helperText: "'-' 없이 입력해주세요",
                    readOnly: sendAuthentication || authVerification,
                    controller: phoneNumController,
                    validation: phoneNumValidator,
                  ),

                  // 인증 관련
                  if (!authVerification)
                    createElevatedButton(
                        color: Colors.black,
                        text: authenticationSendText,
                        function: sendAuthentication
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  sendSMS(phoneNumController.text).then((authKey) {
                                    setState(() {
                                      sendAuthentication = true;
                                      authNum = authKey;
                                    });
                                    getSetTime();
                                  });
                                } else {
                                  showErrorToast(text: "입력사항을 확인해 주세요.");
                                }
                              }),
                  if (sendAuthentication)
                    createTextFormField(
                      fillColor: AppColors.textField,
                      controller: authKeyController,
                      hintText: "인증번호를 입력해주세요.",
                    ),
                  if (sendAuthentication || authVerification)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.black,
                            disabledBackgroundColor: AppColors.blue,
                            disabledForegroundColor: AppColors.white,
                          ),
                          onPressed: authVerification
                              ? null
                              : () {
                                  try {
                                    if (int.parse(authKeyController.text) == authNum && authNum != null) {
                                      timer!.cancel();
                                      setState(() {
                                        authVerification = true;
                                        sendAuthentication = false;
                                      });
                                    } else {
                                      showErrorToast(text: "인증번호를 확인해 주세요.");
                                    }
                                  } catch (e) {
                                    showErrorToast(text: "인증번호를 확인해 주세요.");
                                  }
                                },
                          child: createCustomText(color: Colors.white, text: authVerification ? "인증번호 확인됨" : "인증번호 확인"),
                        ),
                      ),
                    ),
                  if (authVerification)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 약관
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
                                    _formKey.currentState!.save();
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
                        // 프로필 캐릭터 선택
                        createCustomText(
                          text: "프로필 캐릭터 선택",
                          weight: FontWeight.w400,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            profileCharicterList.length,
                            (index) => _createProfileCircleAvatar(
                              list: profileCharicterList,
                              index: index,
                            ),
                          ),
                        ),
                        // 회원생성
                        createElevatedButton(
                          color: Colors.black,
                          text: "회원생성",
                          function: serviceTerms
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    register(idController.text, passController.text, nameCotroller.text, phoneNumController.text, photoName).then((registerInfo) {
                                      if (registerInfo.success) {
                                        showSignUpSuccessDialog();
                                      } else {
                                        showErrorSnackBar(context, registerInfo.message!);
                                      }
                                    });
                                  } else {
                                    showErrorToast(text: "입력 사항을 확인해주세요");
                                  }
                                }
                              : null,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
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

  showSignUpSuccessDialog() {
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
            text: "가입완료",
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.black,
              ),
            )
          ],
        ),
        body: Container(
          color: AppColors.white,
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 가입인사
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        createCustomText(
                          padding: 0.0,
                          size: 20.0,
                          weight: FontWeight.w700,
                          text: "안녕하세요 ",
                        ),
                        createCustomText(
                          padding: 0.0,
                          size: 20.0,
                          weight: FontWeight.bold,
                          color: AppColors.blue,
                          text: nameCotroller.text,
                        ),
                        createCustomText(
                          padding: 0.0,
                          size: 20.0,
                          weight: FontWeight.w700,
                          text: " 님",
                        ),
                      ],
                    ),
                    createCustomText(
                      padding: 0.0,
                      size: 20.0,
                      weight: FontWeight.w700,
                      text: "회원가입이 완료되었습니다.",
                    ),
                  ],
                ),
              ),

              // 아이디
              createCustomText(
                padding: 8.0,
                size: 24.0,
                weight: FontWeight.w700,
                text: idController.text,
              ),
              Row(
                children: [
                  // 자동 로그인
                  GetBuilder<LoginController>(
                    builder: (controller) => Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith((states) => const Color(0xff9B9B9B)),
                      shape: const CircleBorder(),
                      value: controller.checkedAutoLogin,
                      onChanged: (bool? value) {
                        controller.getAutoLogin(value ?? false);
                      },
                    ),
                  ),
                  createCustomText(
                    left: 0.0,
                    color: AppColors.black,
                    text: "자동 로그인",
                  ),
                ],
              ),
              createElevatedButton(
                color: AppColors.black,
                text: "로그인하기",
                function: () {
                  Navigator.pop(context);
                  Get.delete<LoginController>();
                  Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // String To num 나중에 Util에 추가
  int stringToNum(String value) {
    return int.parse(value);
  }

  Padding _createProfileCircleAvatar({required List list, required int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Log.debug("size : ${Env.MEDIA_SIZE_WIDTH! / 8}");
          setState(() {
            _initListReset();
            photoName = list[index]["asset"];
            list[index]["value"] = true;
          });
        },
        child: Container(
          width: Env.MEDIA_SIZE_WIDTH! / 8,
          height: Env.MEDIA_SIZE_WIDTH! / 8,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
              image: AssetImage(list[index]["asset"]),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(
              color: list[index]["value"] ? AppColors.blue : Colors.transparent,
              width: 4.0,
            ),
          ),
        ),
      ),
    );
  }

  void _initListReset() {
    for (var el in profileCharicterList) {
      el["value"] = false;
    }
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
    final validSpecial = RegExp(r'^[a-zA-Z0-9 ]+$'); // 영어만

    if (text!.isEmpty) {
      return "비밀번호를 입력해 주세요";
    }

    if (text.length < 8) {
      return "영문, 숫자 포함 8자 이상 가능합니다.";
    }

    if (!validSpecial.hasMatch(text)) {
      return "영문, 숫자 포함 8자 이상 가능합니다. ";
    }

    return null;
  }

  String? passwordConfirmValidator(String? text) {
    if (text!.isEmpty) {
      return "비밀번호를 입력해 주세요";
    }

    if (passController.text != text) {
      return "비밀번호가 맞지 않습니다.";
    }
    return null;
  }

  String? nameValidator(String? text) {
    // final validSpecial = RegExp(r'^[a-zA-Z0-9 ]+$'); // 영어 및 숫자
    final validHangle = RegExp(r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]{2,6}$');

    if (text!.isEmpty) {
      return "이름을 입력해 주세요";
    }

    if (!validHangle.hasMatch(text)) {
      return "이름은 한글 2~6자 사이 입니다.";
    }
    return null;
  }

  String? phoneNumValidator(String? text) {
    // final validPhoneNum = RegExp(r'^010?([0-9]{4})([0-9]{4})$');
    final validPhoneNum = RegExp(r'^010?([0-9]{8})$');

    if (text!.isEmpty) {
      return "전화번호를 입력해 주세요";
    }

    if (!validPhoneNum.hasMatch(text)) {
      return "전화번호를 확인해 주세요.";
    }
    return null;
  }

  void idChanged(String text) {
    if (duplicatedId) {
      setState(() {
        duplicatedId = false;
      });
    }
  }

  void _onFocusChange() {
    if (!_idfocusNode.hasFocus) {
      Log.debug("중복확인");
      duplicate(idController.text).then((value) {
        Log.debug("duplicate : ${value.toString()}");

        if (value["data"]["isExist"]) {
          setState(() {
            duplicatedId = true;
            idHelperText = null;
            idErrorText = "중복된 아이디 입니다.";
          });
        } else {
          setState(() {
            duplicatedId = true;
            idHelperText = "사용 가능한 아이디입니다.";
            idErrorText = null;
          });
        }
      });
    }
  }
}
