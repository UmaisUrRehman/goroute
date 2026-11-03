import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  final bytes = File('sample_valid.docx').readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(bytes);
  for (final file in archive) {
    print('Sample Entry: ${file.name}');
    if (file.name == '[Content_Types].xml' || file.name == 'word/_rels/document.xml.rels' || file.name == '_rels/.rels') {
      print('=== ${file.name} ===');
      print(String.fromCharCodes(file.content as List<int>));
    }
  }
}
