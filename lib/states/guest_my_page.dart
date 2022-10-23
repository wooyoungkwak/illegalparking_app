import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/login.dart';

class GuestMyPage extends StatefulWidget {
  const GuestMyPage({super.key});

  @override
  State<GuestMyPage> createState() => _GuestMyPageState();
}

class _GuestMyPageState extends State<GuestMyPage> {
  @override
  Widget build(BuildContext context) {
    return Login();
  }
}
