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
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Name: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(pin.namedPin),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Pin: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(pin.pin),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Type: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(pin.type),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Programs: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Flexible(
                    child: pin.usedPrograms.length > 1
                        ? Text("' " + pin.usedPrograms[0] + "' and others...")
                        : Text(pin.usedPrograms[0])),
              ],
            ),
          ],
        );
      case 3: // Clear Unused
        return Center(child: Text('Clear Unused Pin Success'));
      case 4: // Remove All Pins
        return Center(child: Text('Remove All Pins Success'));
      case 5:
        return Center(child: Text('Update Pin Success'));
      default:
        return Center(child: Text('Success'));
    }
  }
}
