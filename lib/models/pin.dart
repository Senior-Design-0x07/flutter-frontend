import 'package:flutter/foundation.dart';

class Pin {
  final String namedPin;
  final int type;
  final String pin;

  Pin({@required this.namedPin, @required this.type, @required this.pin});

  factory Pin.fromJson(String name, Map<String, dynamic> json ) {
    return Pin(
        namedPin: name,
        type: json['type'] as int,
        pin: json['pin'] as String);
  }
}
