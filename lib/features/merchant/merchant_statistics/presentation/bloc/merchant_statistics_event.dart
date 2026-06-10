part of 'merchant_statistics_bloc.dart';

abstract class MerchantStatisticsEvent extends Equatable {
  const MerchantStatisticsEvent();

  @override
  List<Object?> get props => [];
}

class GetMerchantStatisticsEvent extends MerchantStatisticsEvent {
  final bool loadMore;
  final String? search;
  final String? from;
  final String? to;
  final int? merchantId;

  const GetMerchantStatisticsEvent({
    this.loadMore = false,
    this.search,
    this.from,
    this.to,
    this.merchantId,
  });

  @override
  List<Object?> get props => [loadMore, search, from, to, merchantId];
}
