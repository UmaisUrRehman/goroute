import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  final sampleBytes = File('sample_valid.docx').readAsBytesSync();
  final sampleArchive = ZipDecoder().decodeBytes(sampleBytes);

  final testArchive = Archive();
  for (final f in sampleArchive) {
    if (f.name == 'word/document.xml') {
      final minimalDocXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p>
      <w:pPr>
        <w:rPr>
          <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>
          <w:b/>
          <w:sz w:val="44"/>
        </w:rPr>
      </w:pPr>
      <w:r>
        <w:rPr>
          <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>
          <w:b/>
          <w:sz w:val="44"/>
        </w:rPr>
        <w:t>Technical Architecture Report</w:t>
      </w:r>
    </w:p>
    <w:p>
      <w:r>
        <w:rPr>
          <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>
          <w:sz w:val="32"/>
        </w:rPr>
        <w:t>Author: Antigravity Mobile Engineering</w:t>
      </w:r>
    </w:p>
    <w:sectPr>
      <w:pgSz w:w="12240" w:h="15840"/>
      <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/>
    </w:sectPr>
  </w:body>
</w:document>''';
      final b = minimalDocXml.codeUnits;
      testArchive.addFile(ArchiveFile('word/document.xml', b.length, b));
    } else {
      testArchive.addFile(f);
    }
  }

  final encoded = ZipEncoder().encode(testArchive)!;
  File('test_roundtrip.docx').writeAsBytesSync(encoded);
  print('Updated test_roundtrip.docx with custom minimal text');
}
