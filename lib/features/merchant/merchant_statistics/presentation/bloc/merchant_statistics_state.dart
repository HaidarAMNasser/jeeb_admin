part of 'merchant_statistics_bloc.dart';

abstract class MerchantStatisticsState extends Equatable {
  const MerchantStatisticsState();

  @override
  List<Object?> get props => [];
}

class MerchantStatisticsInitial extends MerchantStatisticsState {
  const MerchantStatisticsInitial();
}

class MerchantStatisticsLoading extends MerchantStatisticsState {
  const MerchantStatisticsLoading();
}

class MerchantStatisticsLoaded extends MerchantStatisticsState {
  final List<MerchantStatisticsEntity> items;
  final MerchantStatisticsPagination pagination;
  final String? search;
  final String? from;
  final String? to;
  final int? merchantId;
  final bool isLoadingMore;

  const MerchantStatisticsLoaded({
    required this.items,
    required this.pagination,
    this.search,
    this.from,
    this.to,
    this.merchantId,
    this.isLoadingMore = false,
  });

  MerchantStatisticsLoaded copyWith({
    List<MerchantStatisticsEntity>? items,
    MerchantStatisticsPagination? pagination,
    String? search,
    String? from,
    String? to,
    int? merchantId,
    bool? isLoadingMore,
  }) {
    return MerchantStatisticsLoaded(
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
      search: search ?? this.search,
      from: from ?? this.from,
      to: to ?? this.to,
      merchantId: merchantId ?? this.merchantId,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        items,
        pagination,
        search,
        from,
        to,
        merchantId,
        isLoadingMore,
      ];
}

class MerchantStatisticsError extends MerchantStatisticsState {
  final String message;

  const MerchantStatisticsError({required this.message});

  @override
  List<Object?> get props => [message];
}
