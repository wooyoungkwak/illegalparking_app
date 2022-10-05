import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/controllers/map_controller.dart';
import 'package:illegalparking_app/utils/log_util.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final controller = Get.put(MapController());
  late String changeText = "Web View Test";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: WebView(
            // initialUrl: "http://10.0.2.2:3000",
            initialUrl: "http://220.95.46.211:18090/area/map",
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              Log.debug("Webview is loading (progress : $progress%");
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: _createJavascriptChannels(context),
          ),
        ),
        GetBuilder<MapController>(
          builder: (controller) {
            if (controller.clickedMap) {
              return Text(controller.testText);
            }
            return const Text("웹에서 앱전달 실패");
          },
        ),
      ],
    );
  }

  void showBottomDialog() {
    showBottomSheet(
      context: context,
      builder: buildBottomSheet,
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
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
                      color: Colors.blue,
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
                      Column(
                        children: const [
                          Text("빛가람동 제 4 공영 주차장"),
                          Text("전라남도 나주시 우정로 105"),
                        ],
                      ),
                    ],
                  ),
                ),
                // 정보
                _createInfoItem(info: "주차요금", data: "현재무료"),
                _createInfoItem(info: "운영시간", data: "00:00~24:00"),
                _createInfoItem(info: "주차가능면", data: "87면(전체114면)"),
              ],
            ),
          ),
          //버튼
          Row(
            children: [
              Expanded(
                child: _createInfoButton(text: "전화하기"),
              ),
              Expanded(
                child: _createInfoButton(text: "길안내"),
              ),
            ],
          )
        ],
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

  Material _createInfoButton({String? text}) {
    return Material(
      child: Ink(
        color: Colors.blue,
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
            controller.getTestText(message.message);
            controller.getClickedMap(true);
            showBottomDialog();
          })
    };
  }
}
