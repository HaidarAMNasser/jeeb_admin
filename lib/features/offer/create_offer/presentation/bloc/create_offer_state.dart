part of 'create_offer_bloc.dart';

abstract class CreateOfferState extends Equatable {
  final String shortDescription;
  final String longDescription;
  final List<String> productIds;
  final DateTime? startDate;
  final DateTime? endDate;
  final String discountType;
  final String discountValue;
  final String? offerId;
  final bool isValid;

  const CreateOfferState({
    this.shortDescription = '',
    this.longDescription = '',
    this.productIds = const [],
    this.startDate,
    this.endDate,
    this.discountType = 'PERCENTAGE',
    this.discountValue = '',
    this.offerId,
    this.isValid = false,
  });

  CreateOfferState copyWith({
    String? shortDescription,
    String? longDescription,
    List<String>? productIds,
    DateTime? startDate,
    DateTime? endDate,
    String? discountType,
    String? discountValue,
    String? offerId,
    bool? isValid,
  });

  @override
  List<Object?> get props => [
        shortDescription,
        longDescription,
        productIds,
        startDate,
        endDate,
        discountType,
        discountValue,
        offerId,
        isValid,
      ];
}

class CreateOfferInitial extends CreateOfferState {
  const CreateOfferInitial({
    super.shortDescription,
    super.longDescription,
    super.productIds,
    super.startDate,
    super.endDate,
    super.discountType,
    super.discountValue,
    super.offerId,
    super.isValid,
  });

  @override
  CreateOfferState copyWith({
    String? shortDescription,
    String? longDescription,
    List<String>? productIds,
    DateTime? startDate,
    DateTime? endDate,
    String? discountType,
    String? discountValue,
    String? offerId,
    bool? isValid,
  }) {
    return CreateOfferInitial(
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      productIds: productIds ?? this.productIds,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      offerId: offerId ?? this.offerId,
      isValid: isValid ?? this.isValid,
    );
  }
}

class CreateOfferLoading extends CreateOfferState {
  const CreateOfferLoading({
    required super.shortDescription,
    required super.longDescription,
    required super.productIds,
    super.startDate,
    super.endDate,
    required super.discountType,
    required super.discountValue,
    super.offerId,
    required super.isValid,
  });

  @override
  CreateOfferState copyWith({
    String? shortDescription,
    String? longDescription,
    List<String>? productIds,
    DateTime? startDate,
    DateTime? endDate,
    String? discountType,
    String? discountValue,
    String? offerId,
    bool? isValid,
  }) {
    return CreateOfferInitial(
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      productIds: productIds ?? this.productIds,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      offerId: offerId ?? this.offerId,
      isValid: isValid ?? this.isValid,
    );
  }
}

class CreateOfferSuccess extends CreateOfferState {
  const CreateOfferSuccess();

  @override
  CreateOfferState copyWith({
    String? shortDescription,
    String? longDescription,
    List<String>? productIds,
    DateTime? startDate,
    DateTime? endDate,
    String? discountType,
    String? discountValue,
    String? offerId,
    bool? isValid,
  }) {
    return const CreateOfferInitial();
  }
}

class CreateOfferError extends CreateOfferState {
  final String message;

  const CreateOfferError({
    required this.message,
    required super.shortDescription,
    required super.longDescription,
    required super.productIds,
    super.startDate,
    super.endDate,
    required super.discountType,
    required super.discountValue,
    super.offerId,
    required super.isValid,
  });

  @override
  CreateOfferState copyWith({
    String? shortDescription,
    String? longDescription,
    List<String>? productIds,
    DateTime? startDate,
    DateTime? endDate,
    String? discountType,
    String? discountValue,
    String? offerId,
    bool? isValid,
  }) {
    return CreateOfferError(
      message: message,
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      productIds: productIds ?? this.productIds,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      offerId: offerId ?? this.offerId,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [message, ...super.props];
}
