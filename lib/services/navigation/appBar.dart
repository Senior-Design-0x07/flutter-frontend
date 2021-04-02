import 'package:flutter/material.dart';

class HHAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;

  const HHAppBar({Key key, @required this.title, @required this.scaffoldKey}) : super(key: key);

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
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text("8")),
            ))
      ],
    );
  }
}
