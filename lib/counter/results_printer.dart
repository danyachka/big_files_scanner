

import 'package:big_files_scanner/counter/entity/sized_file_system_entity.dart';

class ResultsPrinter {

  final String path;
  final SizedFileSystemEntity entity;

  ResultsPrinter({required this.path, required this.entity});

  void printResults() {
    entity.list.sort((a, b) => a.size.compareTo(b.size));

    for (int i = 0; i < entity.list.length; i++) {
      var el = entity.list[i];

      print('${i.toString().padRight(4)}| ${el.type.name.padRight(10)}: ${_getFittedString(el.name)} - ${_bytesToHumanReadable(el.size)}');
    }

    print("\nPath = $path${entity.name}");
    print("Size = ${_bytesToHumanReadable(entity.size)}");
  }

  SizedFileSystemEntity? getResultAt(int i) {
    if (entity.list.isEmpty) return null;
    if (i >= entity.list.length) return null;

    return entity.list[i];
  }
}

String _getFittedString(String string) {
  if (string.length < 36) return string.padRight(36, "_");
  if (string.length == 36) return string;

  return "${string.substring(0, 33)}...";
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