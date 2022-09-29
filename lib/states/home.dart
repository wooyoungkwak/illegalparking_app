import 'package:flutter/material.dart';
import 'package:illegalparking_app/states/webview.dart';
import 'package:illegalparking_app/states/camera.dart';
import 'package:illegalparking_app/states/my_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String changeText = "안녕하세요\n김봉남님";
  int _selectedIndex = 1;
  static const List<Widget> _widgetOption = <Widget>[
    WebviewPage(),
    MyCamera(),
    MyPage(),
  ];

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(changeText),
              // centerTitle: true,
              actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings))],
            )
          : null,
      body: _widgetOption.elementAt(_selectedIndex),
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
