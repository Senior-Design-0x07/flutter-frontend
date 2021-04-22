import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/pin.dart';

class PinOutputResponse extends StatelessWidget {
  final int type;
  final Pin pin;

  PinOutputResponse({@required this.type, this.pin});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 0: //Initial text of nothing
        return Center(
          child: Text(''),
        );
      case 1: // Add Pin
        return Center(child: Text('Add Pin Success'));
      case 2: // Find Pin
        return Column(
          children: [
            Center(child: Text('Found Pin Success')),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: '),
                Text(pin.namedPin),
                SizedBox(
                  width: 10,
                ),
                Text('Pin: '),
                Text(pin.pin),
                SizedBox(
                  width: 10,
                ),
                Text('Type: '),
                Text(pin.type.toString()),
                SizedBox(
                  width: 10,
                ),
                Text('In Use: '),
                Text(pin.inUse.toString()),
              ],
            ),
          ],
        );
      case 3: // Clear Unused
        return Center(child: Text('Clear Unused Pin Success'));
      case 4: // Remove All Pins
        return Center(child: Text('Remove All Pins Success'));
      default:
        return Text('Im TEMPORARY in OUTPUT RESPONSE cause something not "0-4" ');
    }
  }
}
