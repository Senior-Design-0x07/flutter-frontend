import 'package:flutter/foundation.dart';

class Pin {
  final String namedPin;
  final int type;
  final String pin;
  final bool inUse;

  Pin(
      {@required this.namedPin,
      @required this.type,
      @required this.pin,
      @required this.inUse});

  factory Pin.fromJson(String name, Map<String, dynamic> json) {
    return Pin(
        namedPin: name, 
        type: json['type'] as int, 
        pin: json['pin'] as String,
        inUse: json['in_use'] as bool);
  }
}
