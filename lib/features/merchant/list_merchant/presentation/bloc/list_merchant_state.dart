part of 'list_merchant_bloc.dart';

abstract class ListMerchantState extends Equatable {
  const ListMerchantState();

  @override
  List<Object?> get props => [];
}

class ListMerchantInitial extends ListMerchantState {
  const ListMerchantInitial();
}

class ListMerchantLoading extends ListMerchantState {
  const ListMerchantLoading();
}

class ListMerchantLoaded extends ListMerchantState {
  final List<MerchantEntity> merchants;
  final bool hasMore;
  final int currentPage;
  final String? search;
  final bool? isActiveFilter;
  final bool isLoadingMore;

  const ListMerchantLoaded({
    required this.merchants,
    this.hasMore = true,
    this.currentPage = 1,
    this.search,
    this.isActiveFilter,
    this.isLoadingMore = false,
  });

  bool get isFiltered =>
      (search != null && search!.trim().isNotEmpty) || isActiveFilter != null;

  ListMerchantLoaded copyWith({
    List<MerchantEntity>? merchants,
    bool? hasMore,
    int? currentPage,
    String? search,
    bool? isActiveFilter,
    bool? isLoadingMore,
  }) {
    return ListMerchantLoaded(
      merchants: merchants ?? this.merchants,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      search: search ?? this.search,
      isActiveFilter: isActiveFilter ?? this.isActiveFilter,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [merchants, hasMore, currentPage, search, isActiveFilter, isLoadingMore];
}

class ListMerchantError extends ListMerchantState {
  final String message;

  const ListMerchantError({required this.message});

  @override
  List<Object?> get props => [message];
}


