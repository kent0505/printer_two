part of 'photo_bloc.dart';

@immutable
sealed class PhotoEvent {}

final class LoadPhotos extends PhotoEvent {
  LoadPhotos({this.assetPathEntity});

  final AssetPathEntity? assetPathEntity;
}
