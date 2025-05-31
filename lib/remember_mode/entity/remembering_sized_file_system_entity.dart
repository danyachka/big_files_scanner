

import 'dart:io';
import 'package:big_files_scanner/core/models/abstract_file_entity.dart';

class RememberingSizedFileSystemEntity extends AbstractFileEntity {

  int _size = 0;
  FileSystemEntity? _entity;

  @override
  int get size => _size;

  RememberingSizedFileSystemEntity({required super.entity}) : _entity = entity;

  late final List<RememberingSizedFileSystemEntity> list;

  @override
  Future<int> calculateSize() async {
    final entity = _entity!;
    _entity = null;

    if (entity is File) {
      _size = entity.lengthSync();
      return size;
    }

    if (entity is! Directory) return 0;

    list = entity.listSync().map(
      (filesEntity) => RememberingSizedFileSystemEntity(entity: filesEntity)
    ).toList();
    
    final sizes = list.map((el) => el.calculateSize()).toList();

    for (var s in await Future.wait(sizes)) {
      _size += s;
    }

    return size;
  }

}