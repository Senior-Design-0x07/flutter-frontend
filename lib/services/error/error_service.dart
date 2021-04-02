import 'package:flutter/material.dart';

class HHError extends StatelessWidget {
  final String message;
  final String title;
  final int type; // 0 = red, 1 = yellow triangle

  const HHError(
      {Key key,
      @required this.title,
      @required this.message,
      @required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: type == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 35.0,
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.yellow[800],
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.yellow[800],
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Icon(
                    Icons.report_problem_outlined,
                    color: Colors.yellow[800],
                    size: 35.0,
                  )
                ],
              ),
      ),
    );
  }
}
