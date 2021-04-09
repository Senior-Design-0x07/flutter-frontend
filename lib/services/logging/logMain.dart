import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/models/log.dart';
import 'logItem.dart';

class LogMain extends StatefulWidget {
  @override
  _LogMainState createState() => _LogMainState();
}

// import 'dart:async';
// main() {
//   const oneSec = const Duration(seconds:1);
//   new Timer.periodic(oneSec, (Timer t) => print('hi!'));
// }
class _LogMainState extends State<LogMain> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final HttpService http = HttpService();
  List<Log> logData = [];
  bool cmdSuccess = false;

  Future<void> _refresh() {
    return http.getBackendLog(restURL: 'api/logging/get').then((_logData) {
      setState(() {
        // connection = true;
        logData = _logData;
      });
    }).catchError((Object error) {
      // _handleErrors(error);
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
                              cmdSuccess = await http
                                  .clearBackendLog(restURL: "api/logging/clear")
                                  .catchError((Object user) {
                                // _handleErrors();
                              });
                              _refresh();
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
                              _refreshIndicatorKey.currentState.show();
                            }),
                      ]),
                    ),
                  ],
                ),
              ),
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
