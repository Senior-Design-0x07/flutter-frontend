import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/services/logging/logMain.dart';
import 'package:hobby_hub_ui/services/navigation/appBar.dart';
import 'package:hobby_hub_ui/services/navigation/navDrawer.dart';

class Home extends StatefulWidget {
  final HttpService http;

  Home({@required this.http});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: HHAppBar(
              title: 'Hobby Hub Home', http: widget.http, scaffoldKey: _scaffoldKey)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BBboard_layout.png'),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          LogMain(http: widget.http,)
        ],
      ),
    );
  }
}
