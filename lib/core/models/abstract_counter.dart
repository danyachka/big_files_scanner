

import 'dart:io';

import 'package:big_files_scanner/core/models/abstract_file_entity.dart';

abstract class AbstractCounter<T extends AbstractFileEntity> {

  Future<bool> calculateSize(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      print("Directory doesn't exist");
      return false;
    }

    print("Loading...");
    final timeStarted = DateTime.now().millisecondsSinceEpoch;

    await calculate(directory);

    printResults();
    print("Process took ${((DateTime.now().millisecondsSinceEpoch - timeStarted).toDouble()/1000)} sec");

    return true;
  }

  /// override this
  Future<void> calculate(Directory directory);

  Future<void> goTo(int at);

  Future<void> goUp();
  
  void printResults();
}

enum CounterType {
  rememberingCounter,
  ecoCounter
}