

import 'dart:io';

import 'package:big_files_scanner/default/entity/remembering_sized_file_system_entity.dart';
import 'package:big_files_scanner/core/results_printer.dart';
import 'package:big_files_scanner/core/models/abstract_counter.dart';

class RememberingCounter extends AbstractCounter<RememberingSizedFileSystemEntity> {

  RememberingCounter({required super.startPath});

  @override
  Future<void> calculate(Directory directory) async {
    final startEntity = RememberingSizedFileSystemEntity(entity: directory);
    await startEntity.calculateSize();

    resultsPrinters.add(ResultsPrinter(path: directory.path, entity: startEntity, list: startEntity.list));
  }

  @override
  Future<void> goTo(int at) async {
    final lastPrinter = resultsPrinters.last;

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

    resultsPrinters.add(printer);
    printer.printResults();
  }
}