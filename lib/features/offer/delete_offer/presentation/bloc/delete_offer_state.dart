part of 'delete_offer_bloc.dart';

abstract class DeleteOfferState extends Equatable {
  const DeleteOfferState();

  @override
  List<Object?> get props => [];
}

class DeleteOfferInitial extends DeleteOfferState {
  const DeleteOfferInitial();
}

class DeleteOfferLoading extends DeleteOfferState {
  const DeleteOfferLoading();
}

class DeleteOfferSuccess extends DeleteOfferState {
  const DeleteOfferSuccess();
}

class DeleteOfferError extends DeleteOfferState {
  final String message;

  const DeleteOfferError({required this.message});

  @override
  List<Object> get props => [message];
}
