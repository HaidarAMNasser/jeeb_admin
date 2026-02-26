part of 'delete_merchant_bloc.dart';

abstract class DeleteMerchantEvent extends Equatable {
  const DeleteMerchantEvent();

  @override
  List<Object?> get props => [];
}

class DeleteMerchantSubmitted extends DeleteMerchantEvent {
  final String merchantId;

  const DeleteMerchantSubmitted({required this.merchantId});

  @override
  List<Object> get props => [merchantId];
}

