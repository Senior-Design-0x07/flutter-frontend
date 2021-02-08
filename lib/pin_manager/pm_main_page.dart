import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/http/http_service.dart';
import 'package:hobby_hub_ui/models/pin.dart';

class PinManagerPage extends StatefulWidget {
  @override
  _PinManagerPageState createState() => _PinManagerPageState();
}

class _PinManagerPageState extends State<PinManagerPage> {
  HttpService http = new HttpService();

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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            http.getPinData(restURL: 'hello');
                          },
                          child: Text('Grab Pin Data'),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            http.getPinData(restURL: 'hello');
                          },
                          child: Text('Send Pin Data'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 400,
                width: double.infinity,
                child: FutureBuilder(
                  future: http.getPinData(restURL: 'api/pin_manager'),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Pin> pins = snapshot.data;
                      return ListView(
                        
                        children: pins
                            .map(
                              (Pin pin) => ListTile(
                                title: Text(pin.namedPin),
                                subtitle: Text(pin.type),
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text("Pin Info"),
                                    content: Text("Are these settings correct?"),
                                    actions: [
                                      FlatButton(onPressed: () {}, child: Text('Yes')),
                                      FlatButton(onPressed: () {}, child: Text('No')),
                                      FlatButton(onPressed: () {}, child: Text('Change')),
                                    ],
                                  ),
                                  barrierDismissible: false
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}