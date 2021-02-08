import 'package:flutter/material.dart';

class ProgramManagerPage extends StatefulWidget {
  @override
  _ProgramManagerPageState createState() => _ProgramManagerPageState();
}

class _ProgramManagerPageState extends State<ProgramManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Center(
            child: Text(
          "Program Manager",
          style: TextStyle(color: Colors.white),
        )),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text("0")),
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(children: [
            Center(child: Text("No Data")),
            SizedBox(height: 15,),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Go Back to Home Page'),
            ),
          ]),
        ),
      ),
    );
  }
}
