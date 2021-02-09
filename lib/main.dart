import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/pin_manager/pm_main_page.dart';
import 'package:hobby_hub_ui/program_manager/program_main_page.dart';
import 'package:hobby_hub_ui/wifi/wifi_main_page.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          leading: Icon(Icons.menu),
          title: Center(
              child: Text(
            "Hobby Hub Home",
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
        body: Column(
          children: [
            SizedBox(height: 10),
            Builder(
              builder: (context) => Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      padding: EdgeInsets.all(15),
                      child: Text('Pin Manager'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PinManagerPage()));
                      },
                    ),
                    SizedBox(width: 15),
                    RaisedButton(
                      padding: EdgeInsets.all(15),
                      child: Text('Program Manager'),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ProgramManagerPage()));
                      },
                    ),
                    SizedBox(width: 15),
                    RaisedButton(
                      padding: EdgeInsets.all(15),
                      child: Text('WiFi Login'),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => WifiPage()));
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
