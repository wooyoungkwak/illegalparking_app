import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/config/env.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/services/setting_service.dart';
import 'package:illegalparking_app/states/guest_camera.dart';
import 'package:illegalparking_app/states/guest_my_page.dart';
import 'package:illegalparking_app/states/webview.dart';
import 'package:illegalparking_app/states/my_page.dart';
import 'package:illegalparking_app/states/car_report_camera_state.dart';
import 'package:illegalparking_app/states/widgets/form.dart';

class Home extends StatefulWidget {
  final int? index;
  const Home({Key? key, this.index}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final loginController = Get.put(LoginController());

  late String changeText = "안녕하세요\n김봉남님";

  static const List<Widget> _widgetOption = <Widget>[
    WebviewPage(),
    Reportcamera(),
    MyPage(),
  ];

  static const List<Widget> _guestModeWidgetOption = <Widget>[
    WebviewPage(),
    GuestCamera(),
    GuestMyPage(),
  ];

  late int _selectedIndex;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // MaskForCameraCustomView.initialize();
    super.initState();
    _selectedIndex = widget.index ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginController.offGuesMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    mediasizeSetting(context);
    return Scaffold(
      appBar: _selectedIndex == 2 && !loginController.isGuestMode
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  createCustomText(padding: 0.0, text: "안녕하세요"),
                  Row(
                    children: [
                      createCustomText(padding: 0.0, color: Colors.blue, text: Env.USER_NAME),
                      createCustomText(padding: 0.0, text: "님"),
                    ],
                  ),
                ],
              ),
              // centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/infomation');
                    },
                    color: Colors.black,
                    icon: const Icon(Icons.settings))
              ],
            )
          : null,
      body: loginController.isGuestMode ? _guestModeWidgetOption.elementAt(_selectedIndex) : _widgetOption.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: "지도",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: "카메라",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "내정보",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
    );
  }
}
