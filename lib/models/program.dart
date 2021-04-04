import 'package:flutter/foundation.dart';

class Program {
  final String filePath;
  final String fileName;
  final int processID;

  Program(
      {@required this.filePath,
      @required this.fileName,
      @required this.processID});
}
