part of 'offer_price_details_bloc.dart';

abstract class OfferPriceDetailsEvent extends Equatable {
  const OfferPriceDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetOfferPriceDetailsEvent extends OfferPriceDetailsEvent {
  final String offerPriceId;
  final bool withLoading;

  const GetOfferPriceDetailsEvent({required this.offerPriceId, this.withLoading = true});

  @override
  List<Object?> get props => [offerPriceId, withLoading];
}

class OnDeleteOfferPriceEvent extends OfferPriceDetailsEvent {
  final bool isLoading;
  const OnDeleteOfferPriceEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}
