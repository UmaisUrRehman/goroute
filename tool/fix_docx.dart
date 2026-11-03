import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  final inputBytes = File('TECHNICAL_REPORT.docx').readAsBytesSync();
  final srcArchive = ZipDecoder().decodeBytes(inputBytes);

  final newArchive = Archive();

  for (final file in srcArchive) {
    // Replace backslashes with forward slashes for OPC standard compliance!
    final normalizedName = file.name.replaceAll(r'\', '/');
    print('Normalizing: ${file.name} -> $normalizedName');

    List<int> content = file.content as List<int>;

    // Also check word/document.xml.rels target paths
    if (normalizedName == 'word/_rels/document.xml.rels') {
      var xmlStr = String.fromCharCodes(content);
      xmlStr = xmlStr.replaceAll(r'\', '/');
      content = xmlStr.codeUnits;
    }

    newArchive.addFile(ArchiveFile(normalizedName, content.length, content));
  }

  final encoded = ZipEncoder().encode(newArchive)!;
  File('TECHNICAL_REPORT.docx').writeAsBytesSync(encoded);

  // Copy to brain artifact directory as well
  final artifactPath = r'C:\Users\Umais\.gemini\antigravity\brain\4d21189b-211f-4ae5-af9d-cfbaa7f3edda\TECHNICAL_REPORT.docx';
  File(artifactPath).writeAsBytesSync(encoded);

  print('TECHNICAL_REPORT.docx re-encoded with forward slashes successfully!');
}
