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
  List<Program> runningPrograms = List<Program>.empty(growable: true);
  List<Program> pausedPrograms = List<Program>.empty(growable: true);
  final GlobalKey<RefreshIndicatorState> _runningRefreshKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _pausedRefreshKey =
      new GlobalKey<RefreshIndicatorState>();
  bool cmdSuccess = false;
  bool connection = true;
  List<String> connectionError;
  String httpServiceError;

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

  void _handleErrors(Object error) {
    setState(() {
      error.toString().split("Exception")[0] == "Timeout"
          ? connection = false
          : connection = true;
      error.toString().split("Exception")[0] != ""
          ? this.connectionError = error.toString().split("Exception")
          : this.httpServiceError = error.toString();
    });
  }

  // refresh indicator method - get running programs list for ListView widget
  Future<void> _refreshRunning() async {
    httpServiceError = null;
    return await widget.http
        .getProgramList(restURL: 'api/program_manager/running_programs')
        .then((_pausedPrograms) {
      connection = true;
      if (_pausedPrograms.isNotEmpty) {
        _parsePrograms("runningPrograms", _pausedPrograms);
        setState(() {});
      }
    }).catchError((Object error) {
      _handleErrors(error);
    });
  }

  // refresh indicator method - get paused programs list for ListView widget
  Future<void> _refreshPaused() async {
    httpServiceError = null;
    return await widget.http
        .getProgramList(restURL: 'api/program_manager/paused_programs')
        .then((_pausedPrograms) {
      connection = true;
      if (_pausedPrograms.isNotEmpty) {
        _parsePrograms("pausedPrograms", _pausedPrograms);
        setState(() {});
      }
    }).catchError((Object error) {
      _handleErrors(error);
    });
  }

  // method for parsing text into Program objects for ListView mapping
  void _parsePrograms(String listName, String rawPrograms) {
    // clear current list
    if (listName == "runningPrograms") {
      runningPrograms.clear();
    } else if (listName == "pausedPrograms") {
      pausedPrograms.clear();
    }

    if (listName == "runningPrograms" || listName == "pausedPrograms") {
      // convert list of running programs into List<String>
      LineSplitter ls = new LineSplitter();
      List<String> strPrograms = ls.convert(rawPrograms);

      // convert list of Strings into Program objects
      for (var i = 1; i < strPrograms.length - 1; i++) {
        String programInfo = strPrograms[i];
        List<String> programParts = programInfo.trim().split(' ');

        // remove unnecessary characters (," )
        programParts[0] = programParts[0].replaceAll('"', '');
        programParts[1] = programParts[1].replaceAll('"', '');
        programParts[1] = programParts[1].replaceAll(',', '');

        Program currentProgram = new Program(
            filePath: programParts[0],
            fileName: programParts[0].split('/').last,
            processID: int.parse(programParts[1]));

        if (currentProgram != null && listName == "runningPrograms") {
          runningPrograms.add(currentProgram);
        } else if (currentProgram != null && listName == "pausedPrograms") {
          pausedPrograms.add(currentProgram);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            if (!connection && connectionError != null)
              _showConnectionErrors(), // Connection Errors
            if (httpServiceError != null) _showHttpServiceErrors(),
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
                        child: runningPrograms.isNotEmpty
                            ? ListView(
                                children: runningPrograms
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
                                                        await widget.http
                                                            .postProgramCommand(
                                                                restURL:
                                                                    'api/program_manager/pause_program',
                                                                postBody: {
                                                              "program":
                                                                  currentProgram
                                                                      .fileName
                                                            });
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(("Pause")),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () async {
                                                        await widget.http
                                                            .postProgramCommand(
                                                                restURL:
                                                                    'api/program_manager/stop_program',
                                                                postBody: {
                                                              "program":
                                                                  currentProgram
                                                                      .fileName
                                                            });
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(("Stop")),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                          ("Close Window")),
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
                          child: pausedPrograms.isNotEmpty
                              ? ListView(
                                  children: pausedPrograms
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
                                                          this.httpServiceError =
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
                                                          setState(() {});
                                                        },
                                                        child:
                                                            Text(("Continue")),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          this.httpServiceError =
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
                                                          setState(() {});
                                                        },
                                                        child: Text(("Stop")),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                            ("Close Window")),
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
                FlatButton(
                  onPressed: () async {
                    this.httpServiceError = null;
                    await widget.http.postProgramCommand(
                        restURL: 'api/program_manager/stop_ALLprograms',
                        postBody: {
                          "program": "ALLprograms"
                        }).catchError((Object error) {
                      _handleErrors(error);
                    });
                    setState(() {});
                  },
                  color: Colors.grey[300],
                  child: Text(("Stop ALL")),
                ),
                FlatButton(
                  onPressed: () async {
                    this.httpServiceError = null;
                    await widget.http.postProgramCommand(
                        restURL: 'api/program_manager/restart_ALLprograms',
                        postBody: {
                          "program": "ALLprograms"
                        }).catchError((Object error) {
                      _handleErrors(error);
                    });
                    setState(() {});
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
