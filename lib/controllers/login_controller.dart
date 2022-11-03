import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/states/login.dart';
import 'package:illegalparking_app/states/my_page_car_infomation.dart';

import 'package:illegalparking_app/states/car_report_camera_state.dart';
import 'package:illegalparking_app/states/guest_camera.dart';
import 'package:illegalparking_app/states/my_page.dart';
import 'package:illegalparking_app/states/my_page_infomation.dart';
import 'package:illegalparking_app/states/my_page_point.dart';
import 'package:illegalparking_app/states/my_page_registration.dart';
import 'package:illegalparking_app/states/my_page_report.dart';
import 'package:illegalparking_app/states/webview.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  bool _isBottomOpen = false;
  bool get isBottomOpen => _isBottomOpen;

  bool _isGuestMode = false;
  bool get isGuestMode => _isGuestMode;

  bool _checkedAutoLogin = false; // 이 아이는 무조건 상태관리자로 관리해야된다.;;
  bool get checkedAutoLogin => _checkedAutoLogin;

  bool _idSaved = false; // 이 아이는 무조건 상태관리자로 관리해야된다.;;
  bool get idSaved => _idSaved;

  final currentIndex = 0.obs;
  final currentPageIdex = 0.obs;

  static const List<Widget> _widgetOption = <Widget>[
    WebviewPage(),
    Reportcamera(),
    MyPage(),
    MyPageInfomation(), // 내정보
    MyPageRegistration(), // 내차등록
    MyPageCarInfomatino(), // 내차정보
    MyPageReport(), //신고이력
    MyPagePoint(), //내포인트
  ];

  static const List<Widget> _guestModeWidgetOption = <Widget>[
    WebviewPage(),
    GuestCamera(),
    Login(),
  ];

  Widget get currentPages => _isGuestMode ? _guestModeWidgetOption[currentIndex.value] : _widgetOption[currentPageIdex.value];

  void getAutoLogin(bool value) {
    _checkedAutoLogin = value;
    update();
  }

  void setIdSaved(bool value) {
    _idSaved = value;
    update();
  }

  void onGuesMode() {
    _isGuestMode = true;
    update();
  }

  void offGuesMode() {
    _isGuestMode = false;
    update();
  }

  void onBottomNav() {
    _isBottomOpen = true;
    update();
  }

  void offBottomNav() {
    _isBottomOpen = false;
    update();
  }

  void changePage(int index) {
    currentIndex.value = index;
    currentPageIdex.value = index;
    if (_isBottomOpen) {
      Get.back();
      offBottomNav();
    }
  }

  void changeRealPage(int index) {
    currentPageIdex.value = index;
  }
}
