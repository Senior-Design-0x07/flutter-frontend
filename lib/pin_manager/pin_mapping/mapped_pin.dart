import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/http_service.dart';
import 'package:hobby_hub_ui/models/pin.dart';

class MappedPin extends StatefulWidget {
  final Pin mappedPin;
  // Constructor to initialize pin list
  MappedPin({@required this.mappedPin});

  @override
  _MappedPinState createState() => _MappedPinState();
}

class _MappedPinState extends State<MappedPin> {
  HttpService http = HttpService();
  bool pressed = false;
  bool foundRequestedPin = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.mappedPin.namedPin),
      subtitle: Row(
        children: [
          Text("Pin: "),
          Text(
            widget.mappedPin.pin,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(" Type: "),
          Text(
            widget.mappedPin.type.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Pin Info"),
                content: Text("Are these settings correct?"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        http.resetPinConfig(
                            restURL: 'api/pin_manager/reset_config');
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text('CLEAR')),
                  FlatButton(
                      onPressed: () async {
                        await http.getPin(
                            restURL: 'api/pins/get_pin',
                            pinName: widget.mappedPin.namedPin);
                        Navigator.of(context).pop();
                        setState(() {
                          pressed = true;
                        });
                      },
                      child: Text('GET PIN')),
                  FlatButton(
                      onPressed: () async {
                         foundRequestedPin = await http.requestPin(
                            restURL: 'api/pins/request_pin', pinName: 'sdfghj');
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text('REQUEST')),
                ],
              ),
          barrierDismissible: false),
    );
  }
}
