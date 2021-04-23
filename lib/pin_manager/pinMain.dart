import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/pin_manager/pin_mapping/pinMappingList.dart';

class PinMain extends StatelessWidget {
  final HttpService http;

  PinMain({Key key, @required this.http}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: Colors.white,
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
                Container(
                    height: 350,
                    width: double.infinity,
                    child: PinMapping(http: http)),
              ],
            ),
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      return Scaffold(
        backgroundColor: Colors.white,
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
                Container(
                    height: 350,
                    width: double.infinity,
                    child: PinMapping(
                      http: http,
                    )),
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
