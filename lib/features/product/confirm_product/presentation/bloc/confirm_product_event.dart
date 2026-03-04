part of 'confirm_product_bloc.dart';

abstract class ConfirmProductEvent extends Equatable {
  const ConfirmProductEvent();

  @override
  List<Object?> get props => [];
}

class ConfirmProductSubmitted extends ConfirmProductEvent {
  final String productId;
  final double newPrice;

  const ConfirmProductSubmitted({
    required this.productId,
    required this.newPrice,
  });

  @override
  List<Object> get props => [productId, newPrice];
}

