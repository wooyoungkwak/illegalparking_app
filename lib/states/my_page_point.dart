import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/config/style.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';
import 'package:illegalparking_app/models/result_model.dart';
import 'package:illegalparking_app/services/server_service.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/alarm_util.dart';
import 'package:illegalparking_app/utils/log_util.dart';
import 'package:illegalparking_app/utils/time_util.dart';
import 'package:intl/intl.dart';

class MyPagePoint extends StatefulWidget {
  const MyPagePoint({super.key});

  @override
  State<MyPagePoint> createState() => _MyPagePointState();
}

class _MyPagePointState extends State<MyPagePoint> {
  final loginController = Get.put(LoginController());
  final myPageController = Get.put(MyPageController());

  late Future<PointListInfo> requestInfo;

  List<dynamic> pointInfoList = [];

  List<dynamic> productList = [];

  Color _setPointColor(String pointType) {
    if (pointType == "PLUS") {
      return AppColors.blue;
    } else {
      return AppColors.red;
    }
  }

  String _setPointValue(String pointType, int value) {
    String pointWithComma = numberWithComma(value);
    if (pointType == "PLUS") {
      return "+${pointWithComma.toString()}";
    } else {
      return "-${pointWithComma.toString()}";
    }
  }

  String _setPointContent(String pointType, String locationType, String productName, int point) {
    String pointWithComma = numberWithComma(point);
    if (pointType == "PLUS") {
      return "$locationType로 부터 포상금 ${pointWithComma.toString()}포인트 제공되었습니다.";
    } else {
      return "-$productName으로 ${pointWithComma.toString()}를 사용하셨습니다.";
    }
  }

  String numberWithComma(int number) {
    return NumberFormat("###,###,###").format(number);
  }

  Padding _createPointPadding({String? text, int? point}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Row(
        children: [
          createCustomText(
            padding: 0.0,
            weight: AppFontWeight.semiBold,
            size: 16.0,
            text: text ?? "",
          ),
          const Spacer(),
          createCustomText(
            padding: 0.0,
            weight: AppFontWeight.semiBold,
            size: 16.0,
            text: numberWithComma(point ?? 0),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    requestInfo = requestPoint(Env.USER_SEQ!);
    requestInfo.then((pointListInfo) {
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
        backgroundColor: AppColors.appBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.appBackground,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Material(
            color: AppColors.appBackground,
            child: InkWell(
              onTap: () {
                loginController.changeRealPage(2);
              },
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.white,
                size: 40,
              ),
            ),
          ),
          title: createCustomText(
            weight: AppFontWeight.bold,
            color: AppColors.white,
            size: 16.0,
            text: "내포인트",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              // 현재 포인트
              createMypageContainer(
                widgetList: <Widget>[
                  createCustomText(
                    weight: AppFontWeight.bold,
                    size: 16.0,
                    text: "현재 나의 포인트",
                  ),
                  const Spacer(),
                  Obx(
                    () => createCustomText(
                      right: 0.0,
                      weight: AppFontWeight.semiBold,
                      size: 26,
                      text: myPageController.currentPoint.value.toString(),
                    ),
                  ),
                  createCustomText(
                    top: 16,
                    bottom: 4.0,
                    left: 0.0,
                    weight: AppFontWeight.semiBold,
                    size: 12,
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
                    weight: AppFontWeight.bold,
                    size: 16.0,
                    text: "포인트 사용하기",
                  ),
                  const Spacer(),
                  chevronRight(),
                ],
              ),
              FutureBuilder(
                future: requestInfo,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _initPointListByContainer();
                  } else if (snapshot.hasError) {
                    showErrorToast(text: "데이터를 가져오는데 실패하였습니다.");
                  }
                  return Container(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        createCustomText(color: AppColors.black, text: "로딩중..."),
                        const CircularProgressIndicator(
                          color: AppColors.black,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _initPointListByContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Wrap(
        children: List.generate(
          pointInfoList.length,
          (index) => SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      createCustomText(
                        top: 0.0,
                        bottom: 2.0,
                        weight: AppFontWeight.semiBold,
                        size: 30.0,
                        color: _setPointColor(pointInfoList[index].pointType),
                        text: _setPointValue(pointInfoList[index].pointType, pointInfoList[index].value),
                      ),
                      createCustomText(
                        top: 2.0,
                        bottom: 2.0,
                        weight: AppFontWeight.regular,
                        size: 14.0,
                        text: _setPointContent(pointInfoList[index].pointType, pointInfoList[index].locationType, pointInfoList[index].productName, pointInfoList[index].value),
                      ),
                      createCustomText(
                        top: 2.0,
                        bottom: 8.0,
                        weight: AppFontWeight.regular,
                        color: AppColors.textGrey,
                        size: 12.0,
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
    );
  }

  _showPointDialog(ProductListInfo productListInfo) {
    productList = productListInfo.productInfos;
    showDialog(
      context: context,
      builder: (BuildContext context) => Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.appBackground,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: createCustomText(
            color: AppColors.white,
            weight: FontWeight.bold,
            size: 16.0,
            text: "포인트 사용하기",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.white,
                ))
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: List.generate(
            productList.length,
            (index) => Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Material(
                borderRadius: BorderRadius.circular(18.0),
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
                                  weight: AppFontWeight.semiBold,
                                  size: 16.0,
                                  text: "${productList[index].brandType} ${productList[index].productName} 교환권",
                                ),
                                // 포인트
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    createCustomText(
                                      padding: 0.0,
                                      weight: AppFontWeight.semiBold,
                                      size: 26.0,
                                      text: numberWithComma(productList[index].pointValue),
                                    ),
                                    createCustomText(
                                      top: 16,
                                      bottom: 4.0,
                                      right: 0.0,
                                      left: 0.0,
                                      weight: AppFontWeight.semiBold,
                                      size: 12.0,
                                      text: "P",
                                    ),
                                  ],
                                ),
                                createCustomText(
                                  padding: 0.0,
                                  size: 10.0,
                                  color: AppColors.textGrey,
                                  weight: AppFontWeight.regular,
                                  text: "모바일상품권",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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

    showDialog(
      context: context,
      builder: (BuildContext context) => Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.appBackground,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: createCustomText(
            color: AppColors.white,
            weight: FontWeight.bold,
            size: 16.0,
            text: "상품 신청하기",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.white,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: ListView(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height),
                // height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image(
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                          // image: AssetImage(productInfo["image"]),),
                          image: NetworkImage("${Env.FILE_SERVER_URL}${productInfo.thumbnail}")),
                      // 상품권 정보
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          createCustomText(
                            padding: 0.0,
                            weight: AppFontWeight.semiBold,
                            size: 18.0,
                            text: "${productInfo.brandType} ${productInfo.productName} 교환권",
                          ),
                          // 포인트
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              createCustomText(
                                padding: 0.0,
                                weight: AppFontWeight.semiBold,
                                size: 26.0,
                                text: numberWithComma(productInfo.pointValue),
                              ),
                              createCustomText(
                                top: 16,
                                bottom: 4.0,
                                right: 0.0,
                                left: 0.0,
                                weight: AppFontWeight.semiBold,
                                size: 12.0,
                                text: "P",
                              ),
                            ],
                          ),
                          createCustomText(
                            padding: 0.0,
                            color: AppColors.textGrey,
                            weight: AppFontWeight.regular,
                            size: 10.0,
                            text: "모바일상품권",
                          ),
                        ],
                      ),
                      // 전송 정보
                      Container(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                createCustomText(
                                  padding: 2.0,
                                  weight: AppFontWeight.regular,
                                  text: "보낼곳: ",
                                ),
                                createCustomText(
                                  padding: 2.0,
                                  weight: AppFontWeight.regular,
                                  text: "전송: ",
                                ),
                                createCustomText(
                                  padding: 2.0,
                                  weight: AppFontWeight.regular,
                                  text: "상품형태: ",
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                createCustomText(
                                  padding: 2.0,
                                  weight: AppFontWeight.regular,
                                  text: "${Env.USER_PHONE_NUMBER}",
                                ),
                                createCustomText(
                                  padding: 2.0,
                                  weight: AppFontWeight.regular,
                                  text: "문자메시지",
                                ),
                                createCustomText(
                                  padding: 2.0,
                                  weight: AppFontWeight.regular,
                                  text: "모바일상품권",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 포인트 계산
                      Container(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Column(
                          children: [
                            _createPointPadding(
                              text: "현재 포인트",
                              point: myPageController.currentPoint.value,
                            ),
                            _createPointPadding(
                              text: "사용 포인트",
                              point: productInfo.pointValue,
                            ),
                            _createPointPadding(
                              text: "사용후 잔액",
                              point: balancePointValue,
                            ),
                          ],
                        ),
                      ),
                      // 상품신청
                      createElevatedButton(
                        color: AppColors.blue,
                        text: "상품신청",
                        function: balancePointValue < 0
                            ? null
                            : () {
                                requestProductBuy(Env.USER_SEQ!, productInfo.productSeq, balancePointValue).then(
                                  (productBuyInfo) {
                                    if (productBuyInfo.success) {
                                      // 등록 알림 메시지
                                      Log.debug(productBuyInfo.data);
                                      myPageController.setCurrentPotin(balancePointValue);
                                      // Navigator.pop(context);
                                    } else {
                                      // 실패 알림 메시지....
                                      Log.debug(productBuyInfo.message);
                                    }
                                  },
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
