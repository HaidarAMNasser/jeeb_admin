part of 'delete_offer_price_bloc.dart';

abstract class DeleteOfferPriceEvent {
  const DeleteOfferPriceEvent();
}

class DeleteOfferPriceSubmitted extends DeleteOfferPriceEvent {
  final bool withLoading;
  final String id;

  const DeleteOfferPriceSubmitted({
    this.withLoading = true,
    required this.id,
  });
}
