part of 'order_cancel_bloc.dart';

abstract class OrderCancelState extends Equatable {
  const OrderCancelState();

  @override
  List<Object?> get props => [];
}

class OrderCancelInitial extends OrderCancelState {
  const OrderCancelInitial();
}

class OrderCancelLoading extends OrderCancelState {
  const OrderCancelLoading();
}

class OrderCancelSuccess extends OrderCancelState {
  const OrderCancelSuccess();
}

class OrderCancelError extends OrderCancelState {
  final String message;

  const OrderCancelError({required this.message});

  @override
  List<Object?> get props => [message];
}

