part of 'delete_offer_bloc.dart';

abstract class DeleteOfferEvent extends Equatable {
  const DeleteOfferEvent();

  @override
  List<Object?> get props => [];
}

class DeleteOfferSubmitted extends DeleteOfferEvent {
  final String offerId;

  const DeleteOfferSubmitted({required this.offerId});

  @override
  List<Object> get props => [offerId];
}
