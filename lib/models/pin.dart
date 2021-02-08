import 'package:flutter/foundation.dart';

class Pin {
  final String namedPin;
  final String type;
  final String pin;

  Pin({@required this.namedPin, @required this.type, @required this.pin});

  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
        namedPin: json['name'] as String,
        type: json['type'] as String,
        pin: json['pin'] as String);
  }
}
