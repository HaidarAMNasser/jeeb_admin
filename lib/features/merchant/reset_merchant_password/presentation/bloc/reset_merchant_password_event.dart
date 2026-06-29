part of 'reset_merchant_password_bloc.dart';

abstract class ResetMerchantPasswordEvent extends Equatable {
  const ResetMerchantPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetMerchantPasswordSubmitted extends ResetMerchantPasswordEvent {
  final String merchantId;
  final String password;

  const ResetMerchantPasswordSubmitted({
    required this.merchantId,
    required this.password,
  });

  @override
  List<Object?> get props => [merchantId, password];
}
