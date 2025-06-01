

import 'dart:io';

import 'package:big_files_scanner/core/models/abstract_counter.dart';
import 'package:big_files_scanner/core/results_printer.dart';
import 'package:big_files_scanner/eco_mode/entity/eco_sized_file_system_entity.dart';

class EcoCounter extends AbstractCounter<EcoSizedFileSystemEntity> {

  final List<ResultsPrinter<EcoSizedFileSystemEntity>> _resultsPrinters = [];

  @override
  Future<void> calculate(Directory directory) async {
    final list = directory.listSync().map((el) => EcoSizedFileSystemEntity(entity: el)).toList();

    final sizes = await Future.wait(list.map((el) => el.calculateSize()));
    var totalSize = 0;
    for (final s in sizes) {
      totalSize += s;
    }

    final startEntity = EcoSizedFileSystemEntity.sized(entity: directory, size: totalSize);

    _resultsPrinters.add(ResultsPrinter(path: directory.path, entity: startEntity, list: list));
  }

  @override
  Future<void> goTo(int at) async {
    final entityAt = _resultsPrinters.last.getEntityAt(at);
    if (entityAt == null) {
      print("Invalid index");
      return;
    }
    if (!entityAt.isDirectory) {
      print("Pick up directory!");
      return;
    }

    await calculateSize(entityAt.path);
  }

  @override
  Future<void> goUp() async {
    final current = _resultsPrinters.removeLast();

    if (_resultsPrinters.isEmpty) {
      final parent = Directory(current.entity.path).parent;

      await calculateSize(parent.path);
    } else {
      _resultsPrinters.last.printResults();
    }
  }
  
  @override
  void printResults() => _resultsPrinters.last.printResults();

}