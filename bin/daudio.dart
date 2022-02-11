import 'package:args/args.dart';
import 'package:daudio/daudio.dart' as daudio;

const inputFile = 'input-file';
const startSecond = 'start-second';
const endSecond = 'end-second';
const outputFile = 'output-file';

// Example: daudio.exe -s 0 -i sample.wav -t 2 -o outpub.wav
Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(inputFile, abbr: 'i')
    ..addOption(startSecond, abbr: 's')
    ..addOption(endSecond, abbr: 't')
    ..addOption(outputFile, abbr: 'o');

  ArgResults argResults = parser.parse(arguments);

  final inputFilteArg = argResults[inputFile];
  final startSecondArg = argResults[startSecond];
  final endSecondArg = argResults[endSecond];
  final outputFileArg = argResults[outputFile];

  daudio.run(
    startSecondArg: startSecondArg,
    inputFilteArg: inputFilteArg,
    endSecondArg: endSecondArg,
    outputFileArg: outputFileArg,
  );
}
