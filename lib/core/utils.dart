import 'dart:developer' as developer;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

void logger(Object message) => developer.log(message.toString());

void printPdf(Document pdf) {
  try {
    Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  } catch (e) {
    logger(e);
  }
}

void shareFiles(List<File> files) async {
  try {
    await Share.shareXFiles(
      List.generate(
        files.length,
        (index) {
          return XFile(files[index].path);
        },
      ),
      sharePositionOrigin: Rect.fromLTWH(100, 100, 200, 200),
    );
  } catch (e) {
    logger(e);
  }
}

Future<File?> pickFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'png', 'jpg'],
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
  } catch (e) {
    logger(e);
  }
  return null;
}
