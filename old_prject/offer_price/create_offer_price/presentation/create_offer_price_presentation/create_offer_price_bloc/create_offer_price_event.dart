
part of 'create_offer_price_bloc.dart';

abstract class OfferPriceCreateEvent extends Equatable {
const OfferPriceCreateEvent();

@override
List<Object> get props => [];
}

class OfferPriceCreateSubmitted extends OfferPriceCreateEvent {
final String referenceNumber;
final int userId;
final String supplyDate;
final String serviceEndDate;
final int workPalceId;
final String expirationDate;
final int employeeId;
final List<PaymentMethodEntryOffer> payments;
final String date;
final int status;
final List<CreateProductEntity> details;

const OfferPriceCreateSubmitted({
required this.referenceNumber,
required this.userId,
required this.supplyDate,
required this.serviceEndDate,
required this.workPalceId,
required this.expirationDate,
required this.employeeId,
required this.payments,
required this.date,
required this.status,
required this.details,
});

OfferPriceCreateSubmitted copyWith({
String? referenceNumber,
int? userId,
String? supplyDate,
String? serviceEndDate,
int? workPalceId,
String? expirationDate,
int? employeeId,
List<PaymentMethodEntryOffer>? payments,
String? date,
int? status,
List<CreateProductEntity>? details,
}) {
return OfferPriceCreateSubmitted(
referenceNumber: referenceNumber ?? this.referenceNumber,
userId: userId ?? this.userId,
supplyDate: supplyDate ?? this.supplyDate,
serviceEndDate: serviceEndDate ?? this.serviceEndDate,
workPalceId: workPalceId ?? this.workPalceId,
expirationDate: expirationDate ?? this.expirationDate,
employeeId: employeeId ?? this.employeeId,
payments: payments ?? this.payments,
date: date ?? this.date,
status: status ?? this.status,
details: details ?? this.details,
);
}
}

class AddProductToOffer extends OfferPriceCreateEvent {
final CreateProductEntity detail;
const AddProductToOffer({required this.detail});
}

class DeleteProductFromOffer extends OfferPriceCreateEvent {
final int index;
const DeleteProductFromOffer({required this.index});
}

class EditProductOffer extends OfferPriceCreateEvent {
final int index;
final CreateProductEntity detail;
const EditProductOffer({required this.index, required this.detail});
}

class AddPaymentToOffer extends OfferPriceCreateEvent {
final PaymentMethodEntryOffer payment;
const AddPaymentToOffer({required this.payment});
}

class DeletePaymentFromOffer extends OfferPriceCreateEvent {
final int index;
const DeletePaymentFromOffer({required this.index});
}

class EditPaymentInOffer extends OfferPriceCreateEvent {
final int index;
final PaymentMethodEntryOffer payment;
const EditPaymentInOffer({required this.index, required this.payment});
}

class CheckValidationEvent extends OfferPriceCreateEvent {
const CheckValidationEvent();
}

class RecalculateAndAdjustPayments extends OfferPriceCreateEvent {
const RecalculateAndAdjustPayments();
}

class CheckForChangesInEditMode extends OfferPriceCreateEvent {
final OfferPriceSingleEntity initialData;
const CheckForChangesInEditMode({
required this.initialData,
});
}

class LoadInitData extends OfferPriceCreateEvent {
final List<PaymentMethodEntryOffer> payments;
final List<CreateProductEntity> details;
final String adminId;
final String clientId;
final String workPalceId;
LoadInitData(
{required this.payments,
required this.details,
required this.adminId,
required this.clientId,
required this.workPalceId,
});
}

class ChangeHasChanges extends OfferPriceCreateEvent {
final bool hasChanges;
const ChangeHasChanges({required this.hasChanges});
}
class ResetToInit extends OfferPriceCreateEvent {
final String referenceNumber;
final int userId;
final String supplyDate;
final String serviceEndDate;
final int workPalceId;
final String expirationDate;
final int employeeId;
final List<PaymentMethodEntryOffer> payments;
final String date;
final int status;
final List<CreateProductEntity> details;

const ResetToInit({ // Corrected constructor name
required this.referenceNumber,
required this.userId,
required this.supplyDate,
required this.serviceEndDate,
required this.workPalceId,
required this.expirationDate,
required this.employeeId,
required this.payments,
required this.date,
required this.status,
required this.details,
});
}

