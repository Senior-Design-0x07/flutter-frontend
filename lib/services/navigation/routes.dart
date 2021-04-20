import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/home/home.dart';
import 'package:hobby_hub_ui/pin_manager/pinMain.dart';
import 'package:hobby_hub_ui/program_manager/program_main_page.dart';
import 'package:hobby_hub_ui/services/error/undefinedRoute.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/wifi/wifi_main_page.dart';

/* Frontend Page Routes */
const String HomeRoute = '/home';
const String PinManagerRoute = '/pin_manager';
const String ProgramManagerRoute = '/program_manager';
const String WifiRoute = '/wifi';
RouteSettings routeSettings;
final HttpService http = HttpService();

Route<dynamic> getRoutes(RouteSettings settings) {
  routeSettings = settings;
  http.selectCurrentIP();
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => Home());
    case WifiRoute:
      return MaterialPageRoute(builder: (context) => WifiPage());
    case PinManagerRoute:
      return MaterialPageRoute(builder: (context) => PinMain(http: http));
    case ProgramManagerRoute:
      return MaterialPageRoute(builder: (context) => ProgramManagerPage());
    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedRoute(name: settings.name));
  }
}

bool _tempIP = false;
bool _usingIP = false;
bool _connection = true;

void _handleErrors() {
  _connection = false;
}

//Used with App Bar to update correct HTTP service
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
                  Icons.wifi_off,
                  color: Colors.redAccent[700],
                  size: 30.0,
                )
          : Icon(
              Icons.perm_scan_wifi_outlined,
              color: Colors.yellowAccent[400],
              size: 33.0,
            ),
      tooltip: _connection ? 'WiFi' : 'No Comunication With Board',
      onPressed: () async {
        _connection = true;
        _tempIP = await http.selectCurrentIP().catchError((Object error) {
          _handleErrors();
        });
        if (_tempIP != _usingIP && _tempIP != null) {
          _usingIP = _tempIP;
        }
      });
}
