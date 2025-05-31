import 'package:big_files_scanner/big_files_scanner.dart' as big_files_scanner;

void main(List<String> args) {
  assert(args.isNotEmpty, "Path should be given!");

  final path = args.last;
  big_files_scanner.scanPath(path);
}
