

import 'dart:io';

const fileLenWaitTimeout = Duration(milliseconds: 1000);

abstract class AbstractFileEntity {

  int get size;

  final SizedFileSystemEntityType type;
  bool get isDirectory => type == SizedFileSystemEntityType.directory;

  AbstractFileEntity({
    required FileSystemEntity entity
  }) : type = (entity is File)? SizedFileSystemEntityType.file : SizedFileSystemEntityType.directory;

  String get name;

  Future<int> calculateSize();
}


enum SizedFileSystemEntityType {

  file,

  directory
}