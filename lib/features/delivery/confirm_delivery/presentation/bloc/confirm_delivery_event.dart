part of 'confirm_delivery_bloc.dart';

abstract class ConfirmDeliveryEvent extends Equatable {
  const ConfirmDeliveryEvent();

  @override
  List<Object?> get props => [];
}

class ConfirmDeliverySubmitted extends ConfirmDeliveryEvent {
  final String deliveryManId;

  const ConfirmDeliverySubmitted({required this.deliveryManId});

  @override
  List<Object> get props => [deliveryManId];
}

