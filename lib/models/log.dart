import 'package:flutter/foundation.dart';

class Log {
  final String data;
  final String timeStamp;

  Log({@required this.data, @required this.timeStamp});

  factory Log.fromTxt(String logData) {
    List<String> times = DateTime.now().toString().split(" ");
    List<String> days = times[0].split("-");
    String day = days[1] + "-" + days[2];
    String time = times[1].split(".")[0];
    String timeStamp = day + " " + time + ": ";
    return Log(data: logData, timeStamp: timeStamp);
  }
}
