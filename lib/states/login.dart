import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/models/storage_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SecureStorage secureStorage;

  late TextEditingController _idController = TextEditingController();
  late TextEditingController _passController = TextEditingController();
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    secureStorage = SecureStorage();
    _setsaveid();
    loginController.getAutoLogin(false);
    secureStorage.write(Env.KEY_AUTO_LOGIN, "false");

    if (!Env.isDebug) {
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
      backgroundColor: AppColors.appBackground,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 150,
              ),
              // 로그인 Title
              if (loginController.isGuestMode == false)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createCustomText(
                      family: "NotoSansKR",
                      weight: FontWeight.w900,
                      style: FontStyle.italic,
                      color: Colors.white,
                      padding: 0.0,
                      size: 36.0,
                      text: "주차의정석,",
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        createCustomText(
                          family: "NotoSansKR",
                          weight: FontWeight.w900,
                          style: FontStyle.italic,
                          color: Colors.white,
                          padding: 0.0,
                          size: 46.0,
                          text: "SOP",
                        ),
                        createCustomText(
                          family: "NotoSansKR",
                          style: FontStyle.italic,
                          color: const Color(0xff848484),
                          size: 21.0,
                          text: "(Standard of parking)",
                        ),
                      ],
                    )
                  ],
                ),
              // Geust Mode Title
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
              // 아이디 비밀번호 입력
              Column(
                children: [
                  Container(
                    child: createTextFormField(
                      hintText: "아이디 또는 이메일을 입력해주세요.",
                      fillColor: AppColors.textField,
                      controller: _idController,
                      validation: idValidator,
                    ),
                  ),
                  createTextFormField(
                    hintText: "비밀번호를 입력해주세요.",
                    obscureText: true,
                    fillColor: AppColors.textField,
                    controller: _passController,
                    validation: passwordValidator,
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
                            if (_idController.text != "" || _idController.text != null) {
                              controller.getAutoLogin(value ?? false);
                              secureStorage.write(Env.KEY_AUTO_LOGIN, value.toString());
                            }
                          },
                        ),
                      ),
                      createCustomText(
                        left: 0.0,
                        color: Colors.white,
                        text: "자동 로그인",
                      ),
                      // 아이디 저장
                      GetBuilder<LoginController>(
                        builder: (controller) => Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith((states) => const Color(0xff9B9B9B)),
                          shape: const CircleBorder(),
                          value: controller.idSaved,
                          onChanged: (bool? value) {
                            controller.setIdSaved(value ?? false);
                            secureStorage.write(Env.KEY_ID_CHECK, value.toString());
                          },
                        ),
                      ),
                      createCustomText(
                        left: 0.0,
                        color: Colors.white,
                        text: "아이디 저장",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
                                secureStorage.write(Env.LOGIN_ID, _idController.text);
                                secureStorage.write(Env.LOGIN_PW, _passController.text);
                                controller.offGuesMode();
                                loginController.currentIndex(0);
                                loginController.currentPageIdex(0);
                                Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                              } else {
                                // TODO : 확인 해바 ..
                                showErrorSnackBar(context, loginInfo.message!);
                              }
                            },
                          );
                        } else {
                          showErrorToast(text: "아이디 또는 비밀번호를 확인해 주세요.");
                        }
                      },
                    ),
                  ),
                ],
              ),

              GetBuilder<LoginController>(
                builder: (controller) => createElevatedButton(
                  color: Colors.white,
                  textColors: Colors.black,
                  text: "회원가입",
                  function: () {
                    controller.getAutoLogin(false);
                    Navigator.pushNamed(context, "/sign_up");
                  },
                ),
              ),

              if (!loginController.isGuestMode)
                const SizedBox(
                  height: 100,
                ),
              if (!loginController.isGuestMode)
                GetBuilder<LoginController>(
                  builder: (controller) => createElevatedButton(
                    color: Colors.grey[300],
                    textColors: Colors.black,
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

  Future<String> _setsaveid() async {
    late bool initcheck = true;

    if (initcheck) {
      String? chek = await secureStorage.read(Env.KEY_ID_CHECK);
      if (chek == null) {
        loginController.setIdSaved(false);
      } else if (chek == "false") {
        loginController.setIdSaved(false);
      } else if (chek == "true") {
        loginController.setIdSaved(true);
        String? sevedId = await secureStorage.read(Env.LOGIN_ID);
        if (sevedId != null) {
          setState(() {
            _idController = TextEditingController(text: sevedId);
          });
        }
      }
      initcheck = false;
    }
    return "...";
  }
}
