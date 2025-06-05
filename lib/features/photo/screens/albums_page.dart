import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/models/album.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../bloc/photo_bloc.dart';
import 'photo_page.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  static const routePath = '/AlbumsPage';

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PhotoBloc>().add(LoadPhotos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Albums'),
      body: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          if (state is PhotosLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.albums.length,
              itemBuilder: (context, index) {
                return _AlbumTile(
                  album: state.albums[index],
                );
              },
            );
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Button(
        onPressed: () {
          context.push(
            PhotoPage.routePath,
            extra: album,
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2.5),
              child: Image.file(
                album.previewFile,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                frameBuilder: frameBuilder,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  album.assetPathEntity.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: AppFonts.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  album.amount.toString(),
                  style: const TextStyle(
                    color: Color(0xff96A0A9),
                    fontSize: 14,
                    fontFamily: AppFonts.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
