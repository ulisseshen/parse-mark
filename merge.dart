import 'dart:io';

Future<void> main() async {
  final page = File('exemplo.md');
  final parsed = File('output_dart.md');
  final translated = File('traduzido.md');

  final contentPage = page.readAsStringSync();
  final contentParsed = parsed.readAsStringSync();
  final contentTranslated = translated.readAsStringSync();

  final blocksParsed = contentParsed.split('---');
  final blocksTranslated = contentTranslated.split('---');
  String merged = contentPage;

  for (var i = 0; i < blocksParsed.length; i++) {
    merged =
        merged.replaceAll(blocksParsed[i].trim(), blocksTranslated[i].trim());
  }

  await File('merged.md').writeAsString(merged);
}
