part of 'update_offer_bloc.dart';

abstract class UpdateOfferState extends Equatable {
  const UpdateOfferState();

  @override
  List<Object?> get props => [];
}

class UpdateOfferInitial extends UpdateOfferState {
  const UpdateOfferInitial();
}

class UpdateOfferLoading extends UpdateOfferState {
  const UpdateOfferLoading();
}

class UpdateOfferSuccess extends UpdateOfferState {
  const UpdateOfferSuccess();
}

class UpdateOfferError extends UpdateOfferState {
  final String message;

  const UpdateOfferError({required this.message});

  @override
  List<Object> get props => [message];
}
