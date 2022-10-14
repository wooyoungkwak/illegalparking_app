import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/controllers/map_controller.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/log_util.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../models/webview_model.dart';
import '../services/such_loation_service.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  Timer? timer;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final controller = Get.put(MapController());
  late WebViewController _webViewController;
  String mapInfoType = "parking";
  String parkingName = "";
  String parkingAddress = "";
  String parkingPrice = "";
  String parkingOperation = "";
  String parkingCount = "";
  String parkingTime = "";
  String personalMobName = "";
  String personalMobPrice = "";
  String personalMobTime = "";

  void timerGPS() {
    timer = Timer.periodic(const Duration(milliseconds: 10000), (timer) {
      searchAddress().then((position) {
        Log.debug("currentPosition X : ${position.latitude}\ncurrentPosition Y :${position.longitude}");
        controller.setLatitude(position.latitude);
        controller.setLongitude(position.longitude);
        // _webViewController.runJavascript("appToGps(${position.latitude}, ${position.longitude})");
      });
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
              // initialUrl: "http://10.0.2.2:3000",
              initialUrl: "http://teraenergy.iptime.org:18090/api/area/map",
              // initialUrl: "http://ipaddr:80/api/area/map",
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
          //     if (controller.clickedMap) {
          //       return Text(controller.testText);
          //     }
          //     return const Text("웹에서 앱전달 실패");
          //   },
          // ),
          GetBuilder<MapController>(
            builder: (controller) {
              return Column(
                children: [
                  Text("위도 : ${controller.latitude.toString()}"),
                  Text("경도 : ${controller.longitude.toString()}"),
                ],
              );
            },
          ),
          createElevatedButton(
            text: "appToGPS",
            function: () {
              showBottomDialog();
              _webViewController.runJavascript("appToGps(123, 456)");
            },
          ),
        ],
      ),
    );
  }

  void showBottomDialog() {
    showBottomSheet(
      context: context,
      builder: buildBottomSheet,
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return GestureDetector(
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
          onTap: () {},
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
                parkingCount = mapInfo.getPkCount();
                parkingTime = mapInfo.getPkTime();
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
                personalMobName = "";
                personalMobPrice = "";
              });
            }
            controller.getClickedMap(true);
            showBottomDialog();
          })
    };
  }
}
