import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/http/http_service.dart';
import 'package:hobby_hub_ui/models/program.dart';
import 'dart:convert';

class ProgramManagerPage extends StatefulWidget {
  @override
  _ProgramManagerPageState createState() => _ProgramManagerPageState();
}

class _ProgramManagerPageState extends State<ProgramManagerPage> {
  // local lists for keeping track of current running/paused programs
  List<Program> runningPrograms = new List();
  List<Program> pausedPrograms = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Center(
            child: Text(
          "Program Manager",
          style: TextStyle(color: Colors.white),
        )),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text("0")),
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 400,
              width: double.infinity,
              child: FutureBuilder(
                future: HttpService.getProgramList(
                    restURL: 'api/program_manager/running_programs'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    // convert list of running programs into List<String>
                    String runningProgramsRaw = snapshot.data;
                    LineSplitter ls = new LineSplitter();
                    List<String> runningProgramsStr =
                        ls.convert(runningProgramsRaw);

                    // convert list of Strings into Program objects
                    for (var i = 1; i < runningProgramsStr.length - 1; i++) {
                      String programInfo = runningProgramsStr[i];
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

                      if (currentProgram != null) {
                        runningPrograms.add(currentProgram);
                      }
                    }

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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Process ID: "),
                                      Text(
                                        currentProgram.processID.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text("Program Commands"),
                                        content: Text(
                                            "What would you like to do with this program?"),
                                        actions: [
                                          FlatButton(
                                            onPressed: () async {
                                              var output = await HttpService
                                                  .postProgramCommand(
                                                      restURL:
                                                          'api/program_command',
                                                      postBody: {
                                                    "command": "pause_program",
                                                    "program": "light1.py"
                                                  });
                                              setState(() {});
                                            },
                                            child: Text(("Pause")),
                                          ),
                                          FlatButton(
                                            onPressed: () async {
                                              var output = await HttpService
                                                  .postProgramCommand(
                                                      restURL:
                                                          'api/program_command',
                                                      postBody: {
                                                    "command": "stop_program",
                                                    "program": "light1.py"
                                                  });
                                              setState(() {});
                                            },
                                            child: Text(("Stop")),
                                          ),
                                        ],
                                      ),
                                  barrierDismissible: false),
                            ),
                          )
                          .toList(),
                    );
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
            Container(
              height: 400,
              width: double.infinity,
              child: FutureBuilder(
                future: HttpService.getProgramList(
                    restURL: 'api/program_manager/paused_programs'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    // convert list of running programs into List<String>
                    String pausedProgramsRaw = snapshot.data;
                    LineSplitter ls = new LineSplitter();
                    List<String> pausedProgramsStr =
                        ls.convert(pausedProgramsRaw);

                    // convert list of Strings into Program objects
                    for (var i = 1; i < pausedProgramsStr.length - 1; i++) {
                      String programInfo = pausedProgramsStr[i];
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

                      if (currentProgram != null) {
                        pausedPrograms.add(currentProgram);
                      }
                    }

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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Process ID: "),
                                      Text(
                                        currentProgram.processID.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text("Program Commands"),
                                        content: Text(
                                            "What would you like to do with this program?"),
                                        actions: [
                                          FlatButton(
                                            onPressed: () async {
                                              var output = await HttpService
                                                  .postProgramCommand(
                                                      restURL:
                                                          'api/program_command',
                                                      postBody: {
                                                    "command":
                                                        "continue_program",
                                                    "program": "light1.py"
                                                  });
                                              setState(() {});
                                            },
                                            child: Text(("Continue")),
                                          ),
                                          FlatButton(
                                            onPressed: () async {
                                              var output = await HttpService
                                                  .postProgramCommand(
                                                      restURL:
                                                          'api/program_command',
                                                      postBody: {
                                                    "command": "stop_program",
                                                    "program": "light1.py"
                                                  });
                                              setState(() {});
                                            },
                                            child: Text(("Stop")),
                                          ),
                                        ],
                                      ),
                                  barrierDismissible: false),
                            ),
                          )
                          .toList(),
                    );
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
    );
  }
}
