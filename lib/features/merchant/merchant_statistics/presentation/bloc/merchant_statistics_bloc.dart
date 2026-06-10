import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/data/repositories/merchant_statistics_repository.dart';
import 'package:jeeb_admin/features/merchant/merchant_statistics/domain/entities/merchant_statistics_entity.dart';

part 'merchant_statistics_event.dart';
part 'merchant_statistics_state.dart';

class MerchantStatisticsBloc
    extends Bloc<MerchantStatisticsEvent, MerchantStatisticsState> {
  static const int _pageSize = 10;
  final MerchantStatisticsRepository _repository;

  MerchantStatisticsBloc(this._repository)
      : super(const MerchantStatisticsInitial()) {
    on<GetMerchantStatisticsEvent>(_onGetStatistics);
  }

  Future<void> _onGetStatistics(
    GetMerchantStatisticsEvent event,
    Emitter<MerchantStatisticsState> emit,
  ) async {
    if (event.loadMore) {
      final current = state;
      if (current is! MerchantStatisticsLoaded ||
          current.isLoadingMore ||
          !current.pagination.hasNextPage) {
        return;
      }

      emit(current.copyWith(isLoadingMore: true));
      final result = await _repository.getMerchantStatistics(
        page: current.pagination.page + 1,
        limit: _pageSize,
        search: event.search ?? current.search,
        from: event.from ?? current.from,
        to: event.to ?? current.to,
        merchantId: event.merchantId ?? current.merchantId,
      );
      result.fold(
        (_) => emit(current.copyWith(isLoadingMore: false)),
        (page) => emit(
          current.copyWith(
            items: [...current.items, ...page.items],
            pagination: page.pagination,
            isLoadingMore: false,
          ),
        ),
      );
      return;
    }

    emit(const MerchantStatisticsLoading());
    final result = await _repository.getMerchantStatistics(
      page: 1,
      limit: _pageSize,
      search: event.search,
      from: event.from,
      to: event.to,
      merchantId: event.merchantId,
    );
    result.fold(
      (failure) => emit(MerchantStatisticsError(message: failure.message)),
      (page) => emit(
        MerchantStatisticsLoaded(
          items: page.items,
          pagination: page.pagination,
          search: event.search,
          from: event.from,
          to: event.to,
          merchantId: event.merchantId,
        ),
      ),
    );
  }
}
