import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/log.dart';

class LogItem extends StatelessWidget {
  final Log log;

  LogItem({@required this.log});

  String _getTime() {
    List<String> times = DateTime.now().toString().split(" ");
    List<String> days = times[0].split("-");
    String day = days[1] + "-" + days[2];
    String time = times[1].split(".")[0];

    return day + " " + time + ": ";
  }

  @override
  Widget build(BuildContext context) {
    _getTime();
    return Container(
      margin: const EdgeInsets.all(2.0),
      padding: const EdgeInsets.all(2.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(2.0),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _getTime(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Expanded(child: Text(log.data)),
        ],
      ),
    );
  }
}
