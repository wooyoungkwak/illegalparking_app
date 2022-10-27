import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';

class GuestMyPage extends StatefulWidget {
  const GuestMyPage({super.key});

  @override
  State<GuestMyPage> createState() => _GuestMyPageState();
}

class _GuestMyPageState extends State<GuestMyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _idController = TextEditingController();
  late TextEditingController _passController = TextEditingController();
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        leading: Material(
          color: AppColors.white,
          child: InkWell(
            onTap: () {
              loginController.offGuesMode();
              loginController.changePage(0);
              loginController.changeRealPage(0);
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
            },
            child: const Icon(
              Icons.chevron_left,
              color: AppColors.black,
              size: 40,
            ),
          ),
        ),
        title: createCustomText(
          weight: AppFontWeight.bold,
          color: AppColors.black,
          size: 16.0,
          text: "돌아가기",
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 150,
              ),
              // 로그인 Title
              // Geust Mode Title
              Row(
                children: [
                  createCustomText(
                    bottom: 0.0,
                    right: 0.0,
                    left: 8.0,
                    size: 21.0,
                    weight: AppFontWeight.bold,
                    text: " 로그인",
                  ),
                  createCustomText(
                    top: 12.0,
                    bottom: 0.0,
                    left: 0.0,
                    size: 21.0,
                    text: "이 필요한",
                  ),
                ],
              ),
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
                      controller: _idController,
                      fillColor: AppColors.textField,
                      hintText: "아이디 또는 이메일을 입력해주세요.",
                      validation: idValidator,
                    ),
                  ),
                  createTextFormField(
                    controller: _passController,
                    obscureText: true,
                    fillColor: AppColors.textField,
                    hintText: "비밀번호를 입력해주세요.",
                    validation: passwordValidator,
                  ),
                  Row(
                    children: [
                      // 자동 로그인
                      GetBuilder<LoginController>(
                        builder: (controller) => Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith((states) => const Color(0xffC6C6C6)),
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
                      // 아이디 저장
                      GetBuilder<LoginController>(
                        builder: (controller) => Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith((states) => const Color(0xffC6C6C6)),
                          shape: const CircleBorder(),
                          value: controller.idSaved,
                          onChanged: (bool? value) {
                            controller.setIdSaved(value ?? false);
                          },
                        ),
                      ),
                      createCustomText(
                        left: 0.0,
                        color: AppColors.black,
                        text: "아이디 저장",
                      ),
                    ],
                  ),

                  // 로그인 버튼
                  GetBuilder<LoginController>(
                    builder: (controller) => createElevatedButton(
                      color: AppColors.black,
                      text: "로그인",
                      function: () {
                        if (_formKey.currentState!.validate()) {
                          login(_idController.text, _passController.text).then(
                            (loginInfo) {
                              if (loginInfo.success) {
                                // 유저 정보 등록
                                Env.USER_NAME = loginInfo.getKrName();
                                Env.USER_SEQ = loginInfo.getUserSeq();
                                Env.USER_PHOTO_NAME = loginInfo.getPhotoName();
                                Env.USER_PHONE_NUMBER = loginInfo.getPhoneNumber();
                                controller.offGuesMode();
                                loginController.currentIndex(0);
                                loginController.currentPageIdex(0);
                                Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                              } else {
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
}
