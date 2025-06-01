

import 'dart:async';
import 'dart:io';

import 'package:big_files_scanner/core/models/abstract_file_entity.dart';
import 'package:big_files_scanner/core/results_printer.dart';

class EcoSizedFileSystemEntity extends AbstractFileEntity {

  int _size = 0;
  @override
  int get size => _size;

  FileSystemEntity? _entity;
  final String path;

  @override
  String get name => getLastPartOfPath(path);

  EcoSizedFileSystemEntity({required super.entity}) 
    : _entity = entity, path = entity.absolute.path;

  EcoSizedFileSystemEntity.sized({required super.entity, required int size}) 
    : _entity = entity, path = entity.absolute.path, _size = size;

  @override
  Future<int> calculateSize() async {
    final entity = _entity;
    _entity = null;

    if (entity is File) {
      _size += entity.lengthSync();
      return _size;
    }

    if (entity is! Directory) return 0;

    Completer<void> streamCompleter = Completer();
    entity.list(recursive: true).listen(
      (data) {
        if (data is! File) return;

        data.length().timeout(fileLenWaitTimeout).then(
          (s) => _size += s,
          onError: (error) => print("oops!")
        );
      },
      onError: (e) {
        print("Problems occurred reading read in $path");
      },
      onDone: () {
        streamCompleter.complete();
      },
    );

    await streamCompleter.future;
    return _size;
  }


}