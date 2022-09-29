import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

class MyPageReport extends StatefulWidget {
  const MyPageReport({super.key});

  @override
  State<MyPageReport> createState() => _MyPageReportState();
}

class _MyPageReportState extends State<MyPageReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("신고이력"),
      ),
      body: createMypageCard(
        widgetList: [Text("신고 이력")],
      ),
    );
  }
}
