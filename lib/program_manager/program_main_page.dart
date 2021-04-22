import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/program.dart';
import 'dart:convert';

import 'package:hobby_hub_ui/services/http/http_service.dart';
import 'package:hobby_hub_ui/services/navigation/appBar.dart';
import 'package:hobby_hub_ui/services/navigation/navDrawer.dart';

class ProgramManagerPage extends StatefulWidget {
  @override
  _ProgramManagerPageState createState() => _ProgramManagerPageState();
}

class _ProgramManagerPageState extends State<ProgramManagerPage> {
  // local lists for keeping track of current running/paused programs
  List<Program> runningPrograms = List<Program>.empty(growable: true);
  List<Program> pausedPrograms = List<Program>.empty(growable: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final HttpService http = new HttpService();

  // key for saving/refreshing state of program lists
  final GlobalKey<RefreshIndicatorState> _runningRefreshKey =
      new GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> _pausedRefreshKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runningRefreshKey.currentState.show();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pausedRefreshKey.currentState.show();
    });
  }

  // refresh indicator method - get running programs list for ListView widget
  Future<void> _refreshRunning() async {
    String rawRunningPrograms = await http.getProgramList(
        restURL: 'api/program_manager/running_programs');

    _parsePrograms("runningPrograms", rawRunningPrograms);
    setState(() {});
  }

  // refresh indicator method - get paused programs list for ListView widget
  Future<void> _refreshPaused() async {
    String rawPausedPrograms = await http.getProgramList(
        restURL: 'api/program_manager/paused_programs');

    _parsePrograms("pausedPrograms", rawPausedPrograms);
    setState(() {});
  }

  // method for parsing text data into program objects for ListView mapping
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

        // remove unnecessary characters
        programParts[0] = programParts[0].replaceAll('"', '');
        programParts[1] = programParts[1].replaceAll('"', '');
        programParts[1] = programParts[1].replaceAll(',', '');

        // create objects for storing data about each program
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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: HHAppBar(title: 'Program Manager', scaffoldKey: _scaffoldKey)),
      body: SafeArea(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // refresh program lists button
              IconButton(
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
            ],
          ),
          Text(
            'Running Programs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
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
                      child: FutureBuilder(
                        future: http.getProgramList(
                            restURL: 'api/program_manager/running_programs'),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            // parse running programs into mappable List of objects
                            _parsePrograms("runningPrograms", snapshot.data);

                            if (runningPrograms.isNotEmpty) {
                              return ListView(
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
                                                      "What would you like to do with this program?"),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () async {
                                                        var output = await http
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
                                                        var output = await http
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
                              );
                            } else {
                              // running programs lists is empty, display to user
                              return Row(
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
                              );
                            }
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text("Grabbing List of Running Programs"),
                              SizedBox(
                                height: 20,
                              ),
                              Center(child: CircularProgressIndicator()),
                            ],
                          );
                        },
                      ),
                    ),
                  ]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // refresh program lists button
              IconButton(
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
            ],
          ),
          Text(
            'Paused Programs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
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
                      child: FutureBuilder(
                        future: http.getProgramList(
                            restURL: 'api/program_manager/paused_programs'),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            // parse paused programs into mappable List of objects
                            _parsePrograms("pausedPrograms", snapshot.data);

                            if (pausedPrograms.isNotEmpty) {
                              return ListView(
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
                                                  title:
                                                      Text("Program Commands"),
                                                  content: Text(
                                                      "What would you like to do with this program?"),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () async {
                                                        var output = await http
                                                            .postProgramCommand(
                                                                restURL:
                                                                    'api/program_manager/continue_program',
                                                                postBody: {
                                                              "program":
                                                                  currentProgram
                                                                      .fileName
                                                            });
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(("Continue")),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () async {
                                                        var output = await http
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
                              );
                            } else {
                              // paused programs lists is empty, display to user
                              return Row(
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
                              );
                            }
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text("Grabbing List of Paused Programs"),
                              SizedBox(
                                height: 20,
                              ),
                              Center(child: CircularProgressIndicator()),
                            ],
                          );
                        },
                      ),
                    ),
                  ]),
            ),
          ),
          Center(
              child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.grey[300],
            child: Text(("Home Page")),
          )),
        ]),
      ),
    );
  }
}
