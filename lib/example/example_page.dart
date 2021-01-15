import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/http/http_service.dart';
import 'package:hobby_hub_ui/models/example.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  String display;
  HttpService https = new HttpService();
  Example example;

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.greenAccent,
        width: 250.0,
        padding: const EdgeInsets.all(10.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              example != null
                  ? Text(
                      _displayText(),
                    )
                  : Text("I AM NULL"),
              RaisedButton(
                  child: new Text("Send"),
                  onPressed: () async {
                    //This returns the data from HTTP get request
                    example =
                        await https.getExampleData(restURL: 'api/Example');
                    //This 'setState' method will rerender our app
                    //Probably not the best way to do this, but it works for now
                    setState(() {});
                  }),
              //This method is another way to show a widget based on Future
              //being returned from the HTTP service method
              _futureWidgetOnButtonPress()
            ]));
  }
  Widget _futureWidgetOnButtonPress() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      if (example != null) {
        return new Text(_displayText());
      }
      return new Text("Shows data after data is recieved");
    });
  }
   //Simple private method to display text from the HTTP future variable
  String _displayText() {
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < 1; i++) {
      sb.write("Title: " + example.title + "\nNumber: ");
      sb.write(example.number);
      sb.write("\n");
    }
    print(sb.toString());
    return sb.toString();
  }

}
