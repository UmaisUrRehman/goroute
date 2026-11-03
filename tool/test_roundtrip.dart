import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  final sampleBytes = File('sample_valid.docx').readAsBytesSync();
  final sampleArchive = ZipDecoder().decodeBytes(sampleBytes);

  final testArchive = Archive();
  for (final f in sampleArchive) {
    testArchive.addFile(f);
  }

  final encoded = ZipEncoder().encode(testArchive)!;
  File('test_roundtrip.docx').writeAsBytesSync(encoded);
  print('Created test_roundtrip.docx');
}
