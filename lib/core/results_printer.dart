

import 'dart:io';
import 'package:big_files_scanner/core/models/abstract_file_entity.dart';


const goBackString = "..";
const exitString = "exit";
const printHelpString = "help";

class ResultsPrinter<T extends AbstractFileEntity> {

  final String path;
  final T entity;
  final List<T> list;

  ResultsPrinter({required this.path, required this.entity, required this.list});

  void printResults() {
    list.sort((a, b) => a.size.compareTo(b.size));

    for (int i = 0; i < list.length; i++) {
      var el = list[i];

      print('${i.toString().padRight(4)}| ${el.type.name.padRight(10)}: ${_getFittedString(el.name)} - ${_bytesToHumanReadable(el.size)}');
    }

    print("\nPath = $path");
    print("Size = ${_bytesToHumanReadable(entity.size)}");
  }

  T? getEntityAt(int index) {
    if (index < 0 || index >= list.length) return null;

    return list[index];
  }
}

const _pathLen = 52;
String _getFittedString(String string) {
  if (string.length < _pathLen) return string.padRight(_pathLen, "_");
  if (string.length == _pathLen) return string;

  return "${string.substring(0, _pathLen - 3)}...";
}


String _bytesToHumanReadable(int bytes) {
  const suffixes = ["B", "KB", "MB", "GB", "TB"];

  double size = bytes.toDouble();
  String? suffix;
  for (String suf in suffixes) {
    if (size > 1000) {
      size = size / 1000;
      continue;
    }

    suffix = suf;
    break;
  }
  suffix ??= suffixes.last;

  const roundResolution = 1000;
  return "${((size * roundResolution).round() / roundResolution).toString().padRight(7)} $suffix";
}

void printHelp() {
  print("This script is created for analyzing directories to find big weighted ones.");
  print("Go back - $goBackString\nTo open folder type its index\nTo exit type $exitString");
  print("Use flag --remember to start program with much higher (much higher!) memory usage but with faster directories opening");
}

extension FileExtention on FileSystemEntity {
  String get name {
    return path.split(RegExp("/|\\\\")).last;
  }
}