import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        loginController.changeRealPage(2);
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: createCustomText(text: "내정보"),
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
        body: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircleAvatar(
                      radius: 60.0,
                      // 현재 기본 이미지들 적용 안됨
                      // backgroundImage: AssetImage("assets/noimage.jpg"),
                      // backgroundImage: AssetImage("assets/${Env.USER_PHOTO_NAME}.jpg"),
                      backgroundImage: _checkFileImage(imagePath),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 110,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Material(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Log.debug("사진첩 이동");
                            takePhoto(ImageSource.gallery);
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              createElevatedButton(
                  text: "프로필 변경",
                  function: () {
                    String modifyImagePath = _imageFile!.path.substring(50);
                    Log.debug("imagePath : $imagePath");
                    requestUserProfileChange(Env.USER_SEQ!, modifyImagePath).then((defaultInfo) {
                      if (defaultInfo.success) {
                        Log.debug(defaultInfo.data);
                        setState(() {
                          imagePath = modifyImagePath;
                        });
                        Env.USER_PHONE_NUMBER = imagePath;
                      } else {
                        Log.debug(defaultInfo.message);
                      }
                    });
                  }),
              createCustomText(text: Env.USER_NAME),
              createCustomText(text: Env.USER_PHONE_NUMBER),
              const SizedBox(
                height: 32,
              ),
              createElevatedButton(
                padding: 16.0,
                text: "비밀번호 변경",
                function: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        bool _oldPasswordValidation = false;
                        return StatefulBuilder(builder: (context, setState) {
                          return Scaffold(
                            appBar: AppBar(
                              automaticallyImplyLeading: false,
                              centerTitle: true,
                              title: const Text("소식"),
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _newPasswordController.text = "";
                                    },
                                    icon: const Icon(Icons.cancel_outlined))
                              ],
                            ),
                            body: Column(
                              children: [
                                createTextFormField(
                                  labelText: "기존 비밀번호",
                                  controller: _oldPasswordController,
                                ),
                                createElevatedButton(
                                    color: _oldPasswordValidation ? const Color(0xffd84315) : null,
                                    text: _oldPasswordValidation ? "비밀번호 확인됨" : "비밀번호 확인",
                                    function: () {
                                      requestUserPasswordCheck(Env.USER_SEQ!, _oldPasswordController.text).then((defaultInfo) {
                                        if (defaultInfo.success) {
                                          Log.debug(defaultInfo.data);
                                          setState(() {
                                            _oldPasswordValidation = true;
                                          });
                                        } else {
                                          Log.debug(defaultInfo.message);
                                          showToast(text: defaultInfo.message);
                                        }
                                      });
                                    }),
                                if (_oldPasswordValidation)
                                  createTextFormField(
                                    labelText: "변경할 비밀번호",
                                    controller: _newPasswordController,
                                  ),
                                if (_oldPasswordValidation)
                                  createTextFormField(
                                    labelText: "변경할 비밀번호 확인",
                                    controller: _newPasswordValidationController,
                                  ),
                                if (_oldPasswordValidation && (_newPasswordController.text == _newPasswordValidationController.text))
                                  createElevatedButton(
                                    padding: 24.0,
                                    text: "변경하기",
                                    function: () {
                                      Log.debug("_newPasswordController ${_newPasswordController.text}");
                                      requestUserPasswordChange(Env.USER_SEQ!, _newPasswordController.text).then((defaultInfo) {
                                        if (defaultInfo.success) {
                                          // 공통적으로 쓰는 다이얼로그면 하나 통합해서 만들기
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('알림'),
                                              content: createCustomText(text: "비밀번호가 변경되었습니다."),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, 'OK');
                                                    Navigator.popUntil(context, ModalRoute.withName('/infomation'));
                                                    // Navigator.pushNamed(context, '/infomation');
                                                  },
                                                  child: const Text('확인'),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          Log.debug(defaultInfo.message);
                                        }
                                      });
                                    },
                                  ),
                              ],
                            ),
                          );
                        });
                      });
                },
              ),
              createElevatedButton(
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
    Log.debug("photoName : $photoName");
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
    } else {
      return const AssetImage("assets/noimage.jpg");
    }
  }
}
