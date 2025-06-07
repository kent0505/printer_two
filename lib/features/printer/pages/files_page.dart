import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key, required this.file});

  static const routePath = '/FilesPage';

  final File file;

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  final pdf = pw.Document();
  Uint8List? imageBytes;

  void createPdf() async {
    try {
      final path = widget.file.path.toLowerCase();

      if (path.endsWith('.txt')) {
        final textContent = await widget.file.readAsString();
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context context) {
              return pw.Text(
                textContent,
                style: const pw.TextStyle(fontSize: 14),
              );
            },
          ),
        );
      } else {
        imageBytes = await widget.file.readAsBytes();

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(imageBytes!),
                ),
              );
            },
          ),
        );
      }
    } catch (e) {
      logger(e);
    }
  }

  void printDocument() {
    if (widget.file.path.toLowerCase().endsWith('.pdf')) {
      Printing.layoutPdf(onLayout: (_) => widget.file.readAsBytes());
    } else {
      printPDF(pdf);
    }
  }

  @override
  void initState() {
    super.initState();
    createPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Files',
        right: Button(
          onPressed: printDocument,
          child: const SvgWidget(Assets.tab1),
        ),
      ),
      body: PdfPreview(
        useActions: false,
        pdfPreviewPageDecoration: BoxDecoration(color: const Color(0xffF2F5F8)),
        scrollViewDecoration: BoxDecoration(color: const Color(0xffd5d5d5)),
        loadingWidget: const LoadingWidget(),
        build: (format) {
          if (widget.file.path.toLowerCase().endsWith('.pdf')) {
            return imageBytes!;
          }

          return pdf.save();
        },
        onError: (context, error) {
          return const Text(
            'Unsupported format',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: AppFonts.w700,
            ),
          );
        },
      ),
    );
  }
}
