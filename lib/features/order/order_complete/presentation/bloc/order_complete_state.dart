part of 'order_complete_bloc.dart';

abstract class OrderCompleteState extends Equatable {
  const OrderCompleteState();

  @override
  List<Object?> get props => [];
}

class OrderCompleteInitial extends OrderCompleteState {
  const OrderCompleteInitial();
}

class OrderCompleteLoading extends OrderCompleteState {
  const OrderCompleteLoading();
}

class OrderCompleteSuccess extends OrderCompleteState {
  const OrderCompleteSuccess();
}

class OrderCompleteError extends OrderCompleteState {
  final String message;

  const OrderCompleteError({required this.message});

  @override
  List<Object?> get props => [message];
}

