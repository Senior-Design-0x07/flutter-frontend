import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/services/navigation/routes.dart' as router;

class HHAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;

  HHAppBar({@required this.title, @required this.scaffoldKey});

  @override
  _HHAppBarState createState() => _HHAppBarState();
}

class _HHAppBarState extends State<HHAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
        ),
        onPressed: () {
          widget.scaffoldKey.currentState.openDrawer();
        },
      ),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        child: Center(
            child: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        )),
      ),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: router.updateIP()),
      ],
    );
  }
}
