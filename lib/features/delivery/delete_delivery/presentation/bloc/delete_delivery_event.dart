part of 'delete_delivery_bloc.dart';

abstract class DeleteDeliveryEvent extends Equatable {
  const DeleteDeliveryEvent();

  @override
  List<Object> get props => [];
}

class DeleteDeliverySubmitted extends DeleteDeliveryEvent {
  final String deliveryManId;

  const DeleteDeliverySubmitted({required this.deliveryManId});

  @override
  List<Object> get props => [deliveryManId];
}
