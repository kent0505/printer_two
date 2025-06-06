import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/snack_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../pro/bloc/pro_bloc.dart';
import '../../pro/screens/pro_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.paths});

  static const routePath = '/ScannerPage';

  final List<String> paths;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  List<File> files = [];
  // FirebaseData data = FirebaseData();
  bool isPro = false;

  void onCopyText() async {
    if (isPro) {
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(
        InputImage.fromFile(files.first),
      );
      final text = recognizedText.text;
      logger(text);
      textRecognizer.close();
      if (text.isNotEmpty) {
        await Clipboard.setData(ClipboardData(text: text));
      }
      if (mounted) {
        SnackWidget.show(
          context,
          text.isEmpty ? 'Text not found' : 'Copied to clipboard',
        );
      }
    } else {
      logger('XYZ');
      context.push(
        ProPage.routePath,
        extra: Paywalls.identifier3,
      );
    }
  }

  void onAddImage() async {
    await CunningDocumentScanner.getPictures().then((value) {
      if (value != null && mounted) {
        for (String path in value) {
          files.add(File(path));
        }
        setState(() {});
      }
    });
  }

  void onShare() {
    if (isPro) {
      shareFiles(files);
    } else {
      context.push(
        ProPage.routePath,
        extra: Paywalls.identifier3,
      );
    }
  }

  void onPrint() async {
    if (isPro) {
      final pdf = pw.Document();

      for (final file in files) {
        final bytes = await file.readAsBytes();

        pdf.addPage(
          pw.Page(
            margin: pw.EdgeInsets.zero,
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(bytes),
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
      }

      printPDF(pdf);
    } else {
      context.push(
        ProPage.routePath,
        extra: Paywalls.identifier3,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // data = context.read<FirebaseBloc>().state;
    isPro = context.read<ProBloc>().state.isPro;
    files = List.generate(
      widget.paths.length,
      (index) {
        return File(widget.paths[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Scanned Document'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              itemBuilder: (context, index) {
                return Image.file(
                  files[index],
                  frameBuilder: frameBuilder,
                );
              },
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 16),
                Button(
                  onPressed: onCopyText,
                  child: const SvgWidget(
                    Assets.copy1,
                    width: 24,
                    height: 24,
                  ),
                ),
                const Spacer(),
                Button(
                  onPressed: onAddImage,
                  child: const SvgWidget(Assets.image),
                ),
                const Spacer(),
                Button(
                  onPressed: onShare,
                  child: const SvgWidget(Assets.share),
                ),
                const Spacer(),
                Button(
                  onPressed: onPrint,
                  child: const SvgWidget(Assets.tab1),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          const SizedBox(height: 34),
        ],
      ),
    );
  }
}
