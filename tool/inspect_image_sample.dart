import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  final bytes = File('sample_with_image.docx').readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(bytes);

  for (final f in archive) {
    if (f.name == 'word/document.xml') {
      final text = String.fromCharCodes(f.content as List<int>);
      print('=== sample_with_image word/document.xml ===');
      print(text);
    } else if (f.name == 'word/_rels/document.xml.rels') {
      final text = String.fromCharCodes(f.content as List<int>);
      print('=== sample_with_image word/_rels/document.xml.rels ===');
      print(text);
    }
  }
}
