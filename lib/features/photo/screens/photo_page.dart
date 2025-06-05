import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:photo_manager/photo_manager.dart';

import '../../../core/constants.dart';
import '../../../core/models/album.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/photo_bloc.dart';
import '../data/photo_repository.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key, required this.album});

  static const routePath = '/PhotoPage';

  final Album album;

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  List<AssetEntity> selectedAssetEntities = [];

  void onPhoto(AssetEntity value) {
    setState(() {
      if (selectedAssetEntities.contains(value)) {
        selectedAssetEntities.remove(value);
      } else {
        selectedAssetEntities.add(value);
      }
    });
  }

  void onShare() async {
    final state = context.read<PhotoBloc>().state;
    final files =
        await context.read<PhotoRepository>().getFiles(selectedAssetEntities);
    if (state is PhotosLoaded && mounted) {
      shareFiles(files);
    }
  }

  void onPrint() async {
    final state = context.read<PhotoBloc>().state;
    if (state is PhotosLoaded) {
      final pdf = pw.Document();

      final files =
          await context.read<PhotoRepository>().getFiles(selectedAssetEntities);

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

      if (mounted) printPdf(pdf);
    }
  }

  @override
  void initState() {
    super.initState();
    context
        .read<PhotoBloc>()
        .add(LoadPhotos(assetPathEntity: widget.album.assetPathEntity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: widget.album.assetPathEntity.name,
        right: Button(
          onPressed: selectedAssetEntities.isNotEmpty ? onShare : null,
          child: SvgWidget(
            Assets.share,
            color: selectedAssetEntities.isNotEmpty
                ? const Color(0xff095EF1)
                : const Color(0xff999999),
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<PhotoBloc, PhotoState>(
            builder: (context, state) {
              if (state is PhotosLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.assetEntities.length,
                  itemBuilder: (context, index) {
                    return _PhotoCard(
                      assetEntity: state.assetEntities[index],
                      bytes: state.bytes[index],
                      selected: selectedAssetEntities.contains(
                        state.assetEntities[index],
                      ),
                      onPressed: onPhoto,
                    );
                  },
                );
              }

              return const LoadingWidget();
            },
          ),
          _PrintButton(
            active: selectedAssetEntities.isNotEmpty,
            onPressed: onPrint,
          ),
        ],
      ),
    );
  }
}

class _PrintButton extends StatelessWidget {
  const _PrintButton({
    required this.active,
    required this.onPressed,
  });

  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 44,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 56,
        width: 134,
        decoration: BoxDecoration(
          color: active ? const Color(0xff095EF1) : const Color(0xff707883),
          borderRadius: BorderRadius.circular(64),
        ),
        child: Button(
          onPressed: active ? onPressed : null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgWidget(
                Assets.tab1,
                width: 34,
                height: 34,
                color: Color(0xffF2F5F8),
              ),
              SizedBox(width: 8),
              Text(
                'Print',
                style: TextStyle(
                  color: Color(0xffF2F5F8),
                  fontSize: 16,
                  fontFamily: AppFonts.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({
    required this.assetEntity,
    required this.bytes,
    required this.selected,
    required this.onPressed,
  });

  final AssetEntity assetEntity;
  final Uint8List bytes;
  final bool selected;
  final void Function(AssetEntity) onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () {
        onPressed(assetEntity);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
              frameBuilder: frameBuilder,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
          if (selected)
            const Center(
              child: SvgWidget(
                Assets.checkbox,
              ),
            ),
        ],
      ),
    );
  }
}
