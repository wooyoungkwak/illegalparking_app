import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
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

  late TextEditingController _oldPasswordController = TextEditingController();
  late TextEditingController _newPasswordController = TextEditingController();
  late TextEditingController _newPasswordValidationController = TextEditingController();
  // late PickedFile _imageFile;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late String imagePath = Env.USER_PHOTO_NAME!;
  late bool isExistImgae;
  @override
  void initState() {
    super.initState();
    Log.debug("USER_PHOTO_NAME : $imagePath");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        loginController.changeRealPage(2);
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
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
        body: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircleAvatar(
                      radius: 100.0,
                      // 현재 기본 이미지들 적용 안됨
                      // backgroundImage: AssetImage("assets/noimage.jpg"),
                      // backgroundImage: AssetImage("assets/${Env.USER_PHOTO_NAME}.jpg"),
                      backgroundImage: _checkFileImage(imagePath),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 190,
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
                          onTap: () {
                            takePhoto(ImageSource.gallery);
                          },
                          child: const Icon(
                            Icons.filter,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // createElevatedButton(
              //     text: "프로필 변경",
              //     function: () {
              //       String modifyImagePath = _imageFile!.path.substring(50);
              //       requestUserProfileChange(Env.USER_SEQ!, modifyImagePath).then((defaultInfo) {
              //         if (defaultInfo.success) {
              //           Log.debug(defaultInfo.data);
              //           setState(() {
              //             imagePath = modifyImagePath;
              //           });
              //           Env.USER_PHOTO_NAME = imagePath;
              //         } else {
              //           Log.debug(defaultInfo.message);
              //         }
              //       });
              //     }),
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
              const SizedBox(
                height: 50,
              ),
              createElevatedButton(
                padding: 16.0,
                width: 215.0,
                color: AppColors.black,
                text: "비밀번호 변경",
                function: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        bool _oldPasswordValidation = false;
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
                                    obscureText: true,
                                    fillColor: AppColors.textField,
                                    hintText: "기존 비밀번호를 입력해주세요.",
                                    controller: _oldPasswordController,
                                    validation: passwordValidator,
                                  ),
                                  createElevatedButton(
                                      padding: 24.0,
                                      color: _oldPasswordValidation ? AppColors.blue : AppColors.black,
                                      text: _oldPasswordValidation ? "비밀번호 확인됨" : "비밀번호 확인",
                                      function: () {
                                        requestUserPasswordCheck(Env.USER_SEQ!, _oldPasswordController.text).then((defaultInfo) {
                                          if (defaultInfo.success) {
                                            setState(() {
                                              _oldPasswordValidation = true;
                                            });
                                          } else {
                                            showErrorSnackBar(context, defaultInfo.message!);
                                          }
                                        });
                                      }),
                                  if (_oldPasswordValidation)
                                    createCustomText(
                                      top: 0.0,
                                      bottom: 0.0,
                                      left: 8.0,
                                      weight: AppFontWeight.bold,
                                      size: 14.0,
                                      text: "변경할 비밀번호",
                                    ),
                                  if (_oldPasswordValidation)
                                    createTextFormField(
                                      obscureText: true,
                                      fillColor: AppColors.textField,
                                      hintText: "변경할 비밀번호를 입력해주세요.",
                                      controller: _newPasswordController,
                                      validation: passwordValidator,
                                    ),
                                  if (_oldPasswordValidation)
                                    createTextFormField(
                                      obscureText: true,
                                      fillColor: AppColors.textField,
                                      hintText: "비밀번호 확인해주세요.",
                                      helperText: "보안이 안전된 암호입니다.",
                                      controller: _newPasswordValidationController,
                                      validation: passwordConfirmValidator,
                                    ),
                                  if (_oldPasswordValidation)
                                    createElevatedButton(
                                      padding: 24.0,
                                      color: AppColors.black,
                                      text: "변경하기",
                                      function: () {
                                        requestUserPasswordChange(Env.USER_SEQ!, _newPasswordController.text).then((defaultInfo) {
                                          if (defaultInfo.success) {
                                            Log.debug(defaultInfo.message);
                                            showToast(text: "비밀번호가 변경되었습니다.");
                                            Navigator.pop(context);
                                            Get.back();
                                            loginController.changeRealPage(3);
                                            _oldPasswordController.text = "";
                                            _newPasswordController.text = "";
                                            _newPasswordController.text = "";
                                          } else {
                                            Log.debug(defaultInfo.message);
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
                  padding: 16.0,
                  text: "로그아웃",
                  function: () {
                    Env.USER_SEQ = null;
                    Env.USER_NAME = null;
                    Env.USER_PHOTO_NAME = null;
                    Env.USER_PHONE_NUMBER = null;
                    loginController.changeRealPage(0);
                    loginController.changePage(0);
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
      imagePath = _imageFile!.path.substring(50);
    });
  }

  ImageProvider<Object> _checkFileImage(String photoName) {
    // 갤러리에서 저장된 이미지, 프로필 아이콘 구분
    bool isFilePath;
    if (photoName.length > 12 && "image_picker" == photoName.substring(0, 12)) {
      isFilePath = "image_picker" == photoName.substring(0, 12);
    } else {
      isFilePath = false;
    }

    // 갤러리에서 저장된 이미지, 프로필 아이콘 구분에 따른 화면 출력 이미지
    String filePath = "/data/user/0/com.example.illegalparking_app/cache/$photoName";
    bool isExist = File(filePath).existsSync();
    if (isFilePath && isExist) {
      return FileImage(File(filePath));
    } else if (photoName.substring(0, 6) == "assets") {
      return AssetImage(photoName);
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
