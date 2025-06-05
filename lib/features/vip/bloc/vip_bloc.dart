import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/models/vip.dart';
import '../../../core/utils.dart';
import '../data/vip_repository.dart';

part 'vip_event.dart';

class VipBloc extends Bloc<VipEvent, Vip> {
  final VipRepository _repository;

  VipBloc({required VipRepository repository})
      : _repository = repository,
        super(Vip()) {
    on<VipEvent>(
      (event, emit) => switch (event) {
        CheckVip() => _checkVip(event, emit),
      },
    );
  }

  void _checkVip(
    CheckVip event,
    Emitter<Vip> emit,
  ) async {
    if (Platform.isIOS) {
      emit(Vip(loading: true));

      try {
        late String identifier;
        if (event.initial) {
          final showCount = _repository.getShowCount();
          final isFirstOrSecondShow = showCount == 1 || showCount == 2;
          identifier =
              isFirstOrSecondShow ? Paywalls.identifier4 : Paywalls.identifier1;
          await _repository.saveShowCount(showCount + 1);
        } else {
          identifier = event.identifier;
        }

        final isVip = await _repository.getVip();
        final offering = await _repository.getOffering(identifier);

        emit(Vip(
          isVip: isVip,
          offering: offering,
        ));
      } catch (e) {
        logger(e);
        emit(Vip());
      }
    } else {
      emit(Vip(isVip: true));
    }
  }
}
