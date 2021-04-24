import 'package:flutter/foundation.dart';

class Pin {
  final String namedPin;
  final String type;
  final String pin;
  final List<String> usedPrograms;

  Pin(
      {@required this.namedPin,
      @required this.type,
      @required this.pin,
      @required this.usedPrograms});

  factory Pin.fromJson(String name, Map<String, dynamic> json) {
    return Pin(
        namedPin: name,
        type: json['type'] == 1 ? "GPIO" : json['type'] == 2 ? "PWM" : json['type'] == 3 ? "I2C" : json['type'] == 4 ? "ANALOG" : "SPECIAL",
        pin: json['pin'] as String,
        usedPrograms: json['currently_used_programs']
            .map<String>((program) => program as String)
            .toList());
  }
}
