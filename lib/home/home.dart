import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/services/logging/logMain.dart';

class Home extends StatefulWidget {
  final HttpService http;

  Home({Key key, @required this.http}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/BBboard_layout.png'),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            LogMain(
              http: widget.http,
            )
          ],
        ),
      ),
    );
  }
}
