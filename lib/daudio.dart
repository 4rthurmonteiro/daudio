import 'dart:io';
import 'dart:convert';

import 'package:csv/csv.dart';

Future<void> run({
  required String inputFilteArg,
  required String endSecondArg,
  required String outputFileArg,
}) async {
  final duration = await fileDuration(
    inputFilteArg: inputFilteArg,
  );

  print('Duration: $duration');

  final step = int.tryParse(endSecondArg) ??
      duration; // if error on endSecond, the step is the whole audio.

  print('Step: $step');

  final times = duration ~/ step;

  print('Times: $times');

  final listOfLists = <List<String>>[
    ['id', 'filename']
  ];

  for (int i = 0; i < times; i++) {
    await Process.run('ffmpeg', [
      '-y',
      '-ss',
      (i * times).toString(),
      '-i',
      inputFilteArg,
      '-t',
      (i * times + step).toString(),
      '$i$outputFileArg',
    ]).then((result) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
      listOfLists.add([i.toString(), '$i$outputFileArg']);
    });
  }

  await Process.run('touch', [
    'metadata.csv',
  ]).then((result) {
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  });

  final csv = const ListToCsvConverter().convert(
    listOfLists,
  );

  File file = File('metadata.csv');
  await file.writeAsString(csv);
}

Future<int> fileDuration({
  required String inputFilteArg,
}) async {
  final result = await Process.run('ffprobe', [
    '-i',
    inputFilteArg,
    '-show_entries',
    'format=duration',
    '-v',
    'quiet',
    '-print_format',
    'json',
  ]);

  final data = json.decode(result.stdout);
  final duration = data['format']['duration'];

  return double.tryParse(duration)?.truncate() ?? 0;
}
