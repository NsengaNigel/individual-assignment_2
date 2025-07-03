import 'dart:io';

void main() async {
  final process = await Process.start(
    'flutter',
    ['run'],
    runInShell: true,
  );

  // Pipe the stdout and stderr to the console
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  // Wait for the process to finish
  final exitCode = await process.exitCode;
  exit(exitCode);
} 