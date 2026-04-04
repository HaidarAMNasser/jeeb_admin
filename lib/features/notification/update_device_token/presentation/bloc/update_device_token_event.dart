part of 'update_device_token_bloc.dart';

abstract class UpdateDeviceTokenEvent extends Equatable {
  const UpdateDeviceTokenEvent();

  @override
  List<Object?> get props => [];
}

/// Pushes [token] to the backend when allowed; [forceSync] skips dedup (e.g. after login).
class SubmitFcmTokenRequested extends UpdateDeviceTokenEvent {
  final String token;
  final bool forceSync;

  const SubmitFcmTokenRequested({
    required this.token,
    this.forceSync = false,
  });

  @override
  List<Object?> get props => [token, forceSync];
}
