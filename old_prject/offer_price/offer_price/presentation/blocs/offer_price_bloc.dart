import 'package:equatable/equatable.dart';
import 'package:fatoorahapp/core/classes/entities/pagination_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/data/repositories/offer_price_repositories.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'offer_price_event.dart';
part 'offer_price_state.dart';

class OfferPriceBloc extends Bloc<OfferPriceEvent, OfferPriceState> {
  final OfferPriceRepository _offerPriceRepository;
  bool _isLoadingMore = false;
  int _page = 1;
  bool _hasNextPage = true;
  List<OfferPriceDataEntity> _accumulatedOfferPrices = [];
  String? _currentSearchText;
  String? _currentStatus;
  String? _currentUserId;
  String? _currentAdminId;
  String? _currentFromDueDate;
  String? _currentToDueDate;
  String? _currentFrom;
  String? _currentTo;
  TextEditingController searchController = TextEditingController();

  PaginationEntity? _currentPaginationInfo;
  final int _pageSize = 10;

  OfferPriceBloc(this._offerPriceRepository)
      : super(const OfferPriceInitialState()) {
    on<OfferPriceSubmitted>(_onOfferPriceSubmitted);
    on<OfferPriceOnChangedSubmitted>(_onOfferPriceOnChangedSubmitted);
    on<SwitchToFilterMode>(_switchFilterMode);
  }

  Future<void> _onOfferPriceSubmitted(
      OfferPriceSubmitted event, Emitter<OfferPriceState> emit) async {
    // final isNewSearch =
    //     state is! OfferPriceSuccessState || event.searchText != null;
    if (event.withLoading) {
      emit(const OfferPriceLoadingState());
    }

    _currentSearchText = event.searchText;
    _currentStatus = event.status;
    _currentUserId = event.userId;
    _currentAdminId = event.adminId;
    _currentFromDueDate = event.fromDueDate;
    _currentToDueDate = event.toDueDate;
    _currentFrom = event.from;
    _currentTo = event.to;
    _page = 1;
    _hasNextPage = true;
    _isLoadingMore = false;
    _accumulatedOfferPrices.clear();
    _currentPaginationInfo = null;

    Map<String, dynamic> queries = {
      "page": _page,
      "per_page": _pageSize,
      "test": 1,
      if (_currentSearchText != null && _currentSearchText!.isNotEmpty)
        "keyword": _currentSearchText,
      if (_currentStatus != null && _currentStatus!.isNotEmpty)
        "status": _currentStatus,
      if (_currentUserId != null && _currentUserId!.isNotEmpty)
        "user_id": _currentUserId,
      if (_currentAdminId != null && _currentAdminId!.isNotEmpty)
        "admin_id": _currentAdminId,
      if (_currentFromDueDate != null && _currentFromDueDate!.isNotEmpty)
        "fromDueDate": _currentFromDueDate,
      if (_currentToDueDate != null && _currentToDueDate!.isNotEmpty)
        "toDueDate": _currentToDueDate,
      if (_currentFrom != null && _currentFrom!.isNotEmpty)
        "from": _currentFrom,
      if (_currentTo != null && _currentTo!.isNotEmpty) "to": _currentTo,
    };

    final result = await _offerPriceRepository.offerPrices(queries: queries);
    result.fold(
      (l) {
        // Handle different error scenarios
        if (l.statusCode == 404) {
          emit(const OfferPriceNotFoundState());
        } else if (l.statusCode == -6) {
          // noInternetConnection
          emit(const OfferPriceNoInternetState());
        } else {
          emit(OfferPriceErrorState(
            message: l.prettyMessage ?? l.message,
            statusCode: l.statusCode,
          ));
        }
      },
      (r) {
        _accumulatedOfferPrices.addAll(r.offerPriceDataEntity);
        _currentPaginationInfo = r.offerPricePagination;

        _hasNextPage = _currentPaginationInfo != null
            ? _currentPaginationInfo!.currentPage <
                _currentPaginationInfo!.totalPages
            : r.offerPriceDataEntity.length >= _pageSize;

        // Check if we have data or need to show no data state
        if (r.offerPriceDataEntity.isEmpty && !(event.isFiltered ?? false)) {
          emit(const OfferPriceNoDataState());
        } else {
          emit(OfferPriceSuccessState(
            isFiltered: event.isFiltered ?? false,
            offerPriceDataEntity: List.from(_accumulatedOfferPrices),
            isLoadingMore: false,
            hasReachedMax: !_hasNextPage,
            page: _page,
            currentSearchText: _currentSearchText,
            currentStatus: _currentStatus,
            currentUserId: _currentUserId,
            currentAdminId: _currentAdminId,
            currentFromDueDate: _currentFromDueDate,
            currentToDueDate: _currentToDueDate,
            currentPagination: _currentPaginationInfo,
          ));
        }
      },
    );
  }

  Future<void> _onOfferPriceOnChangedSubmitted(
      OfferPriceOnChangedSubmitted event, Emitter<OfferPriceState> emit) async {
    if (!_hasNextPage || _isLoadingMore || state is! OfferPriceSuccessState) {
      return;
    }
    _isLoadingMore = true;

    final currentState = state as OfferPriceSuccessState;
    emit(currentState.copyWith(isLoadingMore: true));

    _page++;

    // FIX: Use the BLoC's stored filter values, not from the event.
    Map<String, dynamic> queries = {
      "page": _page,
      "per_page": _pageSize,
      "test": 1,
      if (_currentSearchText != null && _currentSearchText!.isNotEmpty)
        "search": _currentSearchText,
      if (_currentStatus != null && _currentStatus!.isNotEmpty)
        "status": _currentStatus,
      if (_currentUserId != null && _currentUserId!.isNotEmpty)
        "user_id": _currentUserId,
      if (_currentAdminId != null && _currentAdminId!.isNotEmpty)
        "admin_id": _currentAdminId,
      if (_currentFromDueDate != null && _currentFromDueDate!.isNotEmpty)
        "fromDueDate": _currentFromDueDate,
      if (_currentToDueDate != null && _currentToDueDate!.isNotEmpty)
        "toDueDate": _currentToDueDate,
      if (_currentFrom != null && _currentFrom!.isNotEmpty)
        "from": _currentFrom,
      if (_currentTo != null && _currentTo!.isNotEmpty) "to": _currentTo,
    };

    final result = await _offerPriceRepository.offerPrices(queries: queries);
    _isLoadingMore = false;

    result.fold(
      (l) {
        _page--;
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (r) {
        _accumulatedOfferPrices.addAll(r.offerPriceDataEntity);
        _currentPaginationInfo = r.offerPricePagination;

        _hasNextPage = _currentPaginationInfo != null
            ? _currentPaginationInfo!.currentPage <
                _currentPaginationInfo!.totalPages
            : r.offerPriceDataEntity.length >= _pageSize;

        emit(currentState.copyWith(
          offerPriceDataEntity: List.from(_accumulatedOfferPrices),
          isLoadingMore: false,
          hasReachedMax: !_hasNextPage,
          page: _page,
          currentPagination: _currentPaginationInfo,
        ));
      },
    );
  }

  void _switchFilterMode(SwitchToFilterMode e, Emitter<OfferPriceState> emit) {
    final currentState = state;
    if (currentState is OfferPriceSuccessState) {
      emit(currentState.copyWith(isFiltered: e.isFiltered));
    }
  }
}
