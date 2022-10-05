import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:illegalparking_app/controllers/login_controller.dart';
import 'package:illegalparking_app/states/guest_camera.dart';
import 'package:illegalparking_app/states/guest_my_page.dart';
import 'package:illegalparking_app/states/webview.dart';
import 'package:illegalparking_app/states/camera.dart';
import 'package:illegalparking_app/states/my_page.dart';
import 'package:illegalparking_app/states/whole_camera_state.dart';
import 'package:illegalparking_app/states/widgets/crop.dart';
import 'package:mask_for_camera_view/mask_for_camera_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final loginController = Get.put(LoginController());

  late String changeText = "안녕하세요\n김봉남님";

  static const List<Widget> _widgetOption = <Widget>[
    WebviewPage(),
    Wholecamera(),
    MyPage(),
  ];

  static const List<Widget> _guestModeWidgetOption = <Widget>[
    WebviewPage(),
    GuestCamera(),
    GuestMyPage(),
  ];

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: _selectedIndex == 2 && !loginController.isGuestMode
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(changeText),
              // centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/infomation');
                    },
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
