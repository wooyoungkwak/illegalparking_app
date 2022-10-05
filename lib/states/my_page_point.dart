import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/widgets/form.dart';
import 'package:illegalparking_app/utils/time_util.dart';

class MyPagePoint extends StatefulWidget {
  const MyPagePoint({super.key});

  @override
  State<MyPagePoint> createState() => _MyPagePointState();
}

class _MyPagePointState extends State<MyPagePoint> {
  List testList = [
    {
      "point": "+2,000",
      "message": "나주시로 부터 포상금 2,000포인트 지급되었습니다.",
      "time": getDateToStringForAll(getNow()),
    },
    {
      "point": "-4,500",
      "message": "스타벅스 커피 교환권으로 4500포인트를 사용하셨습니다.",
      "time": "2020-10-04 14:23",
    },
    {
      "point": "+5,000",
      "message": "광양시로 부터 포상금 5,000포인트 제공되었습니다.",
      "time": "2022-09-30 10:09",
    },
    {
      "point": "+500",
      "message": "웰컴 포인트 5,000포인트 제공되었습니다.",
      "time": "2022-09-27 12:03",
    },
    {
      "point": "+2000",
      "message": "나주시로 부터 포상금 2,000포인트 지급되었습니다.",
      "time": "2022-09-24 11:33",
    },
  ];

  List pointList = [
    {
      "image": "assets/noimage.jpg",
      "gift": "스타벅스 아메리카노 교환권",
      "point": "4,500",
      "type": "모바일상품권",
    },
    {
      "image": "assets/noimage.jpg",
      "gift": "베스킨라빈스 아이스크림 교환권",
      "point": "10,500",
      "type": "모바일상품권",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: createCustomText(
          color: Colors.white,
          text: "내 포인트",
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          // 현재 포인트
          createMypageCard(
            widgetList: <Widget>[
              createCustomText(
                weight: FontWeight.w400,
                text: "현재 나의 포인트",
              ),
              const Spacer(),
              createCustomText(
                padding: 0.0,
                size: 32.0,
                text: "3000",
              ),
              createCustomText(
                padding: 0.0,
                weight: FontWeight.w400,
                text: "P",
              ),
            ],
          ),
          createMypageCard(
            route: () {
              _showPointDialog();
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
                testList.length,
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
                              color: testList[index]["point"].substring(0, 1) == "+" ? Colors.blue : Colors.red,
                              text: testList[index]["point"],
                            ),
                            createCustomText(
                              padding: 0.0,
                              size: 16.0,
                              weight: FontWeight.w400,
                              text: testList[index]["message"],
                            ),
                            createCustomText(
                              padding: 0.0,
                              size: 12.0,
                              weight: FontWeight.w200,
                              text: testList[index]["time"],
                            ),
                          ],
                        ),
                      ),
                      if (testList.length != (index + 1))
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
    );
  }

  _showPointDialog() {
    showCustomDialog(
      context: context,
      title: "포인트 사용하기",
      widget: Card(
        elevation: 4,
        child: ListView(
          shrinkWrap: true,
          children: List.generate(
            pointList.length,
            (index) => Material(
              child: InkWell(
                onTap: () {
                  _showGiftDialog(pointList[index]);
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
                            image: AssetImage("assets/noimage.jpg"),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              createCustomText(
                                padding: 0.0,
                                size: 14.0,
                                weight: FontWeight.w400,
                                text: pointList[index]["gift"],
                              ),
                              // 포인트
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  createCustomText(
                                    padding: 0.0,
                                    size: 18.0,
                                    text: pointList[index]["point"],
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
                                text: pointList[index]["type"],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (pointList.length != (index + 1))
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

  _showGiftDialog(dynamic object) {
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
                      image: AssetImage(
                        object["image"],
                      ),
                    ),
                    // 상품권 정보
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        createCustomText(
                          padding: 2.0,
                          size: 14.0,
                          weight: FontWeight.w400,
                          text: object["gift"],
                        ),
                        // 포인트
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            createCustomText(
                              padding: 0.0,
                              size: 18.0,
                              text: object["point"],
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
                          text: object["type"],
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
                            text: "보낼곳: 010-1234-4568",
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
                            text: "상품형태:${object["type"]}",
                          ),
                        ],
                      ),
                    ),
                    // 포인트 계산
                    Container(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        children: [
                          _createPointPadding(text: "현재 포인트", point: "9000"),
                          _createPointPadding(text: "사용 포인트", point: "4500"),
                          _createPointPadding(text: "사용후 잔액", point: "4500"),
                        ],
                      ),
                    ),
                    // 상품신청
                    createElevatedButton(
                        padding: 24.0,
                        text: "상품신청",
                        function: () {
                          Navigator.pop(context);
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
