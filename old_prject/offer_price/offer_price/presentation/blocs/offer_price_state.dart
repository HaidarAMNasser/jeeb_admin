part of 'offer_price_bloc.dart';

abstract class OfferPriceState extends Equatable {
  const OfferPriceState();

  @override
  List<Object?> get props => [];
}

class OfferPriceInitialState extends OfferPriceState {
  const OfferPriceInitialState();
}

class OfferPriceLoadingState extends OfferPriceState {
  final List<OfferPriceDataEntity> offerPriceDataEntity;
  const OfferPriceLoadingState({this.offerPriceDataEntity = const []});

  @override
  List<Object?> get props => [offerPriceDataEntity];
}

class OfferPriceSuccessState extends OfferPriceState {
  final List<OfferPriceDataEntity> offerPriceDataEntity;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final int page;
  final String? currentSearchText;
  final String? currentStatus;
  final String? currentUserId;
  final String? currentAdminId;
  final String? currentFromDueDate;
  final String? currentToDueDate;
  final PaginationEntity? currentPagination;
  final bool? isFiltered;

  const OfferPriceSuccessState({
    required this.offerPriceDataEntity,
    required this.isLoadingMore,
    required this.hasReachedMax,
    required this.page,
    this.currentSearchText,
    this.currentStatus,
    this.currentUserId,
    this.currentAdminId,
    this.currentFromDueDate,
    this.currentToDueDate,
    this.currentPagination,
    this.isFiltered,
  });

  OfferPriceSuccessState copyWith({
    List<OfferPriceDataEntity>? offerPriceDataEntity,
    bool? isLoadingMore,
    bool? hasReachedMax,
    int? page,
    String? currentSearchText,
    String? currentStatus,
    String? currentUserId,
    String? currentAdminId,
    String? currentFromDueDate,
    String? currentToDueDate,
    PaginationEntity? currentPagination,
    bool? isFiltered,
  }) {
    return OfferPriceSuccessState(
      offerPriceDataEntity: offerPriceDataEntity ?? this.offerPriceDataEntity,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      currentSearchText: currentSearchText ?? this.currentSearchText,
      currentStatus: currentStatus ?? this.currentStatus,
      currentUserId: currentUserId ?? this.currentUserId,
      currentAdminId: currentAdminId ?? this.currentAdminId,
      currentFromDueDate: currentFromDueDate ?? this.currentFromDueDate,
      currentToDueDate: currentToDueDate ?? this.currentToDueDate,
      currentPagination: currentPagination ?? this.currentPagination,
      isFiltered: isFiltered ?? this.isFiltered,
    );
  }

  @override
  List<Object?> get props => [
        offerPriceDataEntity,
        isLoadingMore,
        hasReachedMax,
        page,
        currentSearchText,
        currentStatus,
        currentUserId,
        currentAdminId,
        currentFromDueDate,
        currentToDueDate,
        currentPagination,
        isFiltered,
      ];
}

class OfferPriceErrorState extends OfferPriceState {
  final String message;
  final int? statusCode;
  final List<OfferPriceDataEntity> offerPriceDataEntity;

  const OfferPriceErrorState(
      {required this.message,
      this.statusCode,
      this.offerPriceDataEntity = const []});

  @override
  List<Object?> get props => [message, statusCode, offerPriceDataEntity];
}

class OfferPriceNoDataState extends OfferPriceState {
  final VoidCallback? onPressed;

  const OfferPriceNoDataState({this.onPressed});

  @override
  List<Object?> get props => [onPressed];
}

class OfferPriceNotFoundState extends OfferPriceState {
  final VoidCallback? onPressed;

  const OfferPriceNotFoundState({this.onPressed});

  @override
  List<Object?> get props => [onPressed];
}

class OfferPriceNoInternetState extends OfferPriceState {
  final VoidCallback? onPressed;

  const OfferPriceNoInternetState({this.onPressed});

  @override
  List<Object?> get props => [onPressed];
}
