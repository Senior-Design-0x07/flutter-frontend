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
  bool _connectionError = false;
  String error = "Press WiFi Icon to Reconnect";
  Timer _timer;

  void _checkIfConnected(int numSeconds) {
    if (_timer == null || !_timer.isActive) {
      _timer = Timer.periodic(Duration(seconds: numSeconds), (Timer t) async {
        var _testConnection = await widget.http.pingBoard().catchError((e) {
          _handleErrors(e);
        });
        if (_testConnection == true) {
          _connection = true;
          _selectIP();
        } else if (_testConnection == false) {
          _connection = false;
          _selectIP();
        }
      });
    }
  }

  void _selectIP() async {
    error = "Press WiFi Icon to Reconnect";
    _usingIP = await widget.http.selectCurrentIP().catchError((e) {
      _handleErrors(e);
    });
    if (_usingIP != null) {
      _usingIP == true ? _connectionError = false : _connectionError = true;
      setState(() {});
    } else {
      _usingIP = false;
    }
  }

  void _handleErrors(Object e) {
    setState(() {
      error = e.toString().split(": ")[1];
      _connectionError = true;
      _usingIP = false;
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
        tooltip: _connection
            ? _usingIP
                ? 'WiFi'
                : 'USB Only'
            : 'No Comunication With Board',
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
    _checkIfConnected(30);
    return Column(
      children: [
        AppBar(
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
        ),
        if (_connectionError)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 24.0,
              ),
              Text(
                error,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ],
    );
  }
}
