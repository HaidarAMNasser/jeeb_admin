part of 'update_offer_price_bloc.dart';

abstract class OfferPriceUpdateState extends Equatable {
  const OfferPriceUpdateState();

  @override
  List<Object> get props => [];
}

class OfferPriceUpdateInitial extends OfferPriceUpdateState {}

class OfferPriceUpdateLoading extends OfferPriceUpdateState {}

class OfferPriceUpdateSuccess extends OfferPriceUpdateState {
  final OfferPriceEntity offerPriceEntity;

  const OfferPriceUpdateSuccess({required this.offerPriceEntity});

  @override
  List<Object> get props => [offerPriceEntity];
}

class OfferPriceUpdateError extends OfferPriceUpdateState {
  final String message;
  final List<CreateProductEntity> details;
  final List<PaymentMethodEntryOffer> payments;
  const OfferPriceUpdateError({
    required this.message,
    required this.details,
    required this.payments,
  });

  @override
  List<Object> get props => [message];
}
