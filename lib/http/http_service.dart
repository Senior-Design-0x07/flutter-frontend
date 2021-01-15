import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hobby_hub_ui/models/example.dart';
import 'package:http/http.dart';

// HELP with http related things:
// https://flutter.dev/docs/cookbook/networking/fetch-data#2-make-a-network-request

class HttpService {
  final String ipUrl = "http://192.168.7.2:5000/";

  //Example HTTP get request to backend Copy this format for other get/post/put requests
  Future<Example> getExampleData({@required var restURL}) async {
    Response res = await get(ipUrl + restURL);

    if (res.statusCode == 200) {
      return Example.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to grab Example Data');
    }
  }
}
