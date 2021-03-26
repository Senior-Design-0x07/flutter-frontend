import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/pin.dart';

import 'mapped_pin.dart';

class PinMapping extends StatefulWidget {
  final List<Pin> mappedPins;
  // Constructor to initialize pin list
  PinMapping({@required this.mappedPins});

  @override
  _PinMappingState createState() => _PinMappingState();
}

class _PinMappingState extends State<PinMapping> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: widget.mappedPins
                .map((Pin pin) => MappedPin(
                      mappedPin: pin,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
