import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/states/my_page_car_infomation.dart';
import 'package:illegalparking_app/utils/log_util.dart';

import 'package:illegalparking_app/states/car_report_camera_state.dart';
import 'package:illegalparking_app/states/guest_camera.dart';
import 'package:illegalparking_app/states/guest_my_page.dart';
import 'package:illegalparking_app/states/my_page.dart';
import 'package:illegalparking_app/states/my_page_infomation.dart';
import 'package:illegalparking_app/states/my_page_point.dart';
import 'package:illegalparking_app/states/my_page_registration.dart';
import 'package:illegalparking_app/states/my_page_report.dart';
import 'package:illegalparking_app/states/webview.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();
  bool _isGuestMode = false;
  bool get isGuestMode => _isGuestMode;
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
    GuestMyPage(),
  ];

  Widget get currentPages => _isGuestMode ? _guestModeWidgetOption[currentIndex.value] : _widgetOption[currentPageIdex.value];

  void onGuesMode() {
    Log.debug("onGuesMode");
    _isGuestMode = true;
    update();
  }

  void offGuesMode() {
    Log.debug("offGuesMode");
    _isGuestMode = false;
    update();
  }

  void changePage(int _index) {
    currentIndex.value = _index;
    currentPageIdex.value = _index;
  }

  void changeRealPage(int index) {
    currentPageIdex.value = index;
  }
}
