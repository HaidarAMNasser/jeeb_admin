part of 'create_offer_bloc.dart';

abstract class CreateOfferState extends Equatable {
  final String name;
  final String description;
  final List<OfferProductLine> offerProducts;
  /// Snapshot of product ids when editing started; used for `removeProductIds` on update.
  final List<String> initialOfferProductIds;
  final DateTime? startDate;
  final DateTime? endDate;
  final String discountType;
  final String discountValue;
  final String? offerId;
  final bool isValid;

  const CreateOfferState({
    this.name = '',
    this.description = '',
    this.offerProducts = const [],
    this.initialOfferProductIds = const [],
    this.startDate,
    this.endDate,
    this.discountType = 'PERCENTAGE',
    this.discountValue = '',
    this.offerId,
    this.isValid = false,
  });

  CreateOfferState copyWith({
    String? name,
    String? description,
    List<OfferProductLine>? offerProducts,
    List<String>? initialOfferProductIds,
    DateTime? startDate,
    DateTime? endDate,
    String? discountType,
    String? discountValue,
    String? offerId,
    bool? isValid,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        offerProducts,
        initialOfferProductIds,
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
    super.name,
    super.description,
    super.offerProducts,
    super.initialOfferProductIds,
    super.startDate,
    super.endDate,
    super.discountType,
    super.discountValue,
    super.offerId,
    super.isValid,
  });

  @override
  CreateOfferState copyWith({
    String? name,
    String? description,
    List<OfferProductLine>? offerProducts,
    List<String>? initialOfferProductIds,
    DateTime? startDate,
    DateTime? endDate,
    String? discountType,
    String? discountValue,
    String? offerId,
    bool? isValid,
  }) {
    return CreateOfferInitial(
      name: name ?? this.name,
      description: description ?? this.description,
      offerProducts: offerProducts ?? this.offerProducts,
      initialOfferProductIds:
          initialOfferProductIds ?? this.initialOfferProductIds,
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
    required super.name,
    required super.description,
    required super.offerProducts,
    required super.initialOfferProductIds,
    super.startDate,
    super.endDate,
    required super.discountType,
    required super.discountValue,
    super.offerId,
    required super.isValid,
  });

  @override
  CreateOfferState copyWith({
    String? name,
    String? description,
    List<OfferProductLine>? offerProducts,
    List<String>? initialOfferProductIds,
    DateTime? startDate,
    DateTime? endDate,
    String? discountType,
    String? discountValue,
    String? offerId,
    bool? isValid,
  }) {
    return CreateOfferInitial(
      name: name ?? this.name,
      description: description ?? this.description,
      offerProducts: offerProducts ?? this.offerProducts,
      initialOfferProductIds:
          initialOfferProductIds ?? this.initialOfferProductIds,
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
    String? name,
    String? description,
    List<OfferProductLine>? offerProducts,
    List<String>? initialOfferProductIds,
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
    required super.name,
    required super.description,
    required super.offerProducts,
    required super.initialOfferProductIds,
    super.startDate,
    super.endDate,
    required super.discountType,
    required super.discountValue,
    super.offerId,
    required super.isValid,
  });

  @override
  CreateOfferState copyWith({
    String? name,
    String? description,
    List<OfferProductLine>? offerProducts,
    List<String>? initialOfferProductIds,
    DateTime? startDate,
    DateTime? endDate,
    String? discountType,
    String? discountValue,
    String? offerId,
    bool? isValid,
  }) {
    return CreateOfferError(
      message: message,
      name: name ?? this.name,
      description: description ?? this.description,
      offerProducts: offerProducts ?? this.offerProducts,
      initialOfferProductIds:
          initialOfferProductIds ?? this.initialOfferProductIds,
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
