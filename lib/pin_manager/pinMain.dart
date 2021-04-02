import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hobby_hub_ui/services/http_service.dart';
import 'package:hobby_hub_ui/pin_manager/pin_mapping/pinMappingList.dart';
import 'package:hobby_hub_ui/services/navigation/appBar.dart';
import 'package:hobby_hub_ui/services/navigation/navDrawer.dart';

class PinMain extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final HttpService http = new HttpService();

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: NavigationDrawer(),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: HHAppBar(title: 'Pin Manager', scaffoldKey: _scaffoldKey)),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/BBboard_layout.png'),
                    ),
                  ),
                ),
                Container(
                    height: 350, width: double.infinity, child: PinMapping()),
              ],
            ),
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: NavigationDrawer(),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: HHAppBar(title: 'Pin Manager', scaffoldKey: _scaffoldKey)),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/BBboard_layout.png'),
                    ),
                  ),
                ),
                Container(
                    height: 350, width: double.infinity, child: PinMapping()),
              ],
            ),
          ),
        ),
      );
    } else {
      return Text("I am IOS");
    }
  }
}
