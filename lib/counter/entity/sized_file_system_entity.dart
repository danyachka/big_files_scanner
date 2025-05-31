

import 'dart:io';
import 'package:big_files_scanner/counter/counter.dart';
import 'package:big_files_scanner/counter/entity/sized_file_system_entity_type.dart';

class SizedFileSystemEntity {

  int _size = 0;
  int get size => _size;

  final String name;

  final SizedFileSystemEntityType type;
  bool get isDirectory => type == SizedFileSystemEntityType.directory;

  FileSystemEntity? _entity;
  late final List<SizedFileSystemEntity> list;

  SizedFileSystemEntity({
    required FileSystemEntity entity
  }) : _entity = entity, name = entity.name,
    type = (entity is File)? SizedFileSystemEntityType.file : SizedFileSystemEntityType.directory;

  Future<int> calculateSize() async {
    final entity = _entity!;
    _entity = null;

    if (entity is File) {
      _size = await entity.length();
      return _size;
    }

    if (entity is! Directory) return 0;

    list = entity.listSync().map(
      (filesEntity) => SizedFileSystemEntity(entity: filesEntity)
    ).toList();
    
    final sizes = await Future.wait(list.map((el) => el.calculateSize()));
    for (var s in sizes) {
      _size += s;
    }

    return _size;
  }

}