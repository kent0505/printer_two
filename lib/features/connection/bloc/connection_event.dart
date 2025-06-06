part of 'connection_bloc.dart';

@immutable
sealed class ConnectionEvent {}

class CheckConnection extends ConnectionEvent {}

class ChangeConnection extends ConnectionEvent {
  ChangeConnection({required this.connected});

  final bool connected;
}
