import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/http/http_service.dart';
import 'package:hobby_hub_ui/models/pin.dart';
import 'package:hobby_hub_ui/pin_manager/pin_mapping/pinMappingList.dart';

class PinMain extends StatelessWidget {
  final HttpService http = new HttpService();
  final Pin _pin = new Pin(namedPin: 'Null', type: 5, pin: 'Null');
  final bool pressed = false;

  @override
  Widget build(BuildContext context) {
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
              if (pressed)
                Column(
                  children: [
                    Text('PIN NAME: ' + _pin.namedPin != null
                        ? _pin.namedPin
                        : 'NULL'),
                    Text('PIN: ' + _pin.pin != null ? _pin.pin : 'NULL'),
                    Text(_pin.type != null ? _pin.type as String : 'NULL987'),
                  ],
                ),
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
              Container(
                height: 400,
                width: double.infinity,
                child: FutureBuilder(
                  future: http.getPinData(
                      restURL: 'api/pin_manager/grab_used_pins'),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Pin> pinsList = snapshot.data;
                      return PinMapping(mappedPins: pinsList);
                    }
                    return Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Text("Grabbing Data"),
                        SizedBox(
                          height: 20,
                        ),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
