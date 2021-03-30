import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hobby_hub_ui/services/http_service.dart';
import 'package:hobby_hub_ui/pin_manager/pin_mapping/pinMappingList.dart';

class PinMain extends StatelessWidget {
  final HttpService http = new HttpService();

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Scaffold.of(context).openDrawer();
            },
          ),
          title: Center(
              child: Text(
            "Pin Manager",
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
                  child: Center(child: Text("0")),
                ))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/BBboard_layout.png'),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Go Back to Home Page'),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                    Icon(
                      Icons.audiotrack,
                      color: Colors.green,
                      size: 30.0,
                    ),
                    Icon(
                      Icons.beach_access,
                      color: Colors.blue,
                      size: 36.0,
                    ),
                  ],
                ),
                Container(
                    height: 400, width: double.infinity, child: PinMapping()),
              ],
            ),
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Scaffold.of(context).openDrawer();
            },
          ),
          title: Center(
              child: Text(
            "Pin Manager",
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
                  child: Center(child: Text("0")),
                ))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/BBboard_layout.png'),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Go Back to Home Page'),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 400,
                    width: double.infinity,
                    child: PinMapping()),
              ],
            ),
          ),
        ),
      );
    } else {
      return Text("I am IOS");
    }
  }
}
