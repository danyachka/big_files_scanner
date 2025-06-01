

import 'dart:io';

import 'package:big_files_scanner/remember_mode/entity/remembering_sized_file_system_entity.dart';
import 'package:big_files_scanner/core/results_printer.dart';
import 'package:big_files_scanner/core/models/abstract_counter.dart';

class RememberingCounter extends AbstractCounter<RememberingSizedFileSystemEntity> {

  final List<ResultsPrinter<RememberingSizedFileSystemEntity>> _resultsPrinters = [];

  @override
  Future<void> calculate(Directory directory) async {
    final startEntity = RememberingSizedFileSystemEntity(entity: directory);
    await startEntity.calculateSize();

    _resultsPrinters.add(ResultsPrinter(path: directory.path, entity: startEntity, list: startEntity.list));
  }

  @override
  Future<void> goTo(int at) async {
    final lastPrinter = _resultsPrinters.last;

    final entityAt = lastPrinter.getEntityAt(at);
    if (entityAt == null) {
      print("Invalid index");
      return;
    }
    if (!entityAt.isDirectory) {
      print("Pick up directory!");
      return;
    }

    final printer = ResultsPrinter<RememberingSizedFileSystemEntity>(
      path: lastPrinter.path, entity: entityAt, list: entityAt.list
    );

    _resultsPrinters.add(printer);
    printer.printResults();
  }

  @override
  void printResults() => _resultsPrinters.last.printResults();

  @override
  Future<void> goUp() async {
    if (_resultsPrinters.length == 1) {
      print("Cant go back - start directory");
      return;
    }

    _resultsPrinters.removeLast();
    _resultsPrinters.last.printResults();
  }
}