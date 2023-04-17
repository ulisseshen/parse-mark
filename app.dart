import 'dart:convert';
import 'dart:io';

Future<void> processFile(String file) async {
  final fileStream = File(file).openRead();
  final lines = utf8.decoder
      .bind(fileStream)
      .transform(const LineSplitter())
      .map((l) => l.trimRight());

  var result = '';
  var insideCodeBlock = false;
  var currentBlock = '';

  await for (final line in lines) {
    if (line.startsWith('```')) {
      insideCodeBlock = !insideCodeBlock;
    }

    if (!insideCodeBlock) {
      if (line.isEmpty) {
        if (currentBlock.trim().isNotEmpty) {
          result += currentBlock.trim() + '\n\n---\n\n';
          currentBlock = '';
        }
      } else {
        currentBlock += line + '\n';
      }
    }
  }

  if (currentBlock.trim().isNotEmpty) {
    result += currentBlock.trim() + '\n\n---\n\n';
  }

  final withoutHtmlTags = result.replaceAll(RegExp(r'<[^>]+>'), '');

  final filteredLines =
      withoutHtmlTags.split('\n').where((line) => line.trim().isNotEmpty);

  final plainText = filteredLines.join('\n');

  final noConsecutiveSeparators = plainText
      .replaceAll(RegExp(r'(---\n){2,}'), '---\n')
      .replaceAll(RegExp(r'---\n```\n---(\n)?', multiLine: true), '---\n');

  await File('output_dart.md').writeAsString(noConsecutiveSeparators);
}

Future<void> main() async {
  await processFile('exemplo.md');
}
