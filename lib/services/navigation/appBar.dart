import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';

class HHAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final HttpService http;

  HHAppBar({@required this.title, @required this.http, this.scaffoldKey});

  @override
  _HHAppBarState createState() => _HHAppBarState();
}

class _HHAppBarState extends State<HHAppBar> {
  bool _usingIP = false;
  bool _connection = false;
  Timer _timer;

  void _checkIfConnected(int numSeconds) {
    if (_timer == null || !_timer.isActive) {
      _timer = Timer.periodic(Duration(seconds: numSeconds), (Timer t) async {
        if (await widget.http.pingBoard() != true) {
          setState(() {
            _connection = false;
          });
        } else if (_connection == false) {
          _selectIP();
        }
      });
    }
  }

  void _selectIP() async {
    _connection = true;
    // _usingIP = false;
    _usingIP = await widget.http.selectCurrentIP().catchError((Object error) {
      _handleErrors();
    });
    _usingIP == null ? _usingIP = false : _usingIP = true;
    if (_usingIP) {
      setState(() {});
    }
  }

  void _handleErrors() {
    setState(() {
      _connection = false;
    });
  }

  Widget updateIP() {
    return IconButton(
        iconSize: 30.0,
        icon: _connection
            ? _usingIP
                ? Icon(
                    Icons.wifi,
                    color: Colors.white,
                    size: 30.0,
                  )
                : Icon(
                    Icons.perm_scan_wifi_outlined,
                    color: Colors.yellowAccent[400],
                    size: 33.0,
                  )
            : Icon(
                Icons.wifi_off,
                color: Colors.redAccent[700],
                size: 30.0,
              ),
        tooltip: _connection ? 'WiFi' : 'No Comunication With Board',
        onPressed: () async {
          _selectIP();
        });
  }

  @override
  void initState() {
    _selectIP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _checkIfConnected(45);
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
            child: updateIP()),
      ],
    );
  }
}
