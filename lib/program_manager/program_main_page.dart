import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/program.dart';
import 'package:hobby_hub_ui/services/error/error_service.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';

class ProgramManagerPage extends StatefulWidget {
  final HttpService http;

  ProgramManagerPage({Key key, @required this.http}) : super(key: key);

  @override
  _ProgramManagerPageState createState() => _ProgramManagerPageState();
}

class _ProgramManagerPageState extends State<ProgramManagerPage> {
  List<Program> _runningPrograms = List<Program>.empty(growable: true);
  List<Program> _pausedPrograms = List<Program>.empty(growable: true);
  final GlobalKey<RefreshIndicatorState> _runningRefreshKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _pausedRefreshKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _connection = true;
  List<String> _connectionError;
  String _httpServiceError;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runningRefreshKey.currentState.show();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pausedRefreshKey.currentState.show();
    });
    super.initState();
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
            type: 1);
      default:
        return HHError(
            title: "Exception", message: "An Error Has Ocurred", type: 0);
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

  // refresh indicator method - get running programs list for ListView widget
  Future<void> _refreshRunning() async {
    _httpServiceError = null;
    await widget.http
        .getProgramList(restURL: 'api/program_manager/running_programs')
        .then((__runningPrograms) {
      if (__runningPrograms.isNotEmpty || _runningPrograms.length > 0) {
        _runningPrograms.clear();
        _runningPrograms = __runningPrograms;
        setState(() {});
      } else if (!_connection) {
        setState(() {});
        _connection = true;
      }
    }).catchError((Object error) {
      _handleErrors(error);
    });
  }

  // refresh indicator method - get paused programs list for ListView widget
  Future<void> _refreshPaused() async {
    _httpServiceError = null;
    await widget.http
        .getProgramList(restURL: 'api/program_manager/paused_programs')
        .then((__pausedPrograms) {
      if (__pausedPrograms.isNotEmpty || _pausedPrograms.length > 0) {
        _pausedPrograms.clear();
        _pausedPrograms = __pausedPrograms;
        setState(() {});
      } else if (!_connection) {
        setState(() {});
        _connection = true;
      }
    }).catchError((Object error) {
      _handleErrors(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            if (!_connection && _connectionError != null)
              _showConnectionErrors(), // Connection Errors
            if (_httpServiceError != null) _showHttpServiceErrors(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 65,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Running Programs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: IconButton(
                      iconSize: 30.0,
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.amber,
                        size: 30.0,
                      ),
                      tooltip: 'Refresh Running Programs',
                      onPressed: () {
                        _runningRefreshKey.currentState.show();
                      }),
                ),
              ],
            ),
            const Divider(
              height: 10,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: RefreshIndicator(
                key: _runningRefreshKey,
                onRefresh: _refreshRunning,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 225,
                        width: double.infinity,
                        child: _runningPrograms.isNotEmpty
                            ? ListView(
                                children: _runningPrograms
                                    .map(
                                      (Program currentProgram) => ListTile(
                                        title: Text(currentProgram.fileName),
                                        subtitle: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text("Path: "),
                                                Text(
                                                  currentProgram.filePath,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Process ID: "),
                                                Text(
                                                  currentProgram.processID
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        onTap: () => showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title:
                                                      Text("Program Commands"),
                                                  content: Text(
                                                      "What would you like to do with this program?\n\n" +
                                                          currentProgram
                                                              .fileName),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        this._httpServiceError =
                                                            null;
                                                        await widget.http
                                                            .postProgramCommand(
                                                                restURL:
                                                                    'api/program_manager/pause_program',
                                                                postBody: {
                                                              "program":
                                                                  currentProgram
                                                                      .fileName
                                                            }).catchError((e) {
                                                          _handleErrors(e);
                                                        });
                                                        _refreshRunning();
                                                        _refreshPaused();
                                                      },
                                                      child: Text(("Pause")),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        this._httpServiceError =
                                                            null;
                                                        await widget.http
                                                            .postProgramCommand(
                                                                restURL:
                                                                    'api/program_manager/stop_program',
                                                                postBody: {
                                                              "program":
                                                                  currentProgram
                                                                      .fileName
                                                            }).catchError((e) {
                                                          _handleErrors(e);
                                                        });
                                                        _refreshRunning();
                                                        _refreshPaused();
                                                      },
                                                      child: Text(("Stop")),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(("Dismiss")),
                                                    )
                                                  ],
                                                ),
                                            barrierDismissible: false),
                                      ),
                                    )
                                    .toList(),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Colors.green,
                                    size: 30.0,
                                  ),
                                  Text(
                                    "NO RUNNING PROGRAMS",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 65,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Paused Programs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: IconButton(
                      iconSize: 30.0,
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.amber,
                        size: 30.0,
                      ),
                      tooltip: 'Refresh Paused Programs',
                      onPressed: () {
                        _pausedRefreshKey.currentState.show();
                      }),
                ),
              ],
            ),
            const Divider(
              height: 10,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: RefreshIndicator(
                key: _pausedRefreshKey,
                onRefresh: _refreshPaused,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 225,
                          width: double.infinity,
                          child: _pausedPrograms.isNotEmpty
                              ? ListView(
                                  children: _pausedPrograms
                                      .map(
                                        (Program currentProgram) => ListTile(
                                          title: Text(currentProgram.fileName),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Path: "),
                                                  Text(
                                                    currentProgram.filePath,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Process ID: "),
                                                  Text(
                                                    currentProgram.processID
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                    title: Text(
                                                        "Program Commands"),
                                                    content: Text(
                                                        "What would you like to do with this program?\n\n" +
                                                            currentProgram
                                                                .fileName),
                                                    actions: [
                                                      FlatButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          this._httpServiceError =
                                                              null;
                                                          await widget.http
                                                              .postProgramCommand(
                                                                  restURL:
                                                                      'api/program_manager/continue_program',
                                                                  postBody: {
                                                                "program":
                                                                    currentProgram
                                                                        .fileName
                                                              }).catchError(
                                                                  (Object
                                                                      error) {
                                                            _handleErrors(
                                                                error);
                                                          });
                                                          _refreshRunning();
                                                          _refreshPaused();
                                                        },
                                                        child:
                                                            Text(("Continue")),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          this._httpServiceError =
                                                              null;
                                                          await widget.http
                                                              .postProgramCommand(
                                                                  restURL:
                                                                      'api/program_manager/stop_program',
                                                                  postBody: {
                                                                "program":
                                                                    currentProgram
                                                                        .fileName
                                                              }).catchError(
                                                                  (Object
                                                                      error) {
                                                            _handleErrors(
                                                                error);
                                                          });
                                                          _refreshRunning();
                                                          _refreshPaused();
                                                        },
                                                        child: Text(("Stop")),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(("Dimiss")),
                                                      )
                                                    ],
                                                  ),
                                              barrierDismissible: false),
                                        ),
                                      )
                                      .toList(),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.green,
                                      size: 30.0,
                                    ),
                                    Text(
                                      "NO PAUSED PROGRAMS",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                )),
                    ]),
              ),
            ),
            // Buttons - Stop All & Restart All Programs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () async {
                    this._httpServiceError = null;
                    await widget.http.postProgramCommand(
                        restURL: 'api/program_manager/stop_ALLprograms',
                        postBody: {
                          "program": "ALLprograms"
                        }).catchError((Object error) {
                      _handleErrors(error);
                    });
                    _refreshRunning();
                    _refreshPaused();
                  },
                  color: Colors.grey[300],
                  child: Text(("Stop ALL")),
                ),
                RaisedButton(
                  onPressed: () async {
                    this._httpServiceError = null;
                    await widget.http.postProgramCommand(
                        restURL: 'api/program_manager/restart_ALLprograms',
                        postBody: {
                          "program": "ALLprograms"
                        }).catchError((Object error) {
                      _handleErrors(error);
                    });
                    _refreshRunning();
                    _refreshPaused();
                  },
                  color: Colors.grey[300],
                  child: Text(("Restart ALL")),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
