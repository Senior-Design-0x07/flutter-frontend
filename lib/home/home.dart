import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/navigation/appBar.dart';
import 'package:hobby_hub_ui/services/navigation/navDrawer.dart';

class Home extends StatefulWidget {
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
          child: HHAppBar(title: 'Hobby Hub Home', scaffoldKey: _scaffoldKey)),
      body: Column(
        children: [
          Center(child: Text("I am a Home Page")),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BBboard_layout.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
