import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/log.dart';

class LogItem extends StatelessWidget {
  final Log log;

  LogItem({@required this.log});

  @override
  Widget build(BuildContext context) {
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
                  log.timeStamp,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Expanded(child: Text(log.logInfo)),
        ],
      ),
    );
  }
}
