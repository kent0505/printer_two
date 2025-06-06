import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  static const routePath = '/WebPage';

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  InAppWebViewController? webViewController;

  void onLeft() async {
    try {
      if (await webViewController!.canGoBack()) {
        await webViewController!.goBack();
      }
    } catch (e) {
      logger(e);
    }
  }

  void onRight() async {
    try {
      if (await webViewController!.canGoForward()) {
        await webViewController!.goForward();
      }
    } catch (e) {
      logger(e);
    }
  }

  void onReload() async {
    try {
      if (webViewController != null) {
        await webViewController!.reload();
      }
    } catch (e) {
      logger(e);
    }
  }

  void onPrint() async {
    try {
      Uint8List? bytes = await webViewController!.takeScreenshot();
      if (bytes == null) return;

      final pdf = pw.Document();
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

      printPDF(pdf);
    } catch (e) {
      logger(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Web Pages',
        right: Button(
          onPressed: onPrint,
          child: const SvgWidget(Assets.tab1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri('https://google.com'),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                logger("Page started loading: $url");
              },
              onLoadStop: (controller, url) async {
                logger("Page finished loading: $url");
              },
              onReceivedError: (controller, request, error) {
                logger("Error: ${error.description}");
              },
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  onPressed: onLeft,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                Button(
                  onPressed: onRight,
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                Button(
                  onPressed: onReload,
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
