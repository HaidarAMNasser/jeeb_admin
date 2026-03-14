part of 'update_offer_bloc.dart';

abstract class UpdateOfferEvent extends Equatable {
  const UpdateOfferEvent();

  @override
  List<Object?> get props => [];
}

class UpdateOfferSubmitted extends UpdateOfferEvent {
  final String id;
  final String name;
  final String description;
  final List<String> productIds;
  final DateTime? startDate;
  final DateTime? endDate;
  final String discountType;
  final num discountValue;

  const UpdateOfferSubmitted({
    required this.id,
    required this.name,
    required this.description,
    required this.productIds,
    this.startDate,
    this.endDate,
    required this.discountType,
    required this.discountValue,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        productIds,
        startDate,
        endDate,
        discountType,
        discountValue,
      ];
}
