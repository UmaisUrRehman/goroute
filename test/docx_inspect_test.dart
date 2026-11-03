import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Inspect zip entries of TECHNICAL_REPORT.docx', () {
    final bytes = File('TECHNICAL_REPORT.docx').readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      print('Entry: ${file.name}, size: ${file.size}');
      if (file.name == 'word/document.xml') {
        final content = String.fromCharCodes(file.content as List<int>);
        print('word/document.xml snippet: ${content.substring(0, 300)}');
        print('word/document.xml length: ${content.length}');
        print('word/document.xml end: ${content.substring(content.length - 200)}');
      }
    }
  });
}
