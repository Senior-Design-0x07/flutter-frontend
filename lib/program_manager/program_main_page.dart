import 'package:flutter/material.dart';

import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/services/navigation/appBar.dart';
import 'package:hobby_hub_ui/services/navigation/navDrawer.dart';

class ProgramManagerPage extends StatefulWidget {
  @override
  _ProgramManagerPageState createState() => _ProgramManagerPageState();
}

class _ProgramManagerPageState extends State<ProgramManagerPage> {
  final HttpService http = new HttpService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: HHAppBar(title: 'Program Manager', scaffoldKey: _scaffoldKey)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.grey.shade300)),
                child: Builder(
                  builder: (context) => InkWell(
                    splashColor: Colors.green.withAlpha(80),
                    onTap: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Program Info"),
                              content: Text("What would you like to do?"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Start')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Stop')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Restart')),
                              ],
                            ),
                        barrierDismissible: false),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(child: Text("User Program 1")),
                    ),
                  ),
                )),
            Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.grey.shade300)),
                child: Builder(
                  builder: (context) => InkWell(
                    splashColor: Colors.green.withAlpha(80),
                    onTap: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Program Info"),
                              content: Text("What would you like to do?"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Start')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Stop')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Restart')),
                              ],
                            ),
                        barrierDismissible: false),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(child: Text("User Program 2")),
                    ),
                  ),
                )),
            Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.grey.shade300)),
                child: Builder(
                  builder: (context) => InkWell(
                    splashColor: Colors.green.withAlpha(80),
                    onTap: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Program Info"),
                              content: Text("What would you like to do?"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Start')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Stop')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Restart')),
                              ],
                            ),
                        barrierDismissible: false),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(child: Text("User Program 3")),
                    ),
                  ),
                )),
            SizedBox(height: 15),
            Container(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                      onPressed: () {}, child: Text("Upload Programs"))),
            ),
          ]),
        ),
      ),
    );
  }
}
