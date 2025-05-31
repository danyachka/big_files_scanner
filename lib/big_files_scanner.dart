

import 'dart:convert';
import 'dart:io';

import 'package:big_files_scanner/counter/counter.dart';

void main(List<String> args) async {
  assert(args.length == 1, "Path should be given as a single argument!");

  final path = args[0];

  print("Loading...");
  final timeStarted = DateTime.now().millisecondsSinceEpoch;

  final counter = Counter(startPath: path);
  await counter.calculate();

  counter.printResults(0);
  print("Process took ${((DateTime.now().millisecondsSinceEpoch - timeStarted).toDouble()/1000)} sec");

  while (true) {
    final command = stdin.readLineSync(encoding: utf8);
    print('');

    switch (command?.toLowerCase()) {
      case Counter.exitString:
        return;
      case Counter.goBackString:
        counter.goUp();
        break;
      case Counter.printHelpString:
        counter.printHelp();
        break;
      default:
        int? index = int.tryParse(command ?? '');
        
        if (index == null) {
          print("Invalid index");
          continue;
        }
        counter.printResults(index);
    }
  }

}


