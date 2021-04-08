import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/home/home.dart';
import 'package:hobby_hub_ui/pin_manager/pinMain.dart';
import 'package:hobby_hub_ui/program_manager/program_main_page.dart';
import 'package:hobby_hub_ui/services/error/undefinedRoute.dart';
import 'package:hobby_hub_ui/wifi/wifi_main_page.dart';

/* Frontend Page Routes */
const String HomeRoute = '/home';
const String PinManagerRoute = '/pin_manager';
const String ProgramManagerRoute = '/program_manager';
const String WifiRoute = '/wifi';
//Hello

Route<dynamic> getRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => Home());
    case WifiRoute:
      return MaterialPageRoute(builder: (context) => WifiPage());
    case PinManagerRoute:
      return MaterialPageRoute(builder: (context) => PinMain());
    case ProgramManagerRoute:
      return MaterialPageRoute(builder: (context) => ProgramManagerPage());
    default:
      return MaterialPageRoute(builder: (context) => UndefinedRoute(name: settings.name));
  }
}
