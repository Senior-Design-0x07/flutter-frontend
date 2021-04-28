import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/home/home.dart';
import 'package:hobby_hub_ui/pin_manager/pinMain.dart';
import 'package:hobby_hub_ui/program_manager/program_main_page.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/services/navigation/appBar.dart';
import 'package:hobby_hub_ui/wifi/wifi_main_page.dart';

class NavigationController extends StatefulWidget {
  static int selectedIndex = 0;

  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  final PageStorageBucket bucket = PageStorageBucket();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final HttpService http = HttpService();
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      Home(
        key: PageStorageKey('Home'),
        http: http,
      ),
      WifiPage(
        key: PageStorageKey('WiFi'),
        http: http,
      ),
      PinMain(
        key: PageStorageKey('Pin Manager'),
        http: http,
      ),
      ProgramManagerPage(
        key: PageStorageKey('Program Manager'),
        http: http,
      ),
    ];
    super.initState();
  }

  String _selectTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return "Hobby Hub Home";
      case 1:
        return "WiFi";
      case 2:
        return "Pin Manager";
      case 3:
        return "Program Manager";
      default:
        return "";
    }
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Colors.green,
            height: 85,
            child: Center(
              child: DrawerHeader(
                child: Text(
                  'Page Navigation',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                decoration: BoxDecoration(color: Colors.green),
              ),
            ),
          ),
          ListTile(
            title: Text('Home Page'),
            onTap: () {
              Navigator.pop(context);
              setState(() => NavigationController.selectedIndex = 0);
            },
          ),
          ListTile(
            title: Text('WiFi'),
            onTap: () {
              Navigator.pop(context);
              setState(() => NavigationController.selectedIndex = 1);
            },
          ),
          ListTile(
            title: Text('Pin Manager'),
            onTap: () {
              Navigator.pop(context);
              setState(() => NavigationController.selectedIndex = 2);
            },
          ),
          ListTile(
            title: Text('Program Manager'),
            onTap: () {
              Navigator.pop(context);
              setState(() => NavigationController.selectedIndex = 3);
            },
          )
        ],
      ),
    );
  }

  Widget _appBar(int selectedIndex) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HHAppBar(
            title: _selectTitle(selectedIndex),
            http: http,
            scaffoldKey: _scaffoldKey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(NavigationController.selectedIndex),
      drawer: _drawer(),
      body: PageStorage(
        child: pages[NavigationController.selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
