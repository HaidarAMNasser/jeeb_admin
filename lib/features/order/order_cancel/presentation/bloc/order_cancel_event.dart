part of 'order_cancel_bloc.dart';

abstract class OrderCancelEvent extends Equatable {
  const OrderCancelEvent();

  @override
  List<Object> get props => [];
}

class CancelOrderEvent extends OrderCancelEvent {
  final String id;

  const CancelOrderEvent(this.id);

  @override
  List<Object> get props => [id];
}

