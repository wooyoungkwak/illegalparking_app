import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/setting_controller.dart';
import 'package:illegalparking_app/models/storage_model.dart';
import 'package:image_picker/image_picker.dart';

import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';

class MyPageInfomation extends StatefulWidget {
  const MyPageInfomation({super.key});

  @override
  State<MyPageInfomation> createState() => _MyPageInfomationState();
}

class _MyPageInfomationState extends State<MyPageInfomation> {
  final loginController = Get.put(LoginController());
  final settingController = Get.put(SettingController());

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordValidationController = TextEditingController();

  late SecureStorage secureStorage;

  final ImagePicker _picker = ImagePicker();
  late String imagePath = Env.USER_PHOTO_NAME!;
  late bool isExistImgae;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    secureStorage = SecureStorage();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark)); // IOS = Brightness.light의 경우 글자 검정, 배경 흰색
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: AppColors.white)); // android = Brightness.light 글자 흰색, 배경색은 컬러에 영향을 받음
    }
    return WillPopScope(
      onWillPop: () {
        loginController.changeRealPage(2);
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
          ),
          elevation: 0,
          backgroundColor: AppColors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Material(
            color: AppColors.white,
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
          title: createCustomText(
            weight: AppFontWeight.bold,
            size: 16,
            text: "내정보",
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 100.0,
                      backgroundImage: _checkFileImage(imagePath),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 150,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textGrey),
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.white,
                        ),
                        child: Material(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            borderRadius: BorderRadius.circular(30),
                            child: const Icon(Icons.filter, size: 30),
                            onTap: () {
                              takePhoto(ImageSource.gallery).then((imagePath) {
                                requestUserProfileChange(Env.USER_SEQ!, imagePath).then((defaultInfo) {
                                  if (defaultInfo.success) {
                                    setState(() {
                                      imagePath = imagePath;
                                    });
                                    Env.USER_PHOTO_NAME = imagePath;
                                  } else {
                                    Log.debug("Profile Error message : ${defaultInfo.message}");
                                  }
                                });
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    createCustomText(
                      bottom: 0.0,
                      weight: AppFontWeight.bold,
                      size: 24,
                      text: Env.USER_NAME,
                    ),
                    createCustomText(
                      top: 0.0,
                      weight: AppFontWeight.medium,
                      color: const Color(0xff5A5A5A),
                      size: 18,
                      text: Env.USER_PHONE_NUMBER,
                    ),
                  ],
                ),
                createElevatedButton(
                  width: 215.0,
                  color: AppColors.black,
                  text: "비밀번호 변경",
                  function: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          bool oldPasswordValidation = false;
                          return StatefulBuilder(builder: (context, setState) {
                            return Scaffold(
                              backgroundColor: AppColors.white,
                              appBar: AppBar(
                                elevation: 0,
                                backgroundColor: AppColors.white,
                                automaticallyImplyLeading: false,
                                centerTitle: true,
                                title: createCustomText(
                                  color: AppColors.black,
                                  weight: FontWeight.bold,
                                  size: 16.0,
                                  text: "비밀번호 변경",
                                ),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      _oldPasswordController.text = "";
                                      _newPasswordController.text = "";
                                      _newPasswordController.text = "";
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: AppColors.black,
                                    ),
                                  )
                                ],
                              ),
                              body: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: ListView(
                                  children: [
                                    createCustomText(
                                      top: 0.0,
                                      bottom: 0.0,
                                      left: 8.0,
                                      weight: AppFontWeight.bold,
                                      size: 14.0,
                                      text: "기존 비밀번호",
                                    ),
                                    createTextFormField(
                                        obscureText: settingController.hidepasswordMypage.value,
                                        fillColor: AppColors.textField,
                                        hintText: "기존 비밀번호를 입력해주세요.",
                                        controller: _oldPasswordController,
                                        validation: passwordValidator,
                                        passwordswich: true,
                                        function: () {
                                          settingController.hidepasswordMypagewrite(!settingController.hidepasswordMypage.value);
                                          setState(
                                            () {},
                                          );
                                        }),
                                    createElevatedButton(
                                        padding: 24.0,
                                        color: oldPasswordValidation ? AppColors.blue : AppColors.black,
                                        text: oldPasswordValidation ? "비밀번호 확인됨" : "비밀번호 확인",
                                        function: () {
                                          requestUserPasswordCheck(Env.USER_SEQ!, _oldPasswordController.text).then((defaultInfo) {
                                            if (defaultInfo.success) {
                                              setState(() {
                                                oldPasswordValidation = true;
                                              });
                                            } else {
                                              showErrorSnackBar(context, defaultInfo.message!);
                                            }
                                          });
                                        }),
                                    if (oldPasswordValidation)
                                      createCustomText(
                                        top: 0.0,
                                        bottom: 0.0,
                                        left: 8.0,
                                        weight: AppFontWeight.bold,
                                        size: 14.0,
                                        text: "변경할 비밀번호",
                                      ),
                                    if (oldPasswordValidation)
                                      createTextFormField(
                                          obscureText: settingController.hidepasswordMypage2.value,
                                          fillColor: AppColors.textField,
                                          hintText: "변경할 비밀번호를 입력해주세요.",
                                          controller: _newPasswordController,
                                          validation: passwordValidator,
                                          passwordswich: true,
                                          function: () {
                                            settingController.hidepasswordMypage2write(!settingController.hidepasswordMypage2.value);
                                            setState(
                                              () {},
                                            );
                                          }),
                                    if (oldPasswordValidation)
                                      createTextFormField(
                                          obscureText: settingController.hidepasswordMypage3.value,
                                          fillColor: AppColors.textField,
                                          hintText: "변경할 비밀번호를 입력해주세요.",
                                          controller: _newPasswordController,
                                          validation: passwordValidator,
                                          passwordswich: true,
                                          function: () {
                                            settingController.hidepasswordMypage3write(!settingController.hidepasswordMypage3.value);
                                            setState(
                                              () {},
                                            );
                                          }),
                                    if (oldPasswordValidation)
                                      createElevatedButton(
                                        padding: 24.0,
                                        color: AppColors.black,
                                        text: "변경하기",
                                        function: () {
                                          requestUserPasswordChange(Env.USER_SEQ!, _newPasswordController.text).then((defaultInfo) {
                                            if (defaultInfo.success) {
                                              showToast(text: "비밀번호가 변경되었습니다.");
                                              Navigator.pop(context);
                                              Get.back();
                                              loginController.changeRealPage(3);
                                              _oldPasswordController.text = "";
                                              _newPasswordController.text = "";
                                              _newPasswordController.text = "";
                                            } else {
                                              showErrorToast(text: "비밀번호 변경에 실패하였습니다.");
                                            }
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            );
                          });
                        });
                  },
                ),
                createElevatedButton(
                    width: 215,
                    color: AppColors.grey,
                    text: "로그아웃",
                    function: () {
                      Env.USER_SEQ = null;
                      Env.USER_NAME = null;
                      Env.USER_PHOTO_NAME = null;
                      Env.USER_PHONE_NUMBER = null;
                      if (!loginController.idSaved) {
                        secureStorage.write(Env.LOGIN_ID, "");
                      }
                      secureStorage.write(Env.LOGIN_PW, "");
                      secureStorage.write(Env.KEY_AUTO_LOGIN, "false");
                      loginController.changeRealPage(0);
                      loginController.changePage(0);
                      loginController.getAutoLogin(false);
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
      if (Platform.isAndroid) {
        imagePath = _imageFile!.path.substring(50);
      } else {
        imagePath = _imageFile!.path.substring(48);
      }
    });
    return imagePath;
  }

  ImageProvider<Object> _checkFileImage(String photoName) {
    String initPhotoName = "assets/profile_";
    String androidPhotoName = "/data/user/0/com.example.illegalparking_app/cache/";
    String iOSPhotoName = "/private/var/mobile/Containers/Data/Application/";
    String filePath;

    if (initPhotoName == photoName.substring(0, 15)) {
      return AssetImage(photoName);
    }

    if (Platform.isAndroid) {
      filePath = androidPhotoName + photoName;
    } else {
      filePath = iOSPhotoName + photoName;
    }

    if (File(filePath).existsSync()) {
      return FileImage(File(filePath));
    } else {
      return const AssetImage("assets/noimage.jpg");
    }
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

  String? passwordConfirmValidator(String? text) {
    if (text!.isEmpty) {
      return "비밀번호를 입력해 주세요";
    }

    if (_newPasswordController.text != text) {
      return "비밀번호가 맞지 않습니다.";
    }
    return null;
  }
}
