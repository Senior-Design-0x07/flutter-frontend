import 'package:flutter/material.dart';

class HHError extends StatelessWidget {
  final String message;
  final String title;

  const HHError({Key key, @required this.title, @required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title, style: TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold,),),
          SizedBox(
            width: 15,
          ),
          Text(message, style: TextStyle(color: Colors.red, fontSize: 15.0,),),
          SizedBox(
            width: 30,
          ),
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 35.0,
          )
        ],
      ),
    );
  }
}
