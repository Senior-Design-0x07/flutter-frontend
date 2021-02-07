import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/example/example_page.dart';
import 'package:hobby_hub_ui/http/http_service.dart';

void main() => runApp(HHApp());

class HHApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HHApp();
  }
}

class _HHApp extends State<HHApp> {
  final HttpService http = HttpService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ExamplePage());
  }
}
