part of 'update_delivery_bloc.dart';

abstract class UpdateDeliveryState extends Equatable {
  const UpdateDeliveryState();

  @override
  List<Object?> get props => [];
}

class UpdateDeliveryInitial extends UpdateDeliveryState {
  const UpdateDeliveryInitial();
}

class UpdateDeliveryLoading extends UpdateDeliveryState {
  const UpdateDeliveryLoading();
}

class UpdateDeliverySuccess extends UpdateDeliveryState {
  const UpdateDeliverySuccess();
}

class UpdateDeliveryError extends UpdateDeliveryState {
  final String message;

  const UpdateDeliveryError({required this.message});

  @override
  List<Object?> get props => [message];
}
