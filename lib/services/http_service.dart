import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/network.dart';
import 'package:hobby_hub_ui/models/pin.dart';
import 'package:http/http.dart';

// HELP with http related things:
// https://flutter.dev/docs/cookbook/networking/fetch-data#2-make-a-network-request

class HttpService {
  final String ipUrl = "http://192.168.7.2:5000";

  /*
      Pin Manager Http Requests
  */
  Future<List<Pin>> getPinList({@required var restURL}) async {
    Response res = await get("$ipUrl/$restURL").timeout(Duration(seconds: 3));
    if (res.statusCode == 200) {
      List<Pin> pinData = [];
      Map<String, dynamic> body = jsonDecode(res.body);
      body.forEach((k, v) => pinData.add(Pin.fromJson(k, v)));
      return pinData;
    } else {
      throw Exception('Failed to grab Pin Data');
    }
  }

  // Should be Future<Pin>? I think
  Future<bool> requestNewPin(
      {@required var restURL,
      @required String pinName,
      @required int pinType}) async {
    Response res = await get("$ipUrl/$restURL/$pinName/$pinType")
        .timeout(Duration(seconds: 3));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) == 'true' ? true : false;
    } else {
      throw Exception('Failed to request Pin: ' + pinName);
    }
  }

  Future<Pin> getPin({@required var restURL, @required String pinName}) async {
    Response res =
        await get("$ipUrl/$restURL/$pinName/0").timeout(Duration(seconds: 3));
    if (res.statusCode == 200) {
      return json.decode(res.body) != null
          ? Pin.fromJson(pinName, jsonDecode(res.body))
          : null;
    } else {
      throw Exception('Failed to grab Pin: ' + pinName);
    }
  }

  Future<bool> clearUnusedPins({@required var restURL}) async {
    Response res = await get("$ipUrl/$restURL").timeout(Duration(seconds: 3));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) == 'true' ? true : false;
    } else {
      throw Exception('Failed to Clear Unused Pins');
    }
  }

  Future<bool> resetPinConfig({@required var restURL}) async {
    Response res = await get("$ipUrl/$restURL").timeout(Duration(seconds: 3));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) == 'true' ? true : false;
    } else {
      throw Exception('Failed to Reset Pin Config');
    }
  }

  /*
      Wifi Http Requests
  */
  Future<List<Network>> getScannedNetworks({@required var restURL}) async {
    Response res = await get("$ipUrl/$restURL");
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Network> networkData =
          body.map((dynamic item) => Network.fromJson(item)).toList();
      return networkData;
    } else {
      throw Exception('Failed to grab Networks');
    }
  }

  Future<String> postSelectedNetwork(
      {@required var restURL, @required dynamic postBody}) async {
    Response res = await post("$ipUrl/$restURL", body: postBody);
    if (res.statusCode == 200) {
      return "What is up";
    } else {
      throw Exception('Failed to post: $postBody to $restURL');
    }
  }
}
