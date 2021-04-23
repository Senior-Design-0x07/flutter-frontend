import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/log.dart';
import 'package:hobby_hub_ui/models/pin.dart';
import 'package:http/http.dart';

// HELP with http related things:
// https://flutter.dev/docs/cookbook/networking/fetch-data#2-make-a-network-request

class HttpService {
  final int _timeoutDuration = 5;
  final String _usbURL = "http://192.168.7.2:5000";
  String _ipURL = "http://192.168.0.66:5000";
  // String _ipURL = "http://192.168.7.2:5000";

  /*
      Pin Manager Http Requests
  */
  Future<List<Pin>> getPinList({@required var restURL}) async {
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      List<Pin> pinData = [];
      Map<String, dynamic> body = jsonDecode(res.body);
      body.forEach((k, v) => pinData.add(Pin.fromJson(k, v)));
      return pinData;
    } else {
      throw Exception('Error with pin mapped JSON file');
    }
  }

  Future<List<Map<int, String>>> getPhysicalPins(
      {@required var restURL}) async {
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      List<dynamic> physicalPins = jsonDecode(res.body);
      List<Map<int, String>> arrangedPhysicalPins = [];
      for (var i = 0; i < physicalPins.length; i++) {
        try {
          arrangedPhysicalPins.add({physicalPins[i][2]: physicalPins[i][0]});
        } catch (e) {
          arrangedPhysicalPins.add({null: physicalPins[i][0]});
        }
      }
      return arrangedPhysicalPins;
    } else {
      throw Exception('Error with physical pin list');
    }
  }

  // Should be Future<Pin> Eventually
  // It's bugged on backend, with Analog and i2c pins...
  Future<bool> requestNewPin(
      {@required var restURL, @required Map<String, dynamic> postBody}) async {
    var pinName = postBody.values.toList()[0];
    if (pinName != "") {
      Response res = await post("$_ipURL/$restURL", body: postBody)
          .catchError((e) {})
          .timeout(Duration(seconds: _timeoutDuration));
      if (res.statusCode == 200) {
        return jsonDecode(res.body) == 'true' ? true : false;
      } else {
        throw Exception("Failed to request pin: ' " + pinName + " '");
      }
    } else {
      throw Exception('Please enter a valid pin name');
    }
  }

  Future<Pin> getPin(
      {@required var restURL, @required Map<String, dynamic> postBody}) async {
    var pinName = postBody.values.toList()[0];
    if (pinName != "") {
      Response res = await post("$_ipURL/$restURL", body: postBody)
          .catchError((e) {})
          .timeout(Duration(seconds: _timeoutDuration));
      if (res.statusCode == 200) {
        print(postBody[0]);
        return json.decode(res.body) != null
            ? Pin.fromJson(pinName, jsonDecode(res.body))
            : throw Exception("Failed to grab pin: ' " + pinName + " '");
      } else {
        throw Exception("Failed to grab pin: ' " + pinName + " '");
      }
    } else {
      throw Exception('Please enter a valid pin name');
    }
  }

  Future<bool> updatePin(
      {@required var restURL, @required Map<String, dynamic> postBody}) async {
    var pinName = postBody.values.toList()[0];
    var newPhysicalPin = postBody.values.toList()[1];
    if (newPhysicalPin != null) {
      Response res = await post("$_ipURL/$restURL", body: postBody)
          .catchError((e) {})
          .timeout(Duration(seconds: _timeoutDuration));
      if (res.statusCode == 200) {
        return jsonDecode(res.body) == 'true' ? true : false;
      } else {
        throw Exception("Failed to update pin ' " + pinName + " '");
      }
    } else {
      throw Exception('Please select a physical pin');
    }
  }

  // Probably won't need this? but here for now
  Future<bool> clearUnusedPins({@required var restURL}) async {
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) == 'true' ? true : false;
    } else {
      throw Exception('Failed to clear unused pins');
    }
  }

  Future<bool> resetPinConfig({@required var restURL}) async {
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) == 'true' ? true : false;
    } else {
      throw Exception('Failed to reset pin config');
    }
  }

  /*
      Wifi Http Requests
  */
  Future<String> getKnownNetworks(
      {@required var restURL, @required var cmd}) async {
    Response res = await get("$_ipURL/$restURL/$cmd");
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception('Failed to get known networks');
    }
  }

  Future<void> postSelectedNetwork(
      {@required var restURL, @required dynamic postBody}) async {
    Response res = await post("$_ipURL/$restURL", body: postBody);
    if (res.statusCode != 200) {
      throw Exception('Failed to post: $postBody to $restURL');
    }
  }

  Future<String> getClearNetwork(
      {@required var restURL, @required var cmd}) async {
    Response res = await get("$_ipURL/$restURL/$cmd");
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception('Failed to clear networks');
    }
  }

  Future<bool> selectCurrentIP() async {
    Response res;
    _ipURL != _usbURL
        ? res = await get("$_ipURL/api/wifi_request/ping")
            .catchError((e) {})
            .timeout(Duration(seconds: _timeoutDuration))
        : res = await get("$_usbURL/api/wifi_request/ping")
            .catchError((e) {})
            .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      _ipURL != _usbURL
          ? json.decode(res.body) == true
              ? res = await get("$_ipURL/api/wifi_request/get_ip")
                  .catchError((e) {})
                  .timeout(Duration(seconds: _timeoutDuration))
              : _ipURL = _usbURL
          : json.decode(res.body) == true
              ? res = await get("$_usbURL/api/wifi_request/get_ip")
                  .catchError((e) {})
                  .timeout(Duration(seconds: _timeoutDuration))
              : _ipURL = _usbURL;
      if (res.statusCode == 200) {
        var boardIp = json.decode(res.body);
        boardIp != ""
            ? _ipURL = 'http://' + boardIp + ':5000'
            : _ipURL = _usbURL;
        return true;
      } else {
        _ipURL = _usbURL;
        return false;
      }
    } else {
      _ipURL = _usbURL;
      return false;
    }
  }

  /*
      Logging Http Requests
  */
  Future<List<Log>> getBackendLog({@required var restURL}) async {
    print('$_ipURL');
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: 5));
    if (res.statusCode == 200) {
      List<Log> logData = [];
      var body = jsonDecode(res.body);
      body.forEach((var k) => logData.add(Log.fromTxt(k)));
      return logData;
    } else {
      throw Exception("Failed to get log");
    }
  }

  Future<bool> clearBackendLog({@required var restURL}) async {
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: 5));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) == 'true' ? true : false;
    } else {
      throw Exception('Failed to clear log');
    }
  }
}
