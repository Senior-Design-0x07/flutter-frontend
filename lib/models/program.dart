import 'package:flutter/foundation.dart';

class Program {
  final String filePath;
  final String fileName;
  final int processID;

  Program(
      {@required this.filePath,
      @required this.fileName,
      @required this.processID});

  static Program fromTxt(String programData) {
    List<String> data = programData.split(" ");
    var filePath = data[0];
    var fileName = data[0].split("/").last;
    var processId = int.parse(data[1]);

    return Program(fileName: fileName, filePath: filePath, processID: processId);
  }
}
