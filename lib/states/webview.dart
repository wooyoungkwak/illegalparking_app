import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/map_controller.dart';
import 'package:illegalparking_app/services/ponecall_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/log_util.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../models/webview_model.dart';
import '../services/such_loation_service.dart';

import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  late WebViewController _webViewController;

  final mapController = Get.put(MapController());
  final loginController = Get.put(LoginController());

  Timer? timer;

  String oldDataType = "";
  String mapInfoType = "parking";
  String parkingName = "";
  String parkingAddress = "";
  String parkingPrice = "";
  String parkingOperation = "";
  String parkingCount = "";
  String parkingTime = "";
  String parkingPhoneNumber = "";
  String personalMobName = "";
  String personalMobPrice = "";
  String personalMobOper = "";
  String personalMobModel = "";
  double parkingLat = 0.0;
  double parkingLng = 0.0;

  @override
  void initState() {
    super.initState();
    // 처음 한번
    Timer(const Duration(seconds: 1), () => _sendGPS());
    // 7초 간격 위치 전송
    timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      _sendGPS();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
    _webViewController.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: Platform.isAndroid ? EdgeInsets.only(top: statusBarHeight) : EdgeInsets.only(top: statusBarHeight, bottom: 20),
      child: Column(
        children: [
          Expanded(
            child: WebView(
              initialUrl: "${Env.SERVER_ADMIN_URL}/api/area/map",
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
                _webViewController = webViewController;
              },
              onProgress: (int progress) {
                Log.debug("Webview is loading (progress : $progress%");
              },
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: _createJavascriptChannels(context),
            ),
          ),
        ],
      ),
    );
  }

  void showBottomDialog() {
    loginController.onBottomNav();
    showBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: buildBottomSheet,
    ).closed.whenComplete(() {
      loginController.offBottomNav();
      // _webViewController.runJavascript("appToEvent('bottomSheet', 1234)");
      if (oldDataType != mapController.resivedDatatype) {
        _webViewController.runJavascript("appToEvent('bottomSheet', 1234)").then((value) {
          setState(() {
            oldDataType = mapController.resivedDatatype;
          });
        });
      }
    });
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bottomNavBackground,
        border: Border(
          top: BorderSide(width: 1),
          left: BorderSide(width: 1),
          right: BorderSide(width: 1),
          bottom: BorderSide(width: 1),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      width: double.infinity,
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              children: [
                // Top bar
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 60,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),

                // Info Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        // 사진
                        child: Image(
                          height: 100,
                          width: 100,
                          image: mapInfoType == "parking" ? const AssetImage("assets/parking_basic.png") : const AssetImage("assets/pm_basic.png"),
                        ),
                      ),
                      if (mapInfoType == "parking") _createInfoHeader(title: parkingName, subtitle: parkingAddress),
                      if (mapInfoType == "pm") _createInfoHeader(title: personalMobName, subtitle: personalMobModel),
                    ],
                  ),
                ),

                // Info Main

                if (mapInfoType == "parking")
                  _createInfoMain(
                    titles: ["주차요금", "운영시간", "주차가능면"],
                    contents: [parkingOperation, parkingTime, parkingCount],
                    button1: createButtonWithIcon(
                      width: Env.LAYOUT_MAX_WIDTH! * 0.4,
                      icon: Icons.call,
                      color: AppColors.grey,
                      textColors: AppColors.black,
                      text: "전화하기",
                      function: () {
                        makePhoneCall(parkingPhoneNumber);
                      },
                    ),
                    button2: createButtonWithIcon(
                      width: Env.LAYOUT_MAX_WIDTH! * 0.4,
                      icon: Icons.shortcut,
                      color: AppColors.blue,
                      textColors: AppColors.white,
                      text: "길안내",
                      function: _requsetMapSearch,
                    ),
                  ),
                if (mapInfoType == "pm")
                  _createInfoMain(
                    titles: ["대여료", "운영시간"],
                    contents: [personalMobPrice, personalMobOper],
                    button1: createButtonWithIcon(
                      width: Env.LAYOUT_MAX_WIDTH! * 0.4,
                      icon: Icons.notifications_outlined,
                      color: AppColors.grey,
                      textColors: AppColors.black,
                      text: "벨울리기",
                      function: () {},
                    ),
                    button2: createElevatedButton(
                      width: Env.LAYOUT_MAX_WIDTH! * 0.4,
                      color: AppColors.blue,
                      textColors: AppColors.white,
                      text: "대여하기",
                      function: () {},
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Set<JavascriptChannel> _createJavascriptChannels(BuildContext context) {
    return {
      JavascriptChannel(
          name: 'webToApp',
          onMessageReceived: (message) {
            String resivedDataType = jsonDecode(message.message).runtimeType.toString();
            mapController.setDataType(resivedDataType);

            if (resivedDataType != "String") {
              Map<String, dynamic> resultMap = jsonDecode(message.message);
              MapInfo mapInfo = MapInfo.fromJson(resultMap);

              setState(() {
                mapInfoType = mapInfo.type;
              });

              Log.debug("type : ${mapInfo.type}");
              Log.debug("type : ${mapInfo.data.toString()}");

              if (mapInfoType == "parking") {
                setState(() {
                  parkingName = mapInfo.getPkName();
                  parkingAddress = mapInfo.getPkAddr();
                  parkingPrice = mapInfo.getPkPrice();
                  parkingOperation = mapInfo.getPkOper();
                  parkingCount = mapInfo.getPkCount().toString();
                  parkingTime = mapInfo.getPkTime();
                  parkingPhoneNumber = mapInfo.getPkPhone();
                  parkingLat = mapInfo.getPkLat();
                  parkingLng = mapInfo.getPkLng();
                });
              } else if (mapInfoType == "pm") {
                setState(() {
                  personalMobName = mapInfo.getPmName();
                  personalMobModel = mapInfo.getPmModel();
                  personalMobPrice = mapInfo.getPmPrice().toString();
                  personalMobOper = mapInfo.getPmOper();
                });
              } else {
                setState(() {
                  parkingName = "";
                  parkingAddress = "";
                  parkingPrice = "";
                  parkingOperation = "";
                  parkingCount = "";
                  parkingTime = "";
                  parkingPhoneNumber = "";
                  personalMobName = "";
                  personalMobModel = "";
                  personalMobPrice = "";
                  personalMobOper = "";
                });
              }

              showBottomDialog();
            } else {
              closeBottomNav();
            }
          })
    };
  }

  void _sendGPS() {
    searchAddress().then((position) {
      Log.debug("currentPosition X : ${position.latitude}\ncurrentPosition Y :${position.longitude}");
      mapController.setLatitude(position.latitude);
      mapController.setLongitude(position.longitude);
      _webViewController.runJavascript("appToGps(${position.latitude}, ${position.longitude})");
    });
  }

  void closeBottomNav() {
    if (loginController.isBottomOpen) {
      loginController.offBottomNav();
      Get.back();
    }
  }

  Column _createInfoHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        createCustomText(
          top: 0.0,
          bottom: 0.0,
          left: 16.0,
          right: 8.0,
          color: AppColors.white,
          weight: AppFontWeight.bold,
          size: 18.0,
          text: title,
        ),
        createCustomText(
          top: 0.0,
          bottom: 0.0,
          left: 16.0,
          right: 8.0,
          color: AppColors.grey,
          weight: AppFontWeight.regular,
          size: 12.0,
          text: subtitle,
        ),
      ],
    );
  }

  Container _createInfoMain({required List<String> titles, required List<String> contents, required Widget button1, required Widget button2}) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(titles.length, (index) {
                  return createCustomText(
                    weight: AppFontWeight.semiBold,
                    color: AppColors.textGrey,
                    size: 15.0,
                    text: titles[index],
                  );
                }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(contents.length, (index) {
                  return createCustomText(
                    weight: AppFontWeight.semiBold,
                    color: AppColors.textGrey,
                    size: 15.0,
                    text: contents[index],
                  );
                }),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [button1, button2],
          ),
        ],
      ),
    );
  }

  void _requsetMapSearch() async {
    Log.debug("네이버지도");
    if (Platform.isIOS) {
      Log.debug("ios");
      Uri navermap = Uri.parse(
          "nmap://route/car?slat=${mapController.latitude.toString()}&slng=${mapController.longitude.toString()}&sname=내위치&dlat=${parkingLat.toString()}&dlng=${parkingLng.toString()}&dname=$parkingName");
      if (await canLaunchUrl(navermap)) {
        await launchUrl(navermap);
      } else {
        Log.debug("Can't launch $navermap");
        Uri url = Uri.parse('https://apps.apple.com/kr/app/id311867728');
        launchUrl(url);
      }
      // try {
      //   //nmap 은 canlaunchUrl 안되고  try ~ catch 만 된다
      //   await launchUrl(navermap);
      // } catch (e) {
      //   Log.debug("Can't launch $navermap");
      //   Uri url = Uri.parse('https://apps.apple.com/kr/app/id311867728');
      //   launchUrl(url);
      // }
    } else if (Platform.isAndroid) {
      Log.debug("Android");
      Uri navermap = Uri.parse(
          "nmap://route/car?slat=${mapController.latitude.toString()}&slng=${mapController.longitude.toString()}&sname=내위치&dlat=${parkingLat.toString()}&dlng=${parkingLng.toString()}&dname=$parkingName");
      try {
        //nmap 은 canlaunchUrl 안되고  try ~ catch 만 된다
        await launchUrl(navermap);
      } catch (e) {
        Log.debug("Can't launch $navermap");
        Uri url = Uri.parse('market://details?id=com.nhn.android.nmap');
        launchUrl(url);
      }
    }
    // Log.debug("카카오지도");
    // if (Platform.isIOS) {
    //   //
    //   Log.debug("ios");
    //   Uri kakaomap = Uri.parse(
    //       "kakaomap://route?sp=${mapController.latitude.toString()},${mapController.longitude.toString()}&ep=${parkingLat.toString()},${parkingLng.toString()}&by=CAR");
    //   try {
    //     await launchUrl(kakaomap);
    //   } catch (e) {
    //     Log.debug("Can't launch $kakaomap");
    //     Uri url =
    //         Uri.parse('https://apps.apple.com/kr/app/id304608425');
    //     launchUrl(url);
    //   }
    // } else if (Platform.isAndroid) {
    //   Log.debug("Android");
    //   Uri kakaomap = Uri.parse(
    //       "kakaomap://route?sp=${mapController.latitude.toString()},${mapController.longitude.toString()}&ep=${parkingLat.toString()},${parkingLng.toString()}&by=CAR");
    //   try {
    //     await launchUrl(kakaomap);
    //   } catch (e) {
    //     Log.debug("Can't launch $kakaomap");
    //     Uri url =
    //         Uri.parse('market://details?id=net.daum.android.map');
    //     launchUrl(url);
    //   }
    // }
  }
}
