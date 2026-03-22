import 'package:equatable/equatable.dart';

/// One product line in an offer create/update payload (`productId` + `quantity`).
class OfferProductLine extends Equatable {
  final String productId;
  final int quantity;

  const OfferProductLine({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}
