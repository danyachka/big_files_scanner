

import 'dart:io';

import 'package:big_files_scanner/core/models/abstract_file_entity.dart';

class EcoSizedFileSystemEntity extends AbstractFileEntity {

  int _size = 0;
  @override
  int get size => _size;

  final FileSystemEntity _entity;
  FileSystemEntity get entity => _entity;

  EcoSizedFileSystemEntity({required super.entity}) : _entity = entity;

  EcoSizedFileSystemEntity.sized({required super.entity, required int size}) : _entity = entity, _size = size;

  @override
  Future<int> calculateSize() async {
    final entity = _entity;

    if (entity is File) {
      _size += entity.lengthSync();
      return _size;
    }

    if (entity is! Directory) return 0;

    int totalCount = 0;
    int totalCalculatedCount = 0;
    
    await entity.list(recursive: true).listen((data) {
      if (data is! File) return;
      totalCount++;

      data.length().then((s) {
        _size += s;
        totalCalculatedCount++;
      });
    }).asFuture();

    while (totalCount != totalCalculatedCount) { // shit realization
      await Future.delayed(const Duration(milliseconds: 10));
    }

    return _size;
  }


}