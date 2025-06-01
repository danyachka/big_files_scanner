import 'dart:convert';
import 'dart:io';

import 'package:big_files_scanner/core/models/abstract_counter.dart';
import 'package:big_files_scanner/core/results_printer.dart';
import 'package:big_files_scanner/remember_mode/counter.dart';
import 'package:big_files_scanner/eco_mode/eco_counter.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print("Path should be given!");
    return;
  } else if (args[0] == "--help" || args[0] == "-h") {
    printHelp();
    return;
  }
  
  startDirAnalyzing(args);
}

void startDirAnalyzing(List<String> args) async {
  final path = args.last;
  
  final type = args.contains("--remember")
    ? CounterType.rememberingCounter 
    : CounterType.ecoCounter;

  final AbstractCounter counter = type == CounterType.rememberingCounter
    ? RememberingCounter() 
    : EcoCounter();

  if (!await counter.calculateSize(path)) return;

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
        await counter.goUp();
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
