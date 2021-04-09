import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/models/pin.dart';

class MappedPin extends StatefulWidget {
  final Pin mappedPin;
  // Constructor to initialize pin list
  MappedPin({@required this.mappedPin});

  @override
  _MappedPinState createState() => _MappedPinState();
}

class _MappedPinState extends State<MappedPin> {
  final HttpService http = HttpService();

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
          Text("  Type: "),
          Text(
            widget.mappedPin.type.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("  In Use: "),
          Text(
            widget.mappedPin.inUse.toString(),
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
                        Navigator.of(context).pop();
                      },
                      child: Text('Change')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Remove')),
                ],
              ),
          barrierDismissible: true),
    );
  }
}
