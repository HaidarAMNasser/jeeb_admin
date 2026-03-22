part of 'update_merchant_bloc.dart';

abstract class UpdateMerchantState extends Equatable {
  const UpdateMerchantState();

  @override
  List<Object?> get props => [];
}

class UpdateMerchantInitial extends UpdateMerchantState {
  const UpdateMerchantInitial();
}

class UpdateMerchantLoading extends UpdateMerchantState {
  const UpdateMerchantLoading();
}

class UpdateMerchantSuccess extends UpdateMerchantState {
  const UpdateMerchantSuccess();
}

class UpdateMerchantError extends UpdateMerchantState {
  final String message;

  const UpdateMerchantError({required this.message});

  @override
  List<Object?> get props => [message];
}
