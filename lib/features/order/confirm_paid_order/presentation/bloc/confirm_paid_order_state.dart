part of 'confirm_paid_order_bloc.dart';

abstract class ConfirmPaidOrderState extends Equatable {
  const ConfirmPaidOrderState();

  @override
  List<Object?> get props => [];
}

class ConfirmPaidOrderInitial extends ConfirmPaidOrderState {
  const ConfirmPaidOrderInitial();
}

class ConfirmPaidOrderLoading extends ConfirmPaidOrderState {
  const ConfirmPaidOrderLoading();
}

class ConfirmPaidOrderSuccess extends ConfirmPaidOrderState {
  const ConfirmPaidOrderSuccess();
}

class ConfirmPaidOrderError extends ConfirmPaidOrderState {
  const ConfirmPaidOrderError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
