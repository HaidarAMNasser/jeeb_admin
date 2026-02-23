part of 'create_offer_price_bloc.dart';

abstract class CreateOfferPriceState extends Equatable {
  final List<CreateProductEntity> details;
  final List<PaymentMethodEntryOffer> payments;
  final bool isValid;
  final bool hasChanges;

  final double totalAmount;
  final double totalDiscount;
  final double taxableAmount;
  final double taxAmount;
  final double finalAmount;

  const CreateOfferPriceState({
    required this.details,
    required this.payments,
    required this.isValid,
    required this.hasChanges,
    this.totalAmount = 0.0,
    this.totalDiscount = 0.0,
    this.taxableAmount = 0.0,
    this.taxAmount = 0.0,
    this.finalAmount = 0.0,
  });

  @override
  List<Object> get props => [
        details,
        payments,
        isValid,
        hasChanges,
        totalAmount,
        totalDiscount,
        taxableAmount,
        taxAmount,
        finalAmount,
      ];
}

class CreateOfferPriceInitial extends CreateOfferPriceState {
  const CreateOfferPriceInitial({
    required super.details,
    required super.payments,
    required super.isValid,
    super.hasChanges = false,
// Add to constructor
    super.totalAmount,
    super.totalDiscount,
    super.taxableAmount,
    super.taxAmount,
    super.finalAmount,
  });

  CreateOfferPriceInitial copyWith({
    List<CreateProductEntity>? details,
    List<PaymentMethodEntryOffer>? payments,
    bool? isValid,
    bool? hasChanges,
// Add to copyWith
    double? totalAmount,
    double? totalDiscount,
    double? taxableAmount,
    double? taxAmount,
    double? finalAmount,
  }) {
    return CreateOfferPriceInitial(
      isValid: isValid ?? this.isValid,
      details: details ?? this.details,
      payments: payments ?? this.payments,
      hasChanges: hasChanges ?? this.hasChanges,
// Add to return
      totalAmount: totalAmount ?? this.totalAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      finalAmount: finalAmount ?? this.finalAmount,
    );
  }
}

class CreateOfferPriceLoading extends CreateOfferPriceState {
  const CreateOfferPriceLoading({
    required super.details,
    required super.payments,
    required super.isValid,
    super.hasChanges = false,
// Add to constructor
    super.totalAmount,
    super.totalDiscount,
    super.taxableAmount,
    super.taxAmount,
    super.finalAmount,
  });

  CreateOfferPriceLoading copyWith({
    List<CreateProductEntity>? details,
    List<PaymentMethodEntryOffer>? payments,
    bool? isValid,
    bool? hasChanges,
// Add to copyWith
    double? totalAmount,
    double? totalDiscount,
    double? taxableAmount,
    double? taxAmount,
    double? finalAmount,
  }) {
    return CreateOfferPriceLoading(
      isValid: isValid ?? this.isValid,
      details: details ?? this.details,
      payments: payments ?? this.payments,
      hasChanges: hasChanges ?? this.hasChanges,
// Add to return
      totalAmount: totalAmount ?? this.totalAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      finalAmount: finalAmount ?? this.finalAmount,
    );
  }

  @override
  List<Object> get props => [
        details,
        payments,
        isValid,
// Add to props
        totalAmount,
        totalDiscount,
        taxableAmount,
        taxAmount,
        finalAmount,
      ];
}

class CreateOfferPriceSuccess extends CreateOfferPriceState {
  final CreateOfferPriceDataEntity createOfferPriceDataEntity;

  const CreateOfferPriceSuccess({required this.createOfferPriceDataEntity})
      : super(
          details: const [],
          payments: const [],
          isValid: false,
          hasChanges: false,
        );

  @override
  List<Object> get props => [createOfferPriceDataEntity];
}

class CreateOfferPriceError extends CreateOfferPriceState {
  final String message;
  const CreateOfferPriceError({
    required this.message,
    required super.details,
    required super.payments,
    required super.isValid,
    super.hasChanges = false,
// Add to constructor
    super.totalAmount,
    super.totalDiscount,
    super.taxableAmount,
    super.taxAmount,
    super.finalAmount,
  });

  CreateOfferPriceError copyWith({
    String? message,
    List<CreateProductEntity>? details,
    List<PaymentMethodEntryOffer>? payments,
    bool? isValid,
    bool? hasChanges,
// Add to copyWith
    double? totalAmount,
    double? totalDiscount,
    double? taxableAmount,
    double? taxAmount,
    double? finalAmount,
  }) {
    return CreateOfferPriceError(
      isValid: isValid ?? this.isValid,
      message: message ?? this.message,
      details: details ?? this.details,
      payments: payments ?? this.payments,
      hasChanges: hasChanges ?? this.hasChanges,
// Add to return
      totalAmount: totalAmount ?? this.totalAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      finalAmount: finalAmount ?? this.finalAmount,
    );
  }

  @override
  List<Object> get props => [
        message,
        details,
        payments,
        isValid,
// Add to props
        totalAmount,
        totalDiscount,
        taxableAmount,
        taxAmount,
        finalAmount,
      ];
}
