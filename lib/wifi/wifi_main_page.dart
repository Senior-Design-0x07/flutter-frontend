import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/http_service.dart';
import 'package:hobby_hub_ui/services/navigation/appBar.dart';
import 'package:hobby_hub_ui/services/navigation/navDrawer.dart';

class WifiPage extends StatefulWidget {
  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  final HttpService http = new HttpService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  String ssid = "";
  String password = "";
  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: HHAppBar(title: 'WiFi', scaffoldKey: _scaffoldKey)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              new Card(
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      child: buttonPressed
                          ? FutureBuilder(
                              future: http.getKnownNetworks(
                                  restURL: 'api/wifi_request'),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  List<String> networkList =
                                      snapshot.data.split('\',');
                                  List badData = [];
                                  for (int i = 0; i < networkList.length; i++) {
                                    if (networkList[i].contains('x00')) {
                                      badData.add(i);
                                    }
                                    networkList[i] =
                                        networkList[i].replaceAll('"', '');
                                    networkList[i] =
                                        networkList[i].replaceAll('\'', '');
                                  }
                                  for (int i = badData.length - 1;
                                      i >= 0;
                                      i--) {
                                    networkList.removeAt(badData[i]);
                                  }
                                  return ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: networkList
                                          .map((String network) =>
                                              ListTile(title: Text(network)))
                                          .toList());
                                }
                                return Column(
                                  children: [
                                    Text("Grabbing Data"),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Center(child: CircularProgressIndicator()),
                                  ],
                                );
                              },
                            )
                          : new Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                maxLines: 15,
                                readOnly: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nearby Networks'),
                              ),
                            ),
                    ),
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
                          password = str;
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
                      onPressed: () {
                        buttonPressed = true;
                        setState(() {});
                      },
                      child: Text('Scan'),
                    ),
                  ),
                  new Container(
                    child: RaisedButton(
                      onPressed: () async {
                        await http.postSelectedNetwork(
                            restURL: 'api/wifi_request',
                            postBody: {"ssid": ssid, "password": password});
                        setState(() {});
                      },
                      child: Text('Connect'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
