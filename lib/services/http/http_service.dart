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
  final int _timeoutDuration = 10;
  final String _usbURL = "http://192.168.7.2:5000";
  String _ipURL = "http://192.168.7.2:5000";
  // String _ipURL = "http://192.168.0.66:5000";

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

  Future<List<Map<String, String>>> getPhysicalPins(
      {@required var restURL}) async {
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      List<dynamic> physicalPins = jsonDecode(res.body);
      List<Map<String, String>> arrangedPhysicalPins = [];
      for (var i = 0; i < physicalPins.length; i++) {
        try {
          arrangedPhysicalPins.add({
            (physicalPins[i][2] == 1
                ? "GPIO"
                : physicalPins[i][2] == 2
                    ? "PWM"
                    : physicalPins[i][2] == 3
                        ? "I2C"
                        : physicalPins[i][2] == 4
                            ? "ANALOG"
                            : "SPECIAL"): physicalPins[i][0]
          });
        } catch (e) {
          arrangedPhysicalPins.add({null: physicalPins[i][0]});
        }
      }
      return arrangedPhysicalPins;
    } else {
      throw Exception('Error with physical pin list');
    }
  }

  Future<bool> requestNewPin(
      {@required var restURL, @required Map<String, dynamic> postBody}) async {
    var pinName = postBody.values.toList()[0];
    if (pinName != "") {
      Response res = await post("$_ipURL/$restURL", body: postBody)
          .catchError((e) {})
          .timeout(Duration(seconds: _timeoutDuration));
      if (res.statusCode == 200) {
        return jsonDecode(res.body) == true
            ? true
            : throw Exception("Pin ' " + pinName + " ' is already mapped");
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
        return jsonDecode(res.body) == true ? true : false;
      } else {
        throw Exception("Failed to update pin ' " + pinName + " '");
      }
    } else {
      throw Exception('Please select a physical pin');
    }
  }

  Future<bool> clearUnusedPins({@required var restURL}) async {
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) == true ? true : false;
    } else {
      throw Exception('Failed to clear unused pins');
    }
  }

  Future<bool> resetPinConfig({@required var restURL}) async {
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) == true ? true : false;
    } else {
      throw Exception('Failed to reset pin config');
    }
  }

  /*
      Program Manager Requests
  */
  Future<String> getProgramList({@required var restURL}) async {
    Response res = await get("$_ipURL/$restURL")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception('Failed to grab indicated list');
    }
  }

  Future<void> postProgramCommand(
      {@required var restURL, @required dynamic postBody}) async {
    Response res = await post("$_ipURL/$restURL", body: postBody)
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode != 200) {
      throw Exception('Failed to post: $postBody to $restURL');
    }
  }

  /*
      Wifi Http Requests
  */
  Future<String> getKnownNetworks(
      {@required var restURL, @required var cmd}) async {
    Response res = await get("$_ipURL/$restURL/$cmd")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception('Failed to get known networks');
    }
  }

  Future<void> postSelectedNetwork(
      {@required var restURL, @required dynamic postBody}) async {
    Response res = await post("$_ipURL/$restURL", body: postBody)
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode != 200) {
      throw Exception("Failed to connect to ' " + postBody["ssid"] + " '");
    }
  }

  Future<void> getClearNetwork(
      {@required var restURL, @required var cmd}) async {
    Response res = await get("$_ipURL/$restURL/$cmd")
        .catchError((e) {})
        .timeout(Duration(seconds: _timeoutDuration));
    if (res.statusCode != 200) {
      throw Exception('Failed to clear saved networks');
    }
  }

  Future<bool> selectCurrentIP() async {
    Response res;
    print(_ipURL);
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

  Future<bool> pingBoard() async {
    if (_ipURL != _usbURL) {
      Response res = await get("$_ipURL/api/wifi_request/ping")
          .catchError((e) {
            print("hey1");
          })
          .timeout(Duration(seconds: _timeoutDuration))
          .catchError((e) {
            print("hey2");
          });
      return res != null
          ? res.statusCode == 200
              ? true
              : false
          : false;
    } else {
      Response res = await get("$_usbURL/api/wifi_request/ping")
          .catchError((e) {})
          .timeout(Duration(seconds: _timeoutDuration))
          .catchError((e) {});
      return res != null
          ? res.statusCode == 200
              ? true
              : false
          : false;
    }
  }

  /*
      Logging Http Requests
  */
  Future<List<Log>> getBackendLog({@required var restURL}) async {
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
      return jsonDecode(res.body) == true ? true : false;
    } else {
      throw Exception('Failed to clear log');
    }
  }
}
