import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/setting_controller.dart';
import 'package:illegalparking_app/models/storage_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/services/setting_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';

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
  final settingController = Get.put(SettingController());

  @override
  void initState() {
    super.initState();
    secureStorage = SecureStorage();

    _setSaveId();
    secureStorage.write(Env.KEY_AUTO_LOGIN, "false");

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
    mediasizeSetting(context);
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarBrightness: loginController.isGuestMode ? Brightness.light : Brightness.dark));
      // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark)); // IOS = Brightness.light??? ?????? ?????? ??????, ?????? ??????
      //????????? ??????????????? ?????? ????????? ??????..
      // statusBarColor??? IOS?????? ????????????
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarBrightness: loginController.isGuestMode ? Brightness.light : Brightness.dark,
          statusBarColor: loginController.isGuestMode ? AppColors.white : AppColors.white)); // android = Brightness.light ?????? ??????, ???????????? ????????? ????????? ??????
      //appbar??? ????????? ????????? ???????????? appbar ????????? ????????? ???????????? ?????? ??????,ios??? app??? ????????? ??? ??????
      //????????? ?????? ?????? ????????? ????????? bacgroundcolor??? ?????? ????????? ??????...
    }
    return Scaffold(
      backgroundColor: loginController.isGuestMode ? AppColors.white : AppColors.appBackground,
      appBar: loginController.isGuestMode ? _appbarIsGuest() : null,
      // appBar: loginController.isGuestMode
      //     ? _appbarIsGuest()
      //     : AppBar(
      //         systemOverlayStyle: SystemUiOverlayStyle.light,
      //         toolbarHeight: 0.0,
      //         backgroundColor: AppColors.black,
      //       ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                // ????????? Title
                if (!loginController.isGuestMode)
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
                        text: "???????????????,",
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
                if (loginController.isGuestMode)
                  Row(
                    children: [
                      createCustomText(
                        bottom: 0.0,
                        right: 0.0,
                        left: 8.0,
                        size: 21.0,
                        weight: AppFontWeight.bold,
                        text: " ?????????",
                      ),
                      createCustomText(
                        top: 12.0,
                        bottom: 0.0,
                        left: 0.0,
                        size: 21.0,
                        text: "??? ?????????",
                      ),
                    ],
                  ),
                if (loginController.isGuestMode)
                  createCustomText(
                    top: 0.0,
                    left: 8.0,
                    size: 16.0,
                    text: "  ??????????????????.",
                  ),
                // ????????? ???????????? ??????
                Column(
                  children: [
                    Container(
                      child: createTextFormField(
                        obscureText: false,
                        fillColor: AppColors.textField,
                        controller: _idController,
                        hintText: "????????? ?????? ???????????? ??????????????????.",
                        validation: idValidator,
                      ),
                    ),
                    createTextFormField(
                        obscureText: settingController.hidepasswordLogin.value,
                        fillColor: AppColors.textField,
                        controller: _passController,
                        hintText: "??????????????? ??????????????????.",
                        validation: passwordValidator,
                        passwordswich: true,
                        function: () {
                          settingController.hidepasswordLoginwrite(!settingController.hidepasswordLogin.value);
                          setState(
                            () {},
                          );
                        }),
                    Row(
                      children: [
                        // ?????? ?????????
                        GetBuilder<LoginController>(
                          builder: (controller) => Checkbox(
                            checkColor: Colors.white,
                            fillColor: loginController.isGuestMode
                                ? MaterialStateProperty.resolveWith((states) => const Color(0xffC6C6C6))
                                : MaterialStateProperty.resolveWith((states) => const Color(0xff9B9B9B)),
                            shape: const CircleBorder(),
                            value: controller.checkedAutoLogin,
                            onChanged: (bool? value) {
                              if (_idController.text != "" || _idController.text != null) {
                                Log.debug("auto login : ${controller.checkedAutoLogin}");
                                controller.getAutoLogin(value ?? false);
                                Log.debug("auto login : ${controller.checkedAutoLogin}");
                                secureStorage.write(Env.KEY_AUTO_LOGIN, value.toString());
                              }
                            },
                          ),
                        ),
                        createCustomText(
                          left: 0.0,
                          color: loginController.isGuestMode ? AppColors.black : AppColors.white,
                          text: "?????? ?????????",
                        ),
                        // ????????? ??????
                        GetBuilder<LoginController>(
                          builder: (controller) => Checkbox(
                            checkColor: Colors.white,
                            fillColor: loginController.isGuestMode
                                ? MaterialStateProperty.resolveWith((states) => const Color(0xffC6C6C6))
                                : MaterialStateProperty.resolveWith((states) => const Color(0xff9B9B9B)),
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
                          color: loginController.isGuestMode ? AppColors.black : AppColors.white,
                          text: "????????? ??????",
                        ),
                      ],
                    ),

                    // ????????? ??????
                    GetBuilder<LoginController>(
                      builder: (controller) => createElevatedButton(
                        color: loginController.isGuestMode ? AppColors.black : AppColors.blue,
                        text: "?????????",
                        function: () {
                          // Navigator.pushNamed(context, "/home");
                          // hong@gmail.com
                          // qwer1234
                          if (_formKey.currentState!.validate()) {
                            login(_idController.text, _passController.text).then(
                              (loginInfo) {
                                if (loginInfo.success) {
                                  // ?????? ?????? ??????
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
                                  showErrorSnackBar(context, loginInfo.message!);
                                }
                              },
                            );
                          } else {
                            showErrorToast(text: "????????? ?????? ??????????????? ????????? ?????????.");
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
                    text: "????????????",
                    function: () {
                      controller.getAutoLogin(false);
                      Navigator.pushNamed(context, "/sign_up_consent");
                    },
                  ),
                ),

                if (!loginController.isGuestMode)
                  const SizedBox(
                    height: 20,
                  ),
                if (!loginController.isGuestMode)
                  GetBuilder<LoginController>(
                    builder: (controller) => createElevatedButton(
                      color: Colors.grey[300],
                      textColors: Colors.black,
                      text: "GUEST ??????",
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
      ),
    );
  }

  String? idValidator(String? text) {
    final validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (text!.isEmpty) {
      return "???????????? ????????? ?????????";
    }

    if (!validEmail.hasMatch(text)) {
      return "???????????? ????????? ?????????.";
    }
    return null;
  }

  String? passwordValidator(String? text) {
    final validSpecial = RegExp(r'^[a-zA-Z0-9]{8,}$'); // ?????????

    if (text!.isEmpty) {
      return "??????????????? ????????? ?????????";
    }

    if (!validSpecial.hasMatch(text)) {
      return "??????, ?????? ?????? 8??? ?????? ???????????????. ";
    }

    return null;
  }

  Future<String> _setSaveId() async {
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

  AppBar _appbarIsGuest() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
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
            Get.delete<LoginController>();
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
        text: "????????????",
      ),
    );
  }
}
