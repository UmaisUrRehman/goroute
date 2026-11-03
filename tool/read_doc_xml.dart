import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  final currentBytes = File('TECHNICAL_REPORT.docx').readAsBytesSync();
  final currentArchive = ZipDecoder().decodeBytes(currentBytes);

  for (final f in currentArchive) {
    if (f.name == 'word/document.xml') {
      final text = String.fromCharCodes(f.content as List<int>);
      print('Snippet from 0 to 500:');
      print(text.substring(0, 500));
      print('Snippet around 1000 to 1500:');
      print(text.substring(1000, 1500));
    }
  }
}
