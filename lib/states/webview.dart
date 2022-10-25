import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
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
  final showKey = GlobalKey();
  Timer? timer;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final mapController = Get.put(MapController());
  final loginController = Get.put(LoginController());

  late WebViewController _webViewController;
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
  String personalMobTime = "";
  double parkingLat = 0.0;
  double parkingLng = 0.0;

  void timerGPS() {
    _sendGPS();
    timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      _sendGPS();
    });
  }

  @override
  void initState() {
    super.initState();
    timerGPS();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
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
          // GetBuilder<MapController>(
          //   builder: (controller) {
          //     return Column(
          //       children: [
          //         Text("위도 : ${controller.latitude.toString()}"),
          //         Text("경도 : ${controller.longitude.toString()}"),
          //       ],
          //     );
          //   },
          // ),
          // createElevatedButton(
          //   text: "appToGPS",
          //   function: () {
          //     showBottomDialog();
          //     _webViewController.runJavascript("appToGps(123, 456)");
          //   },
          // ),
        ],
      ),
    );
  }

  void showBottomDialog() {
    loginController.onBottomNav();
    showBottomSheet(
      context: context,
      builder: buildBottomSheet,
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return GestureDetector(
      key: showKey,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        width: double.infinity,
        // height: MediaQuery.of(context).size.height * 0.3,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  // 손잡이?
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      width: 40,
                      height: 5,
                    ),
                  ),
                  // 이미지, 위치 주소
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image(
                            image: AssetImage("assets/noimage.jpg"),
                            height: 40,
                            width: 40,
                          ),
                        ),
                        if (mapInfoType == "parking")
                          Column(
                            children: [
                              Text(parkingName),
                              Text(parkingAddress),
                            ],
                          ),
                        if (mapInfoType == "pm")
                          Column(
                            children: [
                              Text(personalMobName),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // 정보
                  if (mapInfoType == "parking")
                    Wrap(
                      children: [
                        _createInfoItem(info: "주차요금", data: parkingOperation),
                        _createInfoItem(info: "운영시간", data: parkingTime),
                        _createInfoItem(info: "전화번호", data: parkingPhoneNumber),
                        _createInfoItem(info: "주차가능면", data: parkingCount),
                      ],
                    ),
                  if (mapInfoType == "pm")
                    Wrap(
                      children: [
                        _createInfoItem(info: "대여료", data: personalMobPrice),
                        _createInfoItem(info: "운영시간", data: personalMobPrice),
                      ],
                    ),
                ],
              ),
            ),
            //버튼
            if (mapInfoType == "parking")
              Row(
                children: [
                  Expanded(
                    child: _createInfoButton(text: "전화하기"),
                  ),
                  Expanded(
                    child: _createInfoButton(text: "길안내"),
                  ),
                ],
              ),
            if (mapInfoType == "pm")
              Row(
                children: [
                  Expanded(
                    child: _createInfoButton(color: Colors.purple, text: "벨울리기"),
                  ),
                  Expanded(
                    child: _createInfoButton(color: Colors.purple, text: "대여하기"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Padding _createInfoItem({String? info, String? data}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(info ?? ""),
          const Spacer(),
          Text(data ?? ""),
        ],
      ),
    );
  }

  Material _createInfoButton({String? text, Color? color}) {
    return Material(
      child: Ink(
        color: color ?? Colors.blue,
        height: 40,
        child: InkWell(
          onTap: () async {
            if (text == "길안내") {
              print("네이버지도");
              if (Platform.isIOS) {
                print("ios");
                Uri navermap = Uri.parse(
                    "nmap://route/car?slat=${mapController.latitude.toString()}&slng=${mapController.longitude.toString()}&sname=내위치&dlat=${parkingLat.toString()}&dlng=${parkingLng.toString()}&dname=${parkingName}");
                try {
                  //nmap 은 canlaunchUrl 안되고  try ~ catch 만 된다
                  await launchUrl(navermap);
                } catch (e) {
                  print("Can't launch $navermap");
                  Uri url = Uri.parse('https://apps.apple.com/kr/app/id311867728');
                  launchUrl(url);
                }
              } else if (Platform.isAndroid) {
                print("Android");
                Uri navermap = Uri.parse(
                    "nmap://route/car?slat=${mapController.latitude.toString()}&slng=${mapController.longitude.toString()}&sname=내위치&dlat=${parkingLat.toString()}&dlng=${parkingLng.toString()}&dname=${parkingName}");
                try {
                  //nmap 은 canlaunchUrl 안되고  try ~ catch 만 된다
                  await launchUrl(navermap);
                } catch (e) {
                  print("Can't launch $navermap");
                  Uri url = Uri.parse('market://details?id=com.nhn.android.nmap');
                  launchUrl(url);
                }
              }
            } else if (text == "전화하기") {
              // print("카카오지도");
              // if (Platform.isIOS) {
              //   //
              //   print("ios");
              //   Uri kakaomap = Uri.parse(
              //       "kakaomap://route?sp=${mapController.latitude.toString()},${mapController.longitude.toString()}&ep=${parkingLat.toString()},${parkingLng.toString()}&by=CAR");
              //   try {
              //     await launchUrl(kakaomap);
              //   } catch (e) {
              //     print("Can't launch $kakaomap");
              //     Uri url =
              //         Uri.parse('https://apps.apple.com/kr/app/id304608425');
              //     launchUrl(url);
              //   }
              // } else if (Platform.isAndroid) {
              //   print("Android");
              //   Uri kakaomap = Uri.parse(
              //       "kakaomap://route?sp=${mapController.latitude.toString()},${mapController.longitude.toString()}&ep=${parkingLat.toString()},${parkingLng.toString()}&by=CAR");
              //   try {
              //     await launchUrl(kakaomap);
              //   } catch (e) {
              //     print("Can't launch $kakaomap");
              //     Uri url =
              //         Uri.parse('market://details?id=net.daum.android.map');
              //     launchUrl(url);
              //   }
              // }
              makePhoneCall(parkingPhoneNumber);
            }
          },
          child: Center(
            child: Text(
              text ?? "",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Set<JavascriptChannel> _createJavascriptChannels(BuildContext context) {
    return {
      JavascriptChannel(
          name: 'webToApp',
          onMessageReceived: (message) {
            Map<String, dynamic> resultMap = jsonDecode(message.message);
            MapInfo mapInfo;
            mapInfo = MapInfo.fromJson(resultMap);
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
                personalMobPrice = mapInfo.getPmPrice();
                personalMobTime = mapInfo.getPmTime();
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
                personalMobPrice = "";
              });
            }
            mapController.getClickedMap(true);
            showBottomDialog();
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
}
