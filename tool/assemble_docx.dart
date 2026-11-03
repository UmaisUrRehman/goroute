import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  final sampleBytes = File('sample_valid.docx').readAsBytesSync();
  final sampleArchive = ZipDecoder().decodeBytes(sampleBytes);

  // Read current document.xml and images
  final currentBytes = File('TECHNICAL_REPORT.docx').readAsBytesSync();
  final currentArchive = ZipDecoder().decodeBytes(currentBytes);

  ArchiveFile? docXmlFile;
  final imageFiles = <ArchiveFile>[];

  for (final f in currentArchive) {
    if (f.name == 'word/document.xml') {
      docXmlFile = f;
    } else if (f.name.startsWith('word/media/')) {
      imageFiles.add(f);
    }
  }

  final newArchive = Archive();

  // Copy standard valid parts from sample
  for (final f in sampleArchive) {
    if (f.name == 'word/document.xml') {
      newArchive.addFile(ArchiveFile('word/document.xml', docXmlFile!.size, docXmlFile.content));
    } else if (f.name == '[Content_Types].xml') {
      var contentTypesStr = String.fromCharCodes(f.content as List<int>);
      // Add png default extension
      contentTypesStr = contentTypesStr.replaceFirst(
        '<Default Extension="xml"',
        '<Default Extension="png" ContentType="image/png"/><Default Extension="xml"',
      );
      final bytes = contentTypesStr.codeUnits;
      newArchive.addFile(ArchiveFile('[Content_Types].xml', bytes.length, bytes));
    } else if (f.name == 'word/_rels/document.xml.rels') {
      var relsStr = String.fromCharCodes(f.content as List<int>);
      // Add relationships for images
      var imgRels = '';
      for (int i = 5; i <= 13; i++) {
        imgRels += '<Relationship Id="rId$i" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/image${i - 4}.png"/>';
      }
      relsStr = relsStr.replaceFirst('</Relationships>', '$imgRels</Relationships>');
      final bytes = relsStr.codeUnits;
      newArchive.addFile(ArchiveFile('word/_rels/document.xml.rels', bytes.length, bytes));
    } else if (f.name == 'word/styles.xml') {
      // Inject Times New Roman and font sizes
      final customStyles = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:docDefaults>
    <w:rPrDefault>
      <w:rPr>
        <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
        <w:sz w:val="32"/>
        <w:szCs w:val="32"/>
        <w:color w:val="1A1A1A"/>
      </w:rPr>
    </w:rPrDefault>
  </w:docDefaults>
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
    <w:pPr>
      <w:spacing w:line="360" w:lineRule="auto" w:after="160"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
      <w:sz w:val="32"/>
      <w:szCs w:val="32"/>
    </w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Heading1">
    <w:name w:val="heading 1"/>
    <w:pPr>
      <w:spacing w:before="360" w:after="160"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
      <w:b/>
      <w:bCs/>
      <w:sz w:val="44"/>
      <w:szCs w:val="44"/>
      <w:color w:val="0D2C54"/>
    </w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Heading2">
    <w:name w:val="heading 2"/>
    <w:pPr>
      <w:spacing w:before="280" w:after="120"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
      <w:b/>
      <w:bCs/>
      <w:sz w:val="40"/>
      <w:szCs w:val="40"/>
      <w:color w:val="185A9D"/>
    </w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Heading3">
    <w:name w:val="heading 3"/>
    <w:pPr>
      <w:spacing w:before="200" w:after="100"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
      <w:sz w:val="36"/>
      <w:szCs w:val="36"/>
      <w:color w:val="2C3E50"/>
    </w:rPr>
  </w:style>
</w:styles>''';
      final bytes = customStyles.codeUnits;
      newArchive.addFile(ArchiveFile('word/styles.xml', bytes.length, bytes));
    } else {
      newArchive.addFile(f);
    }
  }

  // Add media files
  for (final img in imageFiles) {
    newArchive.addFile(img);
  }

  final encoded = ZipEncoder().encode(newArchive)!;
  File('TECHNICAL_REPORT.docx').writeAsBytesSync(encoded);

  // Copy to brain artifact directory
  final artifactPath = r'C:\Users\Umais\.gemini\antigravity\brain\4d21189b-211f-4ae5-af9d-cfbaa7f3edda\TECHNICAL_REPORT.docx';
  File(artifactPath).writeAsBytesSync(encoded);

  print('Assembled valid docx based on Microsoft Word template package!');
}
