import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hobby_hub_ui/models/pin.dart';
import 'package:http/http.dart';

// HELP with http related things:
// https://flutter.dev/docs/cookbook/networking/fetch-data#2-make-a-network-request

class HttpService {
  final String ipUrl = "http://192.168.7.2:5000/";

  Future<List<Pin>> getPinData({@required var restURL}) async {
    Response res = await get(ipUrl + restURL);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Pin> pinData =
          body.map((dynamic item) => Pin.fromJson(item)).toList();
      return pinData;
    } else {
      throw Exception('Failed to grab Pin Data');
    }
  }

}
