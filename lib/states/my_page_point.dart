import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

class MyPagePoint extends StatefulWidget {
  const MyPagePoint({super.key});

  @override
  State<MyPagePoint> createState() => _MyPagePointState();
}

class _MyPagePointState extends State<MyPagePoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내 포인트"),
      ),
      body: createMypageCard(
        widgetList: [Text("내 포인트")],
      ),
    );
  }
}
