import 'dart:convert';
import 'dart:io';

import 'package:big_files_scanner/core/models/abstract_counter.dart';
import 'package:big_files_scanner/core/results_printer.dart';
import 'package:big_files_scanner/default/counter.dart';
import 'package:big_files_scanner/eco/eco_counter.dart';

void main(List<String> args) async {
  assert(args.isNotEmpty, "Path should be given!");

  final path = args.last;
  
  final type = args.contains("--remember")
    ? CounterType.rememberingCounter 
    : CounterType.ecoCounter;

  final AbstractCounter counter = type == CounterType.rememberingCounter
    ? RememberingCounter(startPath: path) 
    : EcoCounter(startPath: path);

  await counter.calculateSize(path);

  processCommands(counter);
}

void processCommands(AbstractCounter counter) async {
  while (true) {
    final command = stdin.readLineSync(encoding: utf8);
    
    print('');

    switch (command?.toLowerCase()) {
      case exitString:
        return;
      case goBackString:
        counter.goUp();
        break;
      case printHelpString:
        printHelp();
        break;
      default:
        int? index = int.tryParse(command ?? '');
        
        if (index == null) {
          print("Invalid index");
          continue;
        }
        await counter.goTo(index);
    }
  }

}
