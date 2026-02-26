part of 'delivery_details_bloc.dart';

abstract class DeliveryDetailsEvent extends Equatable {
  const DeliveryDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetDeliveryManDetailsEvent extends DeliveryDetailsEvent {
  final String id;

  const GetDeliveryManDetailsEvent({required this.id});

  @override
  List<Object> get props => [id];
}
