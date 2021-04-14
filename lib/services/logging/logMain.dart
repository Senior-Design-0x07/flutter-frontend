import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/error/error_service.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/models/log.dart';
import 'logItem.dart';
import 'package:hobby_hub_ui/services/navigation/routes.dart' as router;

class LogMain extends StatefulWidget {
  @override
  _LogMainState createState() => _LogMainState();
}

class _LogMainState extends State<LogMain> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final HttpService http = HttpService();
  List<Log> logData = [];
  bool cmdSuccess = true;
  bool clearButton = false;
  bool connection = true;
  List<String> connectionError;
  String httpServiceError;
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
    switch (connectionError[0]) {
      case 'Timeout':
        return HHError(
            title: connectionError[0] + " Exception",
            message: "Can't Connect",
            type: 0);
      default:
        return HHError(
            title: "Exception",
            message: "A connection error has ocurred",
            type: 0);
    }
  }

  Widget _showHttpServiceErrors() {
    switch (httpServiceError.split(":")[0]) {
      case 'Exception': //Generic Exceptions from HTTP_SERVICE
        return HHError(
            title: httpServiceError.split(":")[0],
            message: httpServiceError.split("Exception: ")[1],
            type: 0);
      default:
        return HHError(
            title: "Exception", message: "An error has ocurred", type: 0);
    }
  }

  Widget _showClearLogError() {
    cmdSuccess = true;
    return HHError(
        title: 'Clear Log', message: 'Log could not be cleared', type: 1);
  }

  void _handleErrors(Object error) {
    if (connection || httpServiceError != null || !cmdSuccess)
      setState(() {
        error.toString().split("Exception")[0] == "Timeout"
            ? connection = false
            : connection = true;
        error.toString().split("Exception")[0] != ""
            ? this.connectionError = error.toString().split("Exception")
            : this.httpServiceError = error.toString();
      });
  }

  Future<void> _refresh() {
    return http.getBackendLog(restURL: 'api/logging/get').then((_logData) {
      connection = true;
      if (!clearButton) {
        if (_logData.isNotEmpty) {
          setState(() {
            logData = _logData;
          });
        }
      } else {
        setState(() {
          logData.clear();
          clearButton = false;
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
    if (connection) _grabLogPeriodically(30);
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
                              clearButton = true;
                              if (connection) {
                                cmdSuccess = await http
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
                              clearButton = false;
                              cmdSuccess = true;
                              _refreshIndicatorKey.currentState.show();
                            }),
                      ]),
                    ),
                  ],
                ),
              ),
              if (!connection) _showConnectionErrors(), // Connection Errors
              if (httpServiceError != null)
                _showHttpServiceErrors(), //Http Service Errors
              if (!cmdSuccess) _showClearLogError(),
              Expanded(
                child: Card(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refresh,
                    child: logData.isNotEmpty
                        ? ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: logData
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
