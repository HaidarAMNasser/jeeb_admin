import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/features/notification/update_device_token/data/repositories/update_device_token_repository.dart';

part 'update_device_token_event.dart';
part 'update_device_token_state.dart';

class UpdateDeviceTokenBloc
    extends Bloc<UpdateDeviceTokenEvent, UpdateDeviceTokenState> {
  final UpdateDeviceTokenRepository _repository;
  final StorageService _storage;

  UpdateDeviceTokenBloc(this._repository, this._storage)
      : super(const UpdateDeviceTokenInitial()) {
    on<SubmitFcmTokenRequested>(_onSubmit);
  }

  String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    return 'android';
  }

  Future<void> _onSubmit(
    SubmitFcmTokenRequested event,
    Emitter<UpdateDeviceTokenState> emit,
  ) async {
    final token = event.token;
    if (token.isEmpty) return;

    final lastSynced = await _storage.getFcmLastSyncedToken();
    if (!event.forceSync && lastSynced != null && token == lastSynced) {
      return;
    }

    final isLoggedIn = await _storage.isLoggedIn();
    final access = await _storage.getUserToken();
    if (!isLoggedIn || access.isEmpty) {
      return;
    }

    final result = await _repository.updateDeviceToken(
      token: token,
      platform: _platform,
    );

    await result.fold(
      (_) async {},
      (_) async {
        await _storage.setFcmLastSyncedToken(token);
      },
    );
  }
}
