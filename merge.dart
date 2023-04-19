import 'dart:io';

Future<void> main() async {
  final fileA = File('exemplo.md');
  final fileB = File('output_dart.md');
  final fileC = File('traduzido.md');

  final contentA = fileA.readAsStringSync();
  final contentB = fileB.readAsStringSync();
  final contentC = fileC.readAsStringSync();

  final blocksB = contentB.split('---');
  final blocksC = contentC.split('---');
  print(blocksB.length);
  print(blocksC.length);
  String result = contentA;

  for (var i = 0; i < blocksB.length; i++) {
    result = result.replaceAll(blocksB[i].trim(), blocksC[i].trim());
  }

  await File('merged.md').writeAsString(result);
}
