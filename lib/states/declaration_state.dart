import 'dart:io';
import '../main.dart';
import '../states/confirmation.state.dart';
import '../controllers/address_controller.dart';
import '../states/part_camera_state.dart';
import '../states/whole_camera_state.dart';
import '../services/save_image_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Declaration extends StatefulWidget {
  @override
  State<Declaration> createState() => _DeclarationState();
}

class _DeclarationState extends State<Declaration> {
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _NumberplateContoroller;

  @override
  void initState() {
    super.initState();

    String? number;
    number = "123가 465789";
    //나중에 번호판 값 받아오면 넣을 위치
    if (number == null) {
      _NumberplateContoroller = TextEditingController(text: "");
    } else {
      _NumberplateContoroller = TextEditingController(text: number);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _NumberplateContoroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReactiveController());
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return _createWillPopScope(
      Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  // Get.offAll(main());
                                },
                                icon: Icon(Icons.close_outlined),
                                color: Colors.white),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Obx((() => SizedBox(
                                    height: 160,
                                    child: Image.file(
                                      File(controller.whole_Image.value),
                                      fit: BoxFit.fill,
                                    ),
                                  ))),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(const Wholecamera());
                                  // Navigator.pop(context);
                                },
                                child: const Text('재촬영'),
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Obx((() => SizedBox(height: 90, child: Image.file(File(controller.part_Image.value))))),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(const Partcamera());
                                },
                                child: const Text('재촬영'),
                              ),
                            ],
                          )),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "차량번호",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(width: 200, height: 50, child: Card(child: _createTextFormField(_NumberplateContoroller))),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "접수위치",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Obx(() {
                                  return Flexible(
                                    child: Text(
                                      controller.image_GPS.value.address.length > 1 ? controller.image_GPS.value.address : "주소를 찾을 수 없습니다.",
                                      //controller.image_GPS.value.address.substring(4),//구글 map사용해서 앞에 대한민국 붙음
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                })
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "접수시간",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "${DateTime.now()}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Obx(() {
                              return Flexible(
                                child: Text(
                                  controller.image_GPS.value.latitude.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                            Obx(() {
                              return Flexible(
                                child: Text(
                                  controller.image_GPS.value.longitude.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await saveImageGallery();

                                Get.off(Confirmation());
                              },
                              child: const Text('신고하기'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Wrap(
                          children: [
                            const Text(
                              "주차와 정차를 할 수 없거나 자신의 소유권(또는 이용권)이 없는 주정차 구역에 주정차를 하는 행위를 말하며, 무단주차 또는 주정차위반이라고도 한다. 자동차가.",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _createTextFormField(TextEditingController controller) {
    return TextField(
        textAlign: TextAlign.center,
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: '번호판 입력란',
          hintStyle: TextStyle(color: Colors.black),
        ));
  }
}

WillPopScope _createWillPopScope(Widget widget) {
  return WillPopScope(
      onWillPop: () {
        // Get.offAll(() => main());
        return Future(() => false);
      },
      child: widget);
}
