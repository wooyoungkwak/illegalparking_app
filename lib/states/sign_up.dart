import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/sign_up_controller.dart';
import 'package:illegalparking_app/services/network_service.dart';
import 'package:illegalparking_app/services/server_service.dart';

import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ScrollController _termsSummaryController = ScrollController();
  final ScrollController _termsController = ScrollController();

  final idController = TextEditingController();
  final passController = TextEditingController();
  final nameCotroller = TextEditingController();
  final phoneNumController = TextEditingController();
  final authKeyController = TextEditingController();

  final controller = Get.put(SignUpController());

  late String photoName;
  FocusNode _idfocusNode = FocusNode();
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

  // TODO : 캐릭터 아이콘 디자인팀에 문의
  List profileCharicterList = [
    {
      "value": false,
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("회원가입"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              // ID, PW
              createTextFormField(
                labelText: "아이디",
                focusNode: _idfocusNode,
                hintText: "예시) example@teraenergy.co.kr",
                helperText: duplicatedId ? idHelperText : null,
                errorText: duplicatedId ? idErrorText : null,
                controller: idController,
                validation: idValidator,
                onChanged: idChanged,
              ),

              createTextFormField(
                labelText: "패스워드",
                helperText: "보안에 안전한 암호 입니다.",
                controller: passController,
                obscureText: true,
                validation: passwordValidator,
              ),
              createTextFormField(
                labelText: "패스워드 확인",
                obscureText: true,
                validation: passwordConfirmValidator,
              ),
              // 이름,전화번호,인증
              createTextFormField(
                labelText: "이름",
                controller: nameCotroller,
                validation: nameValidator,
              ),
              createTextFormField(
                labelText: "전화번호",
                controller: phoneNumController,
                validation: phoneNumValidator,
              ),
              if (!authVerification)
                createElevatedButton(
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
                  labelText: "인증번호",
                  controller: authKeyController,
                ),
              if (sendAuthentication || authVerification)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        disabledBackgroundColor: const Color(0xffd84315),
                        disabledForegroundColor: const Color(0xffffffff),
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
                      child: Text(authVerification ? "인증번호 확인됨" : "인증번호 확인"),
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
                            value: serviceTerms,
                            onChanged: (bool? value) {
                              setState(() {
                                serviceTerms = value!;
                                _formKey.currentState!.save();
                              });
                            },
                          ),
                          const Text("약관 동의"),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              showServiceTermsDialog();
                            },
                            child: const Text("더보기 >"),
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
                      text: "회원생성",
                      function: serviceTerms
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                // TODO : photoName 기능 추가
                                register(idController.text, passController.text, nameCotroller.text, phoneNumController.text, photoName).then((registerInfo) {
                                  if (registerInfo.success) {
                                    showSignUpSuccessDialog();
                                  } else {
                                    // TODO : 확인 해봐 ...
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
    );
  }

  showServiceTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("서비스 약관"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel_outlined))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
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
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("가입완료"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                },
                icon: const Icon(Icons.cancel_outlined))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: createCustomText(text: "안녕하세요 ${nameCotroller.text}님\n회원가입이 완료되었습니다."),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: createCustomText(text: idController.text),
                ),
              ),
              Row(
                children: [
                  GetBuilder<SignUpController>(
                    builder: (controller) => Checkbox(
                      value: controller.checkedAutoLogin,
                      onChanged: (bool? value) {
                        controller.getAutoLogin(value ?? false);
                      },
                    ),
                  ),
                  createCustomText(text: "자동로그인")
                ],
              ),
              createElevatedButton(
                text: "로그인하기",
                function: () {
                  Navigator.pop(context);
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
          setState(() {
            _initListReset();
            photoName = list[index]["asset"];
            list[index]["value"] = true;
          });
        },
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
              image: AssetImage(list[index]["asset"]),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(
              color: list[index]["value"] ? Colors.blue : Colors.transparent,
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
