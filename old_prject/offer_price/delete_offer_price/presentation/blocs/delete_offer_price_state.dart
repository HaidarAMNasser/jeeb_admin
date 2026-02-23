part of 'delete_offer_price_bloc.dart';
abstract class DeleteOfferPriceState extends Equatable {
  const DeleteOfferPriceState();

  @override
  List<Object> get props => [];
}

class DeleteOfferPriceInitialState extends DeleteOfferPriceState {
  const DeleteOfferPriceInitialState();

  @override
  List<Object> get props => [];
}

class DeleteOfferPriceLoadingState extends DeleteOfferPriceState {
  const DeleteOfferPriceLoadingState();

  @override
  List<Object> get props => [];
}

class DeleteOfferPriceSuccessState extends DeleteOfferPriceState {
  final BaseResponseEntity baseResponseEntity;

  const DeleteOfferPriceSuccessState({required this.baseResponseEntity});

  @override
  List<Object> get props => [baseResponseEntity];
}

class DeleteOfferPriceErrorState extends DeleteOfferPriceState {
  final String message;

  const DeleteOfferPriceErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
