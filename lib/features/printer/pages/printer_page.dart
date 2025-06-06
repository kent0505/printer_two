import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants.dart';
import '../../../core/models/vip.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../internet/bloc/internet_bloc.dart';
import '../../internet/widgets/no_internet.dart';
import '../../photo/screens/albums_page.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_page.dart';
import 'email_page.dart';
import 'files_page.dart';
import 'printables_page.dart';
import 'scanner_page.dart';
import 'web_page.dart';

class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  void onScanner() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      try {
        final pictures = await CunningDocumentScanner.getPictures();
        if (pictures != null && pictures.isNotEmpty && mounted) {
          context.push(ScannerPage.routePath, extra: pictures);
        }
      } catch (e) {
        logger("Scanner error: $e");
      }
    } else {
      if (mounted) {
        DialogWidget.show(
          context,
          title:
              'This feature needs camera access. Please enable it in your settings.',
          onOK: () {
            openAppSettings();
          },
        );
      }
    }
  }

  void onFiles() async {
    await pickFile().then(
      (value) {
        if (value != null && mounted) {
          context.push(
            FilesPage.routePath,
            extra: value,
          );
        }
      },
    );
  }

  void onPhotos() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.hasAccess && mounted) {
      context.push(AlbumsPage.routePath);
    } else {
      PhotoManager.openSetting();
    }
  }

  void onEmail() {
    context.push(EmailPage.routePath);
  }

  void onPrintables() {
    if (context.read<VipBloc>().state.isVip) {
      context.push(PrintablesPage.routePath);
    } else {
      context.push(
        VipPage.routePath,
        extra: Paywalls.identifier3,
      );
    }
  }

  void onWebPages() {
    if (context.read<VipBloc>().state.isVip) {
      context.push(WebPage.routePath);
    } else {
      context.push(
        VipPage.routePath,
        extra: Paywalls.identifier3,
      );
    }
  }

  void onPdf() async {
    try {
      if (!await launchUrl(
        Uri.parse(Urls.url1),
      )) {
        throw 'Could not launch url';
      }
    } catch (e) {
      logger(e);
    }
  }

  void onInvoice() async {
    try {
      if (!await launchUrl(
        Uri.parse(Urls.url2),
      )) {
        throw 'Could not launch url';
      }
    } catch (e) {
      logger(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, bool>(
      builder: (context, hasInternet) {
        return hasInternet
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _PrinterCard(
                      id: 1,
                      title: 'Scanner',
                      description: 'Scan any document',
                      onPressed: onScanner,
                    ),
                    _PrinterCard(
                      id: 2,
                      title: 'Files',
                      description: 'Scan documents from a File',
                      onPressed: onFiles,
                    ),
                    _PrinterCard(
                      id: 3,
                      title: 'Photos',
                      description: 'Print photos from gallery',
                      onPressed: onPhotos,
                    ),
                    _PrinterCard(
                      id: 4,
                      title: 'Email',
                      description: 'Print files from email client',
                      onPressed: onEmail,
                    ),
                    _PrinterCard(
                      id: 5,
                      title: 'Printables',
                      description: 'Print giftcards, planners, calendars',
                      onPressed: onPrintables,
                    ),
                    _PrinterCard(
                      id: 6,
                      title: 'Web Pages',
                      description: 'Print any website in full size',
                      onPressed: onWebPages,
                    ),
                    _PrinterCard(
                      id: 7,
                      title: 'PDF Service',
                      onPressed: onPdf,
                    ),
                    _PrinterCard(
                      id: 8,
                      title: 'Invoice',
                      onPressed: onInvoice,
                    ),
                  ],
                ),
              )
            : const NoInternet();
      },
    );
  }
}

class _PrinterCard extends StatelessWidget {
  const _PrinterCard({
    required this.id,
    required this.title,
    this.description = '',
    required this.onPressed,
  });

  final int id;
  final String title;
  final String description;
  final VoidCallback onPressed;

  String getAsset() {
    if (id == 1) return Assets.p1;
    if (id == 2) return Assets.p2;
    if (id == 3) return Assets.p3;
    if (id == 4) return Assets.p4;
    if (id == 5) return Assets.p5;
    if (id == 6) return Assets.p6;
    if (id == 7) return Assets.p7;
    return Assets.p8;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isIpad = width >= 500;
    final count = isIpad ? 3 : 2;
    final spacing = 8.0;
    final horizontalPadding = 32.0;
    final size = (width - horizontalPadding - (spacing * (count - 1))) / count;

    return Container(
      height: description.isEmpty ? 108 : 152,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<VipBloc, Vip>(
        builder: (context, state) {
          return Button(
            onPressed: state.loading ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: SvgWidget(getAsset()),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: AppFonts.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: AppFonts.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
