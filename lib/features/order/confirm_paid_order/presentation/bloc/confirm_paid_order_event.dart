part of 'confirm_paid_order_bloc.dart';

abstract class ConfirmPaidOrderEvent extends Equatable {
  const ConfirmPaidOrderEvent();

  @override
  List<Object?> get props => [];
}

class ConfirmPaidOrderSubmitted extends ConfirmPaidOrderEvent {
  const ConfirmPaidOrderSubmitted({
    required this.orderId,
    this.imagePayFromDelivery,
  });

  final String orderId;
  final String? imagePayFromDelivery;

  @override
  List<Object?> get props => [orderId, imagePayFromDelivery];
}
