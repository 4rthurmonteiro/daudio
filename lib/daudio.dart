import 'dart:io';

void run({
  required String startSecondArg,
  required String inputFilteArg,
  required String endSecondArg,
  required String outputFileArg,
}) {
  Process.run('ffmpeg', [
    '-y',
    '-ss',
    startSecondArg,
    '-i',
    inputFilteArg,
    '-t',
    endSecondArg,
    outputFileArg,
  ]).then((result) {
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  });
}
