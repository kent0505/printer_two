import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'connection_event.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, bool> {
  ConnectionBloc() : super(true) {
    on<ConnectionEvent>(
      (event, emit) => switch (event) {
        CheckConnection() => _checkConnection(event, emit),
        ChangeConnection() => changeConnection(event, emit),
      },
    );
  }

  void _checkConnection(
    CheckConnection event,
    Emitter<bool> emit,
  ) {
    Connectivity().onConnectivityChanged.listen((result) {
      final connected = result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);
      add(ChangeConnection(connected: connected));
    });
  }

  void changeConnection(
    ChangeConnection event,
    Emitter<bool> emit,
  ) {
    emit(event.connected);
  }
}
