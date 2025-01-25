

import 'dart:io';

import 'package:big_files_scanner/counter/entity/sized_file_system_entity.dart';
import 'package:big_files_scanner/counter/results_printer.dart';

class Counter {

  static const goBackString = "..";
  static const exitString = "exit";
  static const printHelpString = "help";

  final String startPath;

  late final SizedFileSystemEntity startEntity;

  final List<ResultsPrinter> resultsPrinters = [];

  Counter({required this.startPath});

  Future<void> calculate() async {
    final directory = Directory(startPath);

    assert(await directory.exists(), "Directory doesn't exist");

    startEntity = SizedFileSystemEntity(entity: directory);
    await startEntity.calculateSize();
  }

  void printResults(int at) {
    ResultsPrinter printer;
    if (resultsPrinters.isEmpty) {
      printer = ResultsPrinter(entity: startEntity);
    } else {
      final resultAt = resultsPrinters.last.getResultAt(at);
      if (resultAt == null) {
        print("Invalid index");
        return;
      }

      if (!resultAt.isDirectory) {
        print("Pick up directory!");
        return;
      }

      printer = ResultsPrinter(entity: resultAt);
    }

    resultsPrinters.add(printer);
    printer.printResults();
  }

  void goUp() {
    if (resultsPrinters.length == 1) {
      print("Cant go back - start directory");
      return;
    }

    resultsPrinters.removeLast();
    resultsPrinters.last.printResults();
  }

  void printHelp() {
    print("Go back - $goBackString\nTo open folder type index\nTo exit print $exitString");
  }

}

extension FileExtention on FileSystemEntity {
  String get name {
    return path.split("\\").last;
  }
}