part of 'order_complete_bloc.dart';

abstract class OrderCompleteEvent extends Equatable {
  const OrderCompleteEvent();

  @override
  List<Object> get props => [];
}

class CompleteOrderEvent extends OrderCompleteEvent {
  final String id;

  const CompleteOrderEvent(this.id);

  @override
  List<Object> get props => [id];
}

