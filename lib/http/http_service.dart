import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hobby_hub_ui/models/pin.dart';
import 'package:http/http.dart';

// HELP with http related things:
// https://flutter.dev/docs/cookbook/networking/fetch-data#2-make-a-network-request

class HttpService {
  final String ipUrl = "http://192.168.1.179:5000";

  Future<List<Pin>> getPinData({@required var restURL}) async {
    Response res = await get("$ipUrl/$restURL");
    if (res.statusCode == 200) {
      List<Pin> pinData = [];
      Map<String, dynamic> body = jsonDecode(res.body);
      body.forEach((k, v) => pinData.add(Pin.fromJson(k, v)));
      return pinData;
    } else {
      throw Exception('Failed to grab Pin Data');
    }
  }

  Future<String> getKnownNetworks({@required var restURL}) async {
    Response res = await get("$ipUrl/$restURL");
    print(res.body);
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception('Failed to grab Pin Data');
    }
  }

  Future<String> postSelectedNetwork(
      {@required var restURL, @required dynamic postBody}) async {
    Response res = await post("$ipUrl/$restURL", body: postBody);
    print(res.body);
    if (res.statusCode == 200) {
      return "What is up";
    } else {
      throw Exception('Failed to post: $postBody to $restURL');
    }
  }
}
