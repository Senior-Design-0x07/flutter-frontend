import 'package:flutter/material.dart';

class WifiPage extends StatefulWidget {
  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  String ssid = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Center(
            child: Text(
          "WiFi Login",
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
            children: [
              new Card(
                child: Column(
                  children: [
                    new Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        maxLines: 15,
                        readOnly: true,
                        obscureText: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nearby Networks'),
                      ),
                    )
                  ],
                ),
              ),
              new Card(
                child: Column(
                  children: [
                    new Container(
                      margin: const EdgeInsets.all(30),
                      child: TextField(
                        onChanged: (String str) {
                          ssid = str;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'SSID'),
                      ),
                    ),
                    new Container(
                      margin: const EdgeInsets.all(30),
                      child: TextField(
                        onChanged: (String str) {
                          ssid = str;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password'),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Container(
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text('Scan'),
                    ),
                  ),
                  new Container(
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text('Connect'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Go Back to Home Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
