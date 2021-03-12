import 'package:flutter/foundation.dart';

class Network {
  final String name;

  Network({@required this.name});

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(name: json['name'] as String);
  }
}
