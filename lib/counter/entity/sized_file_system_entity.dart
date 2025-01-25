

import 'dart:io';
import 'package:big_files_scanner/counter/counter.dart';
import 'package:big_files_scanner/counter/entity/sized_file_system_entity_type.dart';

class SizedFileSystemEntity {

  int _size = 0;
  int get size => _size;

  final FileSystemEntity _fileSystemEntity;

  late final List<SizedFileSystemEntity> _list;
  List<SizedFileSystemEntity> get list => _list;

  final SizedFileSystemEntityType type;

  String get name => _fileSystemEntity.name;

  bool get isDirectory => type == SizedFileSystemEntityType.directory;

  SizedFileSystemEntity({
    required FileSystemEntity entity
  })
  : _fileSystemEntity = entity, 
    type = (entity is File)? SizedFileSystemEntityType.file : SizedFileSystemEntityType.directory;


  Future<int> calculateSize() async {
    if (_fileSystemEntity is File) {
      _size = await _fileSystemEntity.length();
      return _size;
    }

    if (_fileSystemEntity is! Directory) return 0;

    _list = _fileSystemEntity.listSync().map(
      (filesEntity) => SizedFileSystemEntity(entity: filesEntity)
    ).toList();
    
    final sizes = await Future.wait(_list.map((el) => el.calculateSize()));
    for (var s in sizes) {
      _size += s;
    }

    return _size;
  }

}