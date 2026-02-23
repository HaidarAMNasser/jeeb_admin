part of 'offer_to_sale_Invoice_bloc.dart';

abstract class MapOfferToInvoiceEvent extends Equatable {
  const MapOfferToInvoiceEvent();

  @override
  List<Object> get props => [];
}

class MapOfferToInvoiceSubmitted extends MapOfferToInvoiceEvent {
  final bool withLoading;
  final String uuid;

  const MapOfferToInvoiceSubmitted({
    this.withLoading = true,
    required this.uuid,
  });

  @override
  List<Object> get props => [withLoading, uuid];
}

// --- INITIAL DATA EVENT ---
class LoadOfferToInvoiceInitData extends MapOfferToInvoiceEvent {
  final List<PaymentMethodEntryOffer> payments;
  final List<CreateProductEntity> details;
  final String? referenceNumber;
  final String? supplyDate;
  final String? serviceEndDate;
  final String? stockId;
  final String? employeeId;

  const LoadOfferToInvoiceInitData({
    required this.payments,
    required this.details,
    this.referenceNumber,
    this.supplyDate,
    this.serviceEndDate,
    this.stockId,
    this.employeeId,
  });

  @override
  List<Object> get props => [
        payments,
        details,
        referenceNumber ?? '',
        supplyDate ?? '',
        serviceEndDate ?? '',
        stockId ?? '',
        employeeId ?? '',
      ];
}

// --- PAYMENT MANAGEMENT EVENTS ---
class AddPaymentToOfferInvoice extends MapOfferToInvoiceEvent {
  final PaymentMethodEntryOffer payment;
  const AddPaymentToOfferInvoice({required this.payment});
  @override
  List<Object> get props => [payment];
}

class EditPaymentInOfferInvoice extends MapOfferToInvoiceEvent {
  final int index;
  final PaymentMethodEntryOffer payment;
  const EditPaymentInOfferInvoice({required this.index, required this.payment});
  @override
  List<Object> get props => [index, payment];
}

class DeletePaymentFromOfferInvoice extends MapOfferToInvoiceEvent {
  final int index;
  const DeletePaymentFromOfferInvoice({required this.index});
  @override
  List<Object> get props => [index];
}


// --- PRODUCT MANAGEMENT EVENTS (NEW LOGIC) ---
class AddProductToOfferInvoice extends MapOfferToInvoiceEvent {
  final CreateProductEntity product;
  const AddProductToOfferInvoice({required this.product});

  @override
  List<Object> get props => [product];
}

class DeleteProductFromOfferInvoice extends MapOfferToInvoiceEvent {
  final int index;
  const DeleteProductFromOfferInvoice({required this.index});

  @override
  List<Object> get props => [index];
}

class EditProductInOfferInvoice extends MapOfferToInvoiceEvent {
  final int index;
  final CreateProductEntity product; // Changed to full entity for more power

  const EditProductInOfferInvoice({
    required this.index,
    required this.product,
  });

  @override
  List<Object> get props => [index, product];
}

// --- RECALCULATION EVENTS ---
class RecalculateOfferInvoice extends MapOfferToInvoiceEvent {
  const RecalculateOfferInvoice();
}

class RecalculateAndAdjustPaymentsOfferInvoice extends MapOfferToInvoiceEvent {
  const RecalculateAndAdjustPaymentsOfferInvoice();
}

// --- UPDATE DATE AND REFERENCE FIELDS ---
class UpdateOfferInvoiceFields extends MapOfferToInvoiceEvent {
  final String? referenceNumber;
  final String? supplyDate;
  final String? serviceEndDate;
  final String? dueDate;
  final String? stockId;
  final String? employeeId;

  const UpdateOfferInvoiceFields({
    this.referenceNumber,
    this.supplyDate,
    this.serviceEndDate,
    this.dueDate,
    this.stockId,
    this.employeeId,
  });

  @override
  List<Object> get props => [
        referenceNumber ?? '',
        supplyDate ?? '',
        serviceEndDate ?? '',
        dueDate ?? '',
        stockId ?? '',
        employeeId ?? '',
      ];
}
