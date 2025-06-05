import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';

class PrintablePage extends StatefulWidget {
  const PrintablePage({super.key, required this.asset});

  static const routePath = '/PrintablePage';

  final String asset;

  @override
  State<PrintablePage> createState() => _PrintablePageState();
}

class _PrintablePageState extends State<PrintablePage> {
  final screenshotController = ScreenshotController();

  File file = File('');

  void onShare() {
    shareFiles([file]);
  }

  void onPrint() async {
    final pdf = pw.Document();

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

    printPdf(pdf);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        if (mounted) {
          final byteData = await rootBundle.load(widget.asset);
          final tempDir = await getTemporaryDirectory();
          file = File('${tempDir.path}/printable.png');
          await file.writeAsBytes(byteData.buffer.asUint8List());

          if (mounted) {
            setState(() {});
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Printables',
        right: file.path.isEmpty
            ? const SizedBox(
                height: 44,
                width: 44,
                child: LoadingWidget(),
              )
            : Button(
                onPressed: onShare,
                child: const SvgWidget(Assets.share),
              ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FittedBox(
                child: Screenshot(
                  controller: screenshotController,
                  child: ImageWidget(widget.asset),
                ),
              ),
            ),
          ),
          MainButton(
            title: 'Print',
            horizontal: 16,
            active: file.path.isNotEmpty,
            onPressed: onPrint,
          ),
          const SizedBox(height: 44),
        ],
      ),
    );
  }
}
