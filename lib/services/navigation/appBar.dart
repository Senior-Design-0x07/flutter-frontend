import 'package:flutter/material.dart';

class HHAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;

  const HHAppBar({Key key, @required this.title, @required this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          scaffoldKey.currentState.openDrawer();
        },
      ),
      title: Center(
          child: Text(
        title,
        style: TextStyle(color: Colors.white),
      )),
      actions: <Widget>[
        Icon(
          Icons.wifi,
          // TODO Add if statement calling to check if internet is connected
          // (Already implemented on backend, need GET Request) and if true
          // Icon color is blue and if false then icon color is read
          color: Colors.blue,
          size: 30.0,
        ),
      ],
    );
  }
}
