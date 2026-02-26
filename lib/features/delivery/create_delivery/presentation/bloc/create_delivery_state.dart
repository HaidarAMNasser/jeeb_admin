part of 'create_delivery_bloc.dart';

abstract class CreateDeliveryState extends Equatable {
  const CreateDeliveryState();

  @override
  List<Object?> get props => [];
}

class CreateDeliveryInitial extends CreateDeliveryState {
  const CreateDeliveryInitial();
}

class CreateDeliveryLoading extends CreateDeliveryState {
  const CreateDeliveryLoading();
}

class CreateDeliverySuccess extends CreateDeliveryState {
  const CreateDeliverySuccess();
}

class CreateDeliveryError extends CreateDeliveryState {
  final String message;

  const CreateDeliveryError({required this.message});

  @override
  List<Object?> get props => [message];
}
