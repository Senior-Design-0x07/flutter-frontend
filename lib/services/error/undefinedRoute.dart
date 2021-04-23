import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/navigation/routes.dart' as router;

class UndefinedRoute extends StatelessWidget {
  final String name;
  
  const UndefinedRoute({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 300),
              Text('ERROR for route: $name '),
              SizedBox(height: 15),
              FlatButton(
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, router.HomeRoute);
                  },
                  child: Text("Home Page"))
            ],
          ),
        ),
      ),
    );
  }
}
