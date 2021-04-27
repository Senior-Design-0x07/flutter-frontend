import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/error/error_service.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';

class WifiPage extends StatefulWidget {
  final HttpService http;

  WifiPage({Key key, @required this.http}) : super(key: key);

  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  String _ssid = "";
  String _password = "";
  bool _scanBtn = false;

  int _buttonSelected = 0;
  bool _cmdSuccess = false;
  bool _connection = true;
  List<String> _connectionError;
  String _httpServiceError;

  Widget _showConnectionErrors() {
    switch (_connectionError[0]) {
      case 'Timeout':
        return HHError(
            title: _connectionError[0] + " Exception",
            message: "Can't Connect",
            type: 0);
      default:
        return HHError(
            title: "Exception",
            message: "A Connection Error Has Ocurred",
            type: 0);
    }
  }

  Widget _showHttpServiceErrors() {
    switch (_httpServiceError.split(":")[0]) {
      case 'Exception': //Generic Exceptions from HTTP_SERVICE
        return HHError(
            title: _httpServiceError.split(":")[0],
            message: _httpServiceError.split("Exception: ")[1],
            type: 0);
      default:
        return HHError(
            title: "Exception", message: "An Error Has Ocurred", type: 0);
    }
  }

  Widget _showButtonErrors() {
    switch (_buttonSelected) {
      case 1: // Scan 
        return HHError(
            title: 'Scan Networks', message: 'Scan Networks Error', type: 1);
      case 2: // Connect
        return HHError(
            title: 'Connect to Network',
            message: 'Could Not Connect',
            type: 1);
      case 3: // Clear Saved
        return HHError(
            title: 'Clear Network',
            message: 'Clear Saved Network Error',
            type: 1);
      default:
        return Text('Im Temporary in Button ERRORS!');
    }
  }

  void _handleErrors(Object error) {
    setState(() {
      error.toString().split("Exception")[0] == "Timeout"
          ? _connection = false
          : _connection = true;
      error.toString().split("Exception")[0] != ""
          ? this._connectionError = error.toString().split("Exception")
          : this._httpServiceError = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              new Card(
                child: Column(
                  children: [
                    Container(
                      height: 365,
                      width: double.infinity,
                      child: _scanBtn
                          ? FutureBuilder(
                              future: widget.http
                                  .getKnownNetworks(
                                      restURL: 'api/wifi_request', cmd: 'scan')
                                  .catchError((Object error) {
                                _handleErrors(error);
                              }),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  List<String> networkList =
                                      snapshot.data.split('\',');
                                  List badData = [];
                                  for (int i = 0; i < networkList.length; i++) {
                                    if (networkList[i].contains('x00')) {
                                      badData.add(i);
                                    }
                                    networkList[i] =
                                        networkList[i].replaceAll('"', '');
                                    networkList[i] =
                                        networkList[i].replaceAll('\'', '');
                                  }
                                  for (int i = badData.length - 1;
                                      i >= 0;
                                      i--) {
                                    networkList.removeAt(badData[i]);
                                  }
                                  return ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: networkList
                                          .map((String network) =>
                                              ListTile(title: Text(network)))
                                          .toList());
                                }
                                return (_httpServiceError == null &&
                                        _connectionError == null)
                                    ? Column(
                                        children: [
                                          Text("Grabbing Data"),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 35.0,
                                          ),
                                          Text("An Error Has Ocurred!"),
                                        ],
                                      );
                              },
                            )
                          : new Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                maxLines: 15,
                                readOnly: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nearby Networks'),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              if (!_connection && _connectionError != null)
                _showConnectionErrors(), // Connection Errors
              if (_httpServiceError != null && _buttonSelected != 0)
                _showHttpServiceErrors(),
              if (!_cmdSuccess &&
                  _buttonSelected != 0 &&
                  _httpServiceError != null)
                _showButtonErrors(), //Button Errors
              new Card(
                child: Column(
                  children: [
                    new Container(
                      margin: const EdgeInsets.all(30),
                      child: TextField(
                        onChanged: (String str) {
                          _ssid = str;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'SSID'),
                      ),
                    ),
                    new Container(
                      margin: const EdgeInsets.all(30),
                      child: TextField(
                        onChanged: (String str) {
                          _password = str;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password'),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Container(
                    child: RaisedButton(
                      onPressed: () {
                        _httpServiceError = null;
                        setState(() {
                          _scanBtn = true;
                          _buttonSelected = 1;
                        });
                      },
                      child: Text('Scan'),
                    ),
                  ),
                  new Container(
                    child: RaisedButton(
                      onPressed: () async {
                        _httpServiceError = null;
                        await widget.http.postSelectedNetwork(
                            restURL: 'api/wifi_request',
                            postBody: {
                              "ssid": _ssid,
                              "password": _password
                            }).catchError((Object error) {
                          _handleErrors(error);
                        });
                        setState(() {
                          _buttonSelected = 2;
                        });
                      },
                      child: Text('Connect'),
                    ),
                  ),
                  new Container(
                    child: RaisedButton(
                      onPressed: () async {
                        _httpServiceError = null;
                        await widget.http
                            .getClearNetwork(
                                restURL: 'api/wifi_request', cmd: 'clear')
                            .catchError((Object error) {
                          _handleErrors(error);
                        });
                        setState(() {
                          _buttonSelected = 3;
                        });
                      },
                      child: Text('Clear Saved Network'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
