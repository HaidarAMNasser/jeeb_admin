part of 'delete_merchant_bloc.dart';

abstract class DeleteMerchantState extends Equatable {
  const DeleteMerchantState();

  @override
  List<Object?> get props => [];
}

class DeleteMerchantInitial extends DeleteMerchantState {
  const DeleteMerchantInitial();
}

class DeleteMerchantLoading extends DeleteMerchantState {
  const DeleteMerchantLoading();
}

class DeleteMerchantSuccess extends DeleteMerchantState {
  const DeleteMerchantSuccess();
}

class DeleteMerchantError extends DeleteMerchantState {
  final String message;

  const DeleteMerchantError({required this.message});

  @override
  List<Object> get props => [message];
}

