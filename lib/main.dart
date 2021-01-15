import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/example/example_page.dart';
import 'package:hobby_hub_ui/http/http_service.dart';
import 'package:hobby_hub_ui/models/example.dart';

void main() => runApp(HHApp());

class HHApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HHApp();
  }
}

class _HHApp extends State<HHApp> {
  String greetings = '';
  final HttpService http = HttpService();
  Example example;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ExamplePage());
  }

    
}

// // // onPressed: () async {
// // //                         //async function to perform http get

// // //                         final response = await http.get(
// // //                             'http://192.168.7.2:5000/api/Hello'); //getting the response from our backend server script

// // //                         final decoded = json.decode(response.body) as Map<
// // //                             String,
// // //                             dynamic>; //converting it from json to key value pair

// // //                         setState(() {
// // //                           greetings = decoded[
// // //                               'greetings']; //changing the state of our widget on data update
// // //                         });
// // //                       },
