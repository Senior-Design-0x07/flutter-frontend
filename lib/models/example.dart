import 'package:flutter/foundation.dart';

class Example {
  final String title;
  final int number;

  // Constructor
  // {} : signifies 'named parameter values', ie. when initializing this object,
  //you use Hello(title: 'some string', number: somenumber)
  // @required: signifies these parameters must be used when intializing object
  Example({@required this.title, @required this.number});

  //Used in Http Service method to convert the HTTP response JSON from backend,
  //into an actual Dart Object.  This is called Serialization
  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      title: json['string_backend'] as String, 
      number: json['num_backend'] as int
    );
  }
}
