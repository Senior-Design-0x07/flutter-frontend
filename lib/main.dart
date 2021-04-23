import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/navigation/navController.dart';

void main() => runApp(HHApp());

class HHApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HHApp();
  }
}

class _HHApp extends State<HHApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        backgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NavigationController(),
    );
  }
}
