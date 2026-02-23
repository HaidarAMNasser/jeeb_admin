part of 'offer_to_sale_Invoice_bloc.dart';

abstract class MapOfferToInvoiceState extends Equatable {
  final List<CreateProductEntity> details;
  final List<PaymentMethodEntryOffer> payments;
  final double totalAmount;
  final double totalDiscount;
  final double taxableAmount;
  final double taxAmount;
  final double finalAmount;
  final bool isValid;
  final String referenceNumber;
  final String supplyDate;
  final String serviceEndDate;
  final String dueDate;
  final int stockId;
  final int employeeId;

  const MapOfferToInvoiceState({
    required this.details,
    required this.payments,
    this.totalAmount = 0.0,
    this.totalDiscount = 0.0,
    this.taxableAmount = 0.0,
    this.taxAmount = 0.0,
    this.finalAmount = 0.0,
    this.isValid = true,
    this.referenceNumber = "",
    this.supplyDate = "",
    this.serviceEndDate = "",
    this.dueDate = "",
    this.stockId = 0,
    this.employeeId = 0,
  });

  @override
  List<Object> get props => [
        details,
        payments,
        totalAmount,
        totalDiscount,
        taxableAmount,
        taxAmount,
        finalAmount,
        isValid,
        referenceNumber,
        supplyDate,
        serviceEndDate,
        dueDate,
        stockId,
        employeeId,
      ];
}

class MapOfferToInvoiceInitialState extends MapOfferToInvoiceState {
  const MapOfferToInvoiceInitialState({
    super.details = const [],
    super.payments = const [],
    super.totalAmount,
    super.totalDiscount,
    super.taxableAmount,
    super.taxAmount,
    super.finalAmount,
    super.isValid,
    super.referenceNumber,
    super.supplyDate,
    super.serviceEndDate,
    super.dueDate,
    super.stockId,
    super.employeeId,
  });

  MapOfferToInvoiceInitialState copyWith({
    List<CreateProductEntity>? details,
    List<PaymentMethodEntryOffer>? payments,
    double? totalAmount,
    double? totalDiscount,
    double? taxableAmount,
    double? taxAmount,
    double? finalAmount,
    bool? isValid,
    String? referenceNumber,
    String? supplyDate,
    String? serviceEndDate,
    String? dueDate,
    int? stockId,
    int? employeeId,
  }) {
    return MapOfferToInvoiceInitialState(
      details: details ?? this.details,
      payments: payments ?? this.payments,
      totalAmount: totalAmount ?? this.totalAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      isValid: isValid ?? this.isValid,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      supplyDate: supplyDate ?? this.supplyDate,
      serviceEndDate: serviceEndDate ?? this.serviceEndDate,
      dueDate: dueDate ?? this.dueDate,
      stockId: stockId ?? this.stockId,
      employeeId: employeeId ?? this.employeeId,
    );
  }
}

class MapOfferToInvoiceLoadingState extends MapOfferToInvoiceState {
  const MapOfferToInvoiceLoadingState({
    required super.details,
    required super.payments,
    required super.totalAmount,
    required super.totalDiscount,
    required super.taxableAmount,
    required super.taxAmount,
    required super.finalAmount,
    super.isValid,
    super.referenceNumber,
    super.supplyDate,
    super.serviceEndDate,
    super.dueDate,
    super.stockId,
    super.employeeId,
  });
}

class MapOfferToInvoiceSuccessState extends MapOfferToInvoiceState {
  final SaleInvoiceEntity saleInvoiceEntity;

  const MapOfferToInvoiceSuccessState({
    required this.saleInvoiceEntity,
    required super.details,
    required super.payments,
    required super.totalAmount,
    required super.totalDiscount,
    required super.taxableAmount,
    required super.taxAmount,
    required super.finalAmount,
    super.isValid,
    super.referenceNumber,
    super.supplyDate,
    super.serviceEndDate,
    super.dueDate,
    super.stockId,
    super.employeeId,
  });

  MapOfferToInvoiceSuccessState copyWith({
    SaleInvoiceEntity? saleInvoiceEntity,
    List<CreateProductEntity>? details,
    List<PaymentMethodEntryOffer>? payments,
    double? totalAmount,
    double? totalDiscount,
    double? taxableAmount,
    double? taxAmount,
    double? finalAmount,
    bool? isValid,
    String? referenceNumber,
    String? supplyDate,
    String? serviceEndDate,
    String? dueDate,
    int? stockId,
    int? employeeId,
  }) {
    return MapOfferToInvoiceSuccessState(
      saleInvoiceEntity: saleInvoiceEntity ?? this.saleInvoiceEntity,
      details: details ?? this.details,
      payments: payments ?? this.payments,
      totalAmount: totalAmount ?? this.totalAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      isValid: isValid ?? this.isValid,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      supplyDate: supplyDate ?? this.supplyDate,
      serviceEndDate: serviceEndDate ?? this.serviceEndDate,
      dueDate: dueDate ?? this.dueDate,
      stockId: stockId ?? this.stockId,
      employeeId: employeeId ?? this.employeeId,
    );
  }
}

class MapOfferToInvoiceErrorState extends MapOfferToInvoiceState {
  final String message;

  const MapOfferToInvoiceErrorState({
    required this.message,
    required super.details,
    required super.payments,
    required super.totalAmount,
    required super.totalDiscount,
    required super.taxableAmount,
    required super.taxAmount,
    required super.finalAmount,
    super.isValid,
    super.referenceNumber,
    required super.supplyDate,
    required super.serviceEndDate,
    required super.dueDate,
    required super.stockId,
    required super.employeeId,
  });

  @override
  List<Object> get props => [
        message,
        details,
        payments,
        totalAmount,
        totalDiscount,
        taxableAmount,
        taxAmount,
        finalAmount,
        isValid,
        referenceNumber,
        supplyDate,
        serviceEndDate,
        dueDate,
        stockId,
        employeeId,
      ];

  MapOfferToInvoiceErrorState copyWith({
    String? message,
    List<CreateProductEntity>? details,
    List<PaymentMethodEntryOffer>? payments,
    double? totalAmount,
    double? totalDiscount,
    double? taxableAmount,
    double? taxAmount,
    double? finalAmount,
    bool? isValid,
    String? referenceNumber,
    String? supplyDate,
    String? serviceEndDate,
    String? dueDate,
    int? stockId,
    int? employeeId,
  }) {
    return MapOfferToInvoiceErrorState(
      message: message ?? this.message,
      details: details ?? this.details,
      payments: payments ?? this.payments,
      totalAmount: totalAmount ?? this.totalAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      isValid: isValid ?? this.isValid,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      supplyDate: supplyDate ?? this.supplyDate,
      serviceEndDate: serviceEndDate ?? this.serviceEndDate,
      dueDate: dueDate ?? this.dueDate,
      stockId: stockId ?? this.stockId,
      employeeId: employeeId ?? this.employeeId,
    );
  }
}
