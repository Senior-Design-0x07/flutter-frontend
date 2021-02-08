import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/pin_manager/pm_main_page.dart';
import 'package:hobby_hub_ui/test_page.dart';

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
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.green,
          backgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('My First App'),
          ),
          body: Builder(
            builder: (context) => Center(
              child: Column(
                children: [
                  FlatButton(
                    child: Text('Pin Manager Page'),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PinManagerPage()));
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
