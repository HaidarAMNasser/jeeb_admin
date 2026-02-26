part of 'delete_delivery_bloc.dart';

abstract class DeleteDeliveryState extends Equatable {
  const DeleteDeliveryState();

  @override
  List<Object?> get props => [];
}

class DeleteDeliveryInitial extends DeleteDeliveryState {
  const DeleteDeliveryInitial();
}

class DeleteDeliveryLoading extends DeleteDeliveryState {
  const DeleteDeliveryLoading();
}

class DeleteDeliverySuccess extends DeleteDeliveryState {
  const DeleteDeliverySuccess();
}

class DeleteDeliveryError extends DeleteDeliveryState {
  final String message;

  const DeleteDeliveryError({required this.message});

  @override
  List<Object?> get props => [message];
}
