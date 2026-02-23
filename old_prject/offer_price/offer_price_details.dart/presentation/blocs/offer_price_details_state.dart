part of 'offer_price_details_bloc.dart';

abstract class OfferPriceDetailsState extends Equatable {
  const OfferPriceDetailsState();

  @override
  List<Object?> get props => [];
}

class OfferPriceDetailsInitial extends OfferPriceDetailsState {
  const OfferPriceDetailsInitial();
}

class OfferPriceDetailsLoading extends OfferPriceDetailsState {
  const OfferPriceDetailsLoading();
}

class OfferPriceDetailsSuccess extends OfferPriceDetailsState {
  final OfferPriceSingleEntity offerPriceDetails;
  final bool withLoading;

  const OfferPriceDetailsSuccess({
    required this.offerPriceDetails,
    this.withLoading = false,
  });

  OfferPriceDetailsSuccess copyWith({
    OfferPriceSingleEntity? offerPriceDetails,
    bool? withLoading,
  }) {
    return OfferPriceDetailsSuccess(
      offerPriceDetails: offerPriceDetails ?? this.offerPriceDetails,
      withLoading: withLoading ?? this.withLoading,
    );
  }

  @override
  List<Object?> get props => [offerPriceDetails, withLoading];
}

class OfferPriceDetailsError extends OfferPriceDetailsState {
  final String message;
  final int? statusCode;

  const OfferPriceDetailsError({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

class OfferPriceDetailsNoDataState extends OfferPriceDetailsState {
  final VoidCallback? onPressed;

  const OfferPriceDetailsNoDataState({this.onPressed});

  @override
  List<Object?> get props => [onPressed];
}

class OfferPriceDetailsNotFoundState extends OfferPriceDetailsState {
  final VoidCallback? onPressed;

  const OfferPriceDetailsNotFoundState({this.onPressed});

  @override
  List<Object?> get props => [onPressed];
}

class OfferPriceDetailsNoInternetState extends OfferPriceDetailsState {
  final VoidCallback? onPressed;

  const OfferPriceDetailsNoInternetState({this.onPressed});

  @override
  List<Object?> get props => [onPressed];
}
