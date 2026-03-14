part of 'confirm_delivery_bloc.dart';

abstract class ConfirmDeliveryState extends Equatable {
  const ConfirmDeliveryState();

  @override
  List<Object?> get props => [];
}

class ConfirmDeliveryInitial extends ConfirmDeliveryState {
  const ConfirmDeliveryInitial();
}

class ConfirmDeliveryLoading extends ConfirmDeliveryState {
  const ConfirmDeliveryLoading();
}

class ConfirmDeliverySuccess extends ConfirmDeliveryState {
  const ConfirmDeliverySuccess();
}

class ConfirmDeliveryError extends ConfirmDeliveryState {
  final String message;

  const ConfirmDeliveryError({required this.message});

  @override
  List<Object> get props => [message];
}

