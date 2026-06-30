part of 'list_merchant_bloc.dart';

abstract class ListMerchantEvent extends Equatable {
  const ListMerchantEvent();

  @override
  List<Object?> get props => [];
}

class GetMerchantsEvent extends ListMerchantEvent {
  final bool loadMore;
  final String? search;
  final bool? isActiveFilter;

  const GetMerchantsEvent({
    this.loadMore = false,
    this.search,
    this.isActiveFilter,
  });

  @override
  List<Object?> get props => [loadMore, search, isActiveFilter];
}

