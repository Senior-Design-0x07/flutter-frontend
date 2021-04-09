import 'package:flutter/foundation.dart';

class Log {
  final String data;

  Log({
    @required this.data,
  });

  factory Log.fromTxt(String logData) {
    return Log(
        data: logData);
  }
}
