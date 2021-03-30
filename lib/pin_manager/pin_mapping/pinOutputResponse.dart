import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/pin.dart';

class PinOutputResponse extends StatelessWidget {
  final int type;
  final Pin pin;

  PinOutputResponse({@required this.type, this.pin});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("IT WORKED WITH REQUEST NEW PIN"),
        // if (selectedPin != null)
        //       Column(
        //         children: [
        //           SizedBox(
        //             height: 15,
        //           ),
        //           Center(
        //             child: Text("Get Pin"),
        //           ),
        //           SizedBox(
        //             height: 10,
        //           ),
        //           Center(child: MappedPin(mappedPin: selectedPin)),
        //         ],
        //       )
        //     else
        //       Column(
        //         children: [Center(child: Text('No Pin Found'))],
        //       )
        );
  }
}
