part of 'offer_price_bloc.dart';

abstract class OfferPriceEvent extends Equatable {
  const OfferPriceEvent();

  @override
  List<Object?> get props => [];
}

class OfferPriceSubmitted extends OfferPriceEvent {
  final bool withLoading;
  final String? searchText;
  final String? status;
  final String? userId;
  final String? adminId;
  final String? fromDueDate;
  final String? toDueDate;
  final int? limit;
  final bool? isFiltered;
  final String? from;
  final String? to;
  const OfferPriceSubmitted({
    this.withLoading = true,
    this.searchText,
    this.status,
    this.userId,
    this.adminId,
    this.fromDueDate,
    this.toDueDate,
    this.limit,
    this.isFiltered = false,
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [
        withLoading,
        searchText,
        status,
        userId,
        adminId,
        fromDueDate,
        toDueDate,
        limit,
        isFiltered,
        from,
        to,
      ];
}

class OfferPriceOnChangedSubmitted extends OfferPriceEvent {
  const OfferPriceOnChangedSubmitted();
}

class SwitchToFilterMode extends OfferPriceEvent {
  final bool isFiltered;

  const SwitchToFilterMode({required this.isFiltered});

  @override
  List<Object?> get props => [isFiltered];
}
