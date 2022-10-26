import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';
import 'package:illegalparking_app/models/result_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/utils/time_util.dart';

class MyPagePoint extends StatefulWidget {
  const MyPagePoint({super.key});

  @override
  State<MyPagePoint> createState() => _MyPagePointState();
}

class _MyPagePointState extends State<MyPagePoint> {
  final loginController = Get.put(LoginController());
  final myPageController = Get.put(MyPageController());

  List<dynamic> pointInfoList = [];

  List<dynamic> productList = [];

  Color _setPointColor(String pointType) {
    if (pointType == "PLUS") {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  String _setPointValue(String pointType, int value) {
    if (pointType == "PLUS") {
      return "+${value.toString()}";
    } else {
      return "-${value.toString()}";
    }
  }

  String _setPointContent(String pointType, String locationType, String productName, int point) {
    if (pointType == "PLUS") {
      return "$locationType로 부터 포상금 ${point.toString()}포인트제공되었습니다.";
    } else {
      return "-$productName으로 ${point.toString()}를 사용하셨습니다.";
    }
  }

  @override
  void initState() {
    super.initState();
    requestPoint(Env.USER_SEQ!).then((pointListInfo) {
      setState(() {
        for (int i = 0; i < pointListInfo.pointInfos.length; i++) {
          pointInfoList.add(pointListInfo.pointInfos[i]);
        }
      });
    });
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
          centerTitle: true,
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
          title: createCustomText(
            color: Colors.white,
            text: "내 포인트",
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            // 현재 포인트
            createMypageContainer(
              widgetList: <Widget>[
                createCustomText(
                  weight: FontWeight.w400,
                  text: "현재 나의 포인트",
                ),
                const Spacer(),
                Obx(
                  () => createCustomText(
                    padding: 0.0,
                    size: 32.0,
                    text: myPageController.currentPoint.value.toString(),
                  ),
                ),
                createCustomText(
                  padding: 0.0,
                  weight: FontWeight.w400,
                  text: "P",
                ),
              ],
            ),
            createMypageContainer(
              route: () {
                requestProductList(Env.USER_SEQ!).then((productListInfo) {
                  _showPointDialog(productListInfo);
                  Log.debug("${productListInfo.productInfos[0].toJson()}");
                });
              },
              widgetList: <Widget>[
                createCustomText(
                  weight: FontWeight.w400,
                  text: "포인트 사용하기",
                ),
                const Spacer(),
                createCustomText(
                  padding: 0.0,
                  size: 32.0,
                  weight: FontWeight.w400,
                  text: ">",
                ),
              ],
            ),
            Card(
              child: Wrap(
                children: List.generate(
                  pointInfoList.length,
                  (index) => SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              createCustomText(
                                size: 24.0,
                                color: _setPointColor(pointInfoList[index].pointType),
                                text: _setPointValue(pointInfoList[index].pointType, pointInfoList[index].value),
                              ),
                              createCustomText(
                                padding: 0.0,
                                size: 16.0,
                                weight: FontWeight.w400,
                                text: _setPointContent(pointInfoList[index].pointType, pointInfoList[index].locationType, pointInfoList[index].productName, pointInfoList[index].value),
                              ),
                              createCustomText(
                                padding: 0.0,
                                size: 12.0,
                                weight: FontWeight.w200,
                                text: pointInfoList[index].regDt,
                              ),
                            ],
                          ),
                        ),
                        if (pointInfoList.length != (index + 1))
                          Container(
                            color: Colors.grey,
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                          )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showPointDialog(ProductListInfo productListInfo) {
    productList = productListInfo.productInfos;
    showCustomDialog(
      context: context,
      title: "포인트 사용하기",
      widget: Card(
        elevation: 4,
        child: ListView(
          shrinkWrap: true,
          children: List.generate(
            productList.length,
            (index) => Material(
              child: InkWell(
                onTap: () {
                  _showGiftDialog(productList[index]);
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image(
                              height: 80,
                              width: 80,
                              // image: AssetImage("assets/noimage.jpg"),
                              image: NetworkImage("${Env.FILE_SERVER_URL}${productList[index].thumbnail}")),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              createCustomText(
                                padding: 0.0,
                                size: 14.0,
                                weight: FontWeight.w400,
                                text: "${productList[index].brandType} ${productList[index].productName} 교환권",
                              ),
                              // 포인트
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  createCustomText(
                                    padding: 0.0,
                                    size: 18.0,
                                    text: productList[index].pointValue.toString(),
                                  ),
                                  createCustomText(
                                    padding: 0.0,
                                    size: 12.0,
                                    weight: FontWeight.w400,
                                    text: "P",
                                  ),
                                ],
                              ),
                              createCustomText(
                                padding: 0.0,
                                size: 12.0,
                                weight: FontWeight.w200,
                                text: "모바일상품권",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (productList.length != (index + 1))
                      Container(
                        color: Colors.grey,
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showGiftDialog(dynamic productInfo) {
    int balancePointValue = (myPageController.currentPoint.value - productInfo.pointValue).toInt();
    showCustomDialog(
      context: context,
      title: "상품 신청하기",
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image(
                        // image: AssetImage(productInfo["image"]),),
                        image: NetworkImage("${Env.FILE_SERVER_URL}${productInfo.thumbnail}")),
                    // 상품권 정보
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        createCustomText(
                          padding: 2.0,
                          size: 14.0,
                          weight: FontWeight.w400,
                          text: "${productInfo.brandType} ${productInfo.productName} 교환권",
                        ),
                        // 포인트
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            createCustomText(
                              padding: 0.0,
                              size: 18.0,
                              text: productInfo.pointValue.toString(),
                            ),
                            createCustomText(
                              padding: 0.0,
                              size: 12.0,
                              weight: FontWeight.w400,
                              text: "P",
                            ),
                          ],
                        ),
                        createCustomText(
                          padding: 2.0,
                          size: 12.0,
                          weight: FontWeight.w200,
                          text: "모바일상품권",
                        ),
                      ],
                    ),
                    // 전송 정보
                    Container(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          createCustomText(
                            padding: 2.0,
                            size: 14.0,
                            weight: FontWeight.w400,
                            text: "보낼곳: ${Env.USER_PHONE_NUMBER}",
                          ),
                          createCustomText(
                            padding: 2.0,
                            size: 14.0,
                            weight: FontWeight.w400,
                            text: "전송: 문자메시지",
                          ),
                          createCustomText(
                            padding: 2.0,
                            size: 14.0,
                            weight: FontWeight.w400,
                            text: "상품형태: 모바일상품권",
                          ),
                        ],
                      ),
                    ),
                    // 포인트 계산
                    Container(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        children: [
                          _createPointPadding(text: "현재 포인트", point: myPageController.currentPoint.value.toString()),
                          _createPointPadding(text: "사용 포인트", point: productInfo.pointValue.toString()),
                          _createPointPadding(text: "사용후 잔액", point: (myPageController.currentPoint.value - productInfo.pointValue).toString()),
                        ],
                      ),
                    ),
                    // 상품신청
                    createElevatedButton(
                        padding: 24.0,
                        text: "상품신청",
                        function: balancePointValue < 0
                            ? null
                            : () {
                                requestProductBuy(Env.USER_SEQ!, productInfo.productSeq, balancePointValue).then((productBuyInfo) {
                                  if (productBuyInfo.success) {
                                    // 등록 알림 메시지
                                    Log.debug(productBuyInfo.data);
                                    myPageController.setCurrentPotin(balancePointValue);
                                    // Navigator.pop(context);
                                  } else {
                                    // 실패 알림 메시지....
                                    Log.debug(productBuyInfo.message);
                                  }
                                });
                              }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Padding _createPointPadding({String? text, String? point}) {
  return Padding(
    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
    child: Row(
      children: [
        createCustomText(
          padding: 0.0,
          text: text ?? "",
        ),
        const Spacer(),
        createCustomText(
          padding: 0.0,
          text: point ?? "0",
        ),
      ],
    ),
  );
}
