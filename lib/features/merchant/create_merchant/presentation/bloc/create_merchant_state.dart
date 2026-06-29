part of 'create_merchant_bloc.dart';

abstract class CreateMerchantState extends Equatable {
  const CreateMerchantState();

  @override
  List<Object> get props => [];
}

class CreateMerchantInitial extends CreateMerchantState {
  const CreateMerchantInitial();
}

class CreateMerchantLoading extends CreateMerchantState {
  const CreateMerchantLoading();
}

class CreateMerchantSuccess extends CreateMerchantState {
  const CreateMerchantSuccess();
}

class CreateMerchantError extends CreateMerchantState {
  final String message;

  const CreateMerchantError({required this.message});

  @override
  List<Object> get props => [message];
}
