import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:illegalparking_app/controllers/my_page_controller.dart';

import 'package:illegalparking_app/states/widgets/form.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final controller = Get.put(MyPageController());

  List testlist = [
    {
      "title": "광양시 불법주정차 신고 포상제도",
      "content": "600,000포인트 소진시까지, 신고당 1000포인트 제공합니다. 위치 - 광양사랑병원 사거리",
      "date": "2022-06-24 09:19",
    },
    {
      "title": "광양시 불법주정차 신고 포상제도",
      "content": "600,000포인트 소진시까지, 신고당 1000포인트 제공합니다. 위치 - 광양사랑병원 사거리",
      "date": "2022-06-24 09:19",
    },
    {
      "title": "광양시 불법주정차 신고 포상제도",
      "content": "600,000포인트 소진시까지, 신고당 1000포인트 제공합니다. 위치 - 광양사랑병원 사거리",
      "date": "2022-06-24 09:19",
    },
  ];

  showNoticeDialog(int index) {
    showCustomDialog(
      context: context,
      title: "공지",
      widget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(testlist[index]["title"]),
            Text(testlist[index]["date"]),
            // 빈공간
            Expanded(
              flex: 5,
              child: ConstrainedBox(
                constraints: const BoxConstraints(),
              ),
            ),
            Text(testlist[index]["content"]),
            // 빈공간
            Expanded(
              flex: 5,
              child: ConstrainedBox(
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
    return ListView(
      children: [
        // 등록, 신고, 포인트
        if (!controller.certifiedVehicle)
          createMypageCard(
            route: () {
              Navigator.pushNamed(context, "/registration");
            },
            widgetList: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("내 차 등록을 진행해 주세요"),
                  Text("실시간 신고 알림을 받을 수 있습니다"),
                ],
              ),
              const Spacer(),
              const Text(">")
            ],
          ),
        // 인증 완료
        if (controller.certifiedVehicle)
          Stack(
            children: [
              Card(
                elevation: 4,
                child: Material(
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/infomation");
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 100),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Image(
                                      image: AssetImage("assets/testVehicle.jpg"),
                                      height: 100,
                                      width: 100,
                                    ),
                                    Text("123가 4567"),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              const Text(">")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 15,
                left: 15,
                child: Text(
                  "인증 완료",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        createMypageCard(
          route: () {
            Navigator.pushNamed(context, "/report");
          },
          widgetList: <Widget>[
            Text("신고이력"),
            const Spacer(),
            const Text("27건"),
            const Text(">"),
          ],
        ),
        createMypageCard(
          route: () {
            Navigator.pushNamed(context, "/point");
          },
          widgetList: <Widget>[
            Text("내포인트"),
            const Spacer(),
            const Text("3000P"),
            const Text(">"),
          ],
        ),
        // 공지
        Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
                child: const Text("공지 불법주정차 신고 방법 및 신고 기준"),
              ),
              Container(
                color: Colors.grey,
                height: 1,
                width: MediaQuery.of(context).size.width,
              ),
              // 공지사항 content
              Wrap(
                children: List.generate(
                  testlist.length,
                  (index) => SizedBox(
                      child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          left: 16.0,
                          right: 16.0,
                          bottom: 8.0,
                        ),
                        child: Text(testlist[index]["title"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Text(testlist[index]["content"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Row(
                          children: [
                            const Text("현재시간"),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                showNoticeDialog(index);
                              },
                              child: const Text("더보기 >"),
                            ),
                          ],
                        ),
                      ),
                      if (testlist.length != (index + 1))
                        Container(
                          color: Colors.grey,
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                        )
                    ],
                  )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
