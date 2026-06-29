part of 'reset_merchant_password_bloc.dart';

abstract class ResetMerchantPasswordState extends Equatable {
  const ResetMerchantPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetMerchantPasswordInitial extends ResetMerchantPasswordState {
  const ResetMerchantPasswordInitial();
}

class ResetMerchantPasswordLoading extends ResetMerchantPasswordState {
  const ResetMerchantPasswordLoading();
}

class ResetMerchantPasswordSuccess extends ResetMerchantPasswordState {
  const ResetMerchantPasswordSuccess();
}

class ResetMerchantPasswordError extends ResetMerchantPasswordState {
  final String message;

  const ResetMerchantPasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}
