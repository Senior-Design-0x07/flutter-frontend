import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/pin.dart';

class PinOutputResponse extends StatelessWidget {
  final int type;
  final Pin pin;
  final bool cmdSuccess;

  PinOutputResponse({@required this.type, this.cmdSuccess, this.pin});

  @override
  Widget build(BuildContext context) {
    if (cmdSuccess) {
      switch (type) {
        case 1: // Add Pin
          return Center(child: Text('Add Pin Success'));
          break;
        case 2: // Find Pin
                  return Center(child: Text('Found Pin Success'));

          break;
        case 3: // Clear Unused
          return Center(child: Text('Clear Unused Pin Success'));

          break;
        case 4: // Remove All Pins
          return Center(child: Text('Remove All Pins Success'));

          break;
      }
    } else {
      switch (type) {
        case 1: //Add Pin
          return Center(child: Text('Add Pin Fail'));
          break;
        case 2: // Find Pin
          return Center(child: Text('Add Pin Fail'));
          break;
        case 3: // Clear Unused Pins
          return Center(child: Text('Add Pin Fail'));
          break;
        case 4: // Remove All Pins
          return Center(child: Text('Add Pin Fail'));
          break;
      }
    }
  }
}
