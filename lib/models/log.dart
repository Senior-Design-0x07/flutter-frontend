import 'package:flutter/foundation.dart';

class Log {
  final String logInfo;
  final String timeStamp;

  Log({@required this.logInfo, @required this.timeStamp});

  factory Log.fromTxt(String logData) {
    List<String> data = logData.split(" ");
    var timeStamp = data[0] + " " + data[1];
    var logInfo = "";
    for (int i = 2; i < data.length; i++) {
      logInfo += data[i] + " ";
    }
    return Log(logInfo: logInfo, timeStamp: timeStamp);
  }
}
