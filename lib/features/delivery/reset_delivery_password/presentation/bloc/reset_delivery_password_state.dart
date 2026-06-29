part of 'reset_delivery_password_bloc.dart';

abstract class ResetDeliveryPasswordState extends Equatable {
  const ResetDeliveryPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetDeliveryPasswordInitial extends ResetDeliveryPasswordState {
  const ResetDeliveryPasswordInitial();
}

class ResetDeliveryPasswordLoading extends ResetDeliveryPasswordState {
  const ResetDeliveryPasswordLoading();
}

class ResetDeliveryPasswordSuccess extends ResetDeliveryPasswordState {
  const ResetDeliveryPasswordSuccess();
}

class ResetDeliveryPasswordError extends ResetDeliveryPasswordState {
  final String message;

  const ResetDeliveryPasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}
