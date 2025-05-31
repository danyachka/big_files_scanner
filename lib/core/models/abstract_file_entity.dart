

import 'dart:io';

import 'package:big_files_scanner/core/results_printer.dart';

abstract class AbstractFileEntity {

  int get size;

  final String name;

  final SizedFileSystemEntityType type;
  bool get isDirectory => type == SizedFileSystemEntityType.directory;

  AbstractFileEntity({
    required FileSystemEntity entity
  }) : name = entity.name,
    type = (entity is File)? SizedFileSystemEntityType.file : SizedFileSystemEntityType.directory;


  Future<int> calculateSize();
}


enum SizedFileSystemEntityType {

  file,

  directory
}