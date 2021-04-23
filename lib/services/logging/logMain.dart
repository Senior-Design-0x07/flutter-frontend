import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/error/error_service.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/models/log.dart';
import 'logItem.dart';
import 'package:hobby_hub_ui/services/navigation/routes.dart' as router;

class LogMain extends StatefulWidget {
  final HttpService http;

  LogMain({@required this.http});

  @override
  _LogMainState createState() => _LogMainState();
}

class _LogMainState extends State<LogMain> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<Log> _logData = [];
  bool _cmdSuccess = true;
  bool _clearButton = false;
  bool _connection = true;
  List<String> _connectionError;
  String _httpServiceError;
  Timer _timer;

  void _grabLogPeriodically(int numSeconds) {
    if (_timer == null || !_timer.isActive) {
      _timer = Timer.periodic(Duration(seconds: numSeconds), (Timer t) {
        if (router.routeSettings.name == router.HomeRoute) {
          _refresh();
        }
      });
    }
  }

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
            message: "A _connection error has ocurred",
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
            title: "Exception", message: "An error has ocurred", type: 0);
    }
  }

  Widget _showClearLogError() {
    _cmdSuccess = true;
    return HHError(
        title: 'Clear Log', message: 'Log could not be cleared', type: 1);
  }

  void _handleErrors(Object error) {
    if (_connection || _httpServiceError != null || !_cmdSuccess)
      setState(() {
        error.toString().split("Exception")[0] == "Timeout"
            ? _connection = false
            : _connection = true;
        error.toString().split("Exception")[0] != ""
            ? this._connectionError = error.toString().split("Exception")
            : this._httpServiceError = error.toString();
      });
  }

  Future<void> _refresh() {
    return widget.http.getBackendLog(restURL: 'api/logging/get').then((__logData) {
      _connection = true;
      if (!_clearButton) {
        if (__logData.isNotEmpty) {
          setState(() {
            _logData = __logData;
          });
        } else {
          setState(() {
            _connectionError = null;
            _httpServiceError = null;
          });
        }
      } else {
        setState(() {
          _logData.clear();
          _clearButton = false;
        });
      }
    }).catchError((Object error) {
      _handleErrors(error);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connection) _grabLogPeriodically(60);
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(1.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.grey[300],
        child: Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(3.0),
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Column(
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Logging Output",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(children: [
                        IconButton(
                            iconSize: 30.0,
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.red,
                              size: 30.0,
                            ),
                            tooltip: 'Clear Log',
                            onPressed: () async {
                              _clearButton = true;
                              if (_connection) {
                                _cmdSuccess = await widget.http
                                    .clearBackendLog(
                                        restURL: "api/logging/clear")
                                    .catchError((Object error) {
                                  _handleErrors(error);
                                });
                                _refresh();
                              }
                            }),
                        IconButton(
                            iconSize: 30.0,
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.amber,
                              size: 30.0,
                            ),
                            tooltip: 'Refresh',
                            onPressed: () {
                              _clearButton = false;
                              _cmdSuccess = true;
                              _refreshIndicatorKey.currentState.show();
                            }),
                      ]),
                    ),
                  ],
                ),
              ),
              if (!_connection) _showConnectionErrors(), // Connection Errors
              if (_httpServiceError != null)
                _showHttpServiceErrors(), //Http Service Errors
              if (!_cmdSuccess) _showClearLogError(),
              Expanded(
                child: Card(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refresh,
                    child: _logData.isNotEmpty
                        ? ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: _logData
                                .map((Log log) => LogItem(log: log))
                                .toList(),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text("No Logs Yet")),
                            )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
