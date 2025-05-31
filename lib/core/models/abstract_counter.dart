

import 'dart:io';

import 'package:big_files_scanner/core/models/abstract_file_entity.dart';
import 'package:big_files_scanner/core/results_printer.dart';

abstract class AbstractCounter<T extends AbstractFileEntity> {

  final String startPath;

  final List<ResultsPrinter<T>> resultsPrinters = [];

  AbstractCounter({required this.startPath});

  Future<void> calculateSize(String path) async {
    final directory = Directory(path);
    assert(await directory.exists(), "Directory doesn't exist");

    print("Loading...");
    final timeStarted = DateTime.now().millisecondsSinceEpoch;

    await calculate(directory);

    printResults();
    print("Process took ${((DateTime.now().millisecondsSinceEpoch - timeStarted).toDouble()/1000)} sec");
  }

  void printResults() => resultsPrinters.last.printResults();

  void goUp() {
    if (resultsPrinters.length == 1) {
      print("Cant go back - start directory");
      return;
    }

    resultsPrinters.removeLast();
    resultsPrinters.last.printResults();
  }

  /// override this
  Future<void> calculate(Directory directory);

  Future<void> goTo(int at);
}

enum CounterType {
  rememberingCounter,
  ecoCounter
}