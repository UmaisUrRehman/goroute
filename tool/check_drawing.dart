import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  final currentBytes = File('TECHNICAL_REPORT.docx').readAsBytesSync();
  final currentArchive = ZipDecoder().decodeBytes(currentBytes);

  for (final f in currentArchive) {
    if (f.name == 'word/document.xml') {
      final text = String.fromCharCodes(f.content as List<int>);
      // Find drawings
      final regex = RegExp(r'<w:drawing>.*?</w:drawing>');
      final matches = regex.allMatches(text);
      print('Number of drawing tags: ${matches.length}');
      if (matches.isNotEmpty) {
        print('Sample drawing: ${matches.first.group(0)}');
      }
    }
  }
}
