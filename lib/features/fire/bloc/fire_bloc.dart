import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/fire_repository.dart';

part 'fire_event.dart';

class FireBloc extends Bloc<FireEvent, bool> {
  final FireRepository _repository;

  FireBloc({required FireRepository repository})
      : _repository = repository,
        super(false) {
    on<FireEvent>(
      (event, emit) => switch (event) {
        GetFireData() => _getFireData(event, emit),
      },
    );
  }

  void _getFireData(
    GetFireData event,
    Emitter<bool> emit,
  ) async {
    final hasInvoice = await _repository.checkInvoice();
    emit(hasInvoice);
  }
}
