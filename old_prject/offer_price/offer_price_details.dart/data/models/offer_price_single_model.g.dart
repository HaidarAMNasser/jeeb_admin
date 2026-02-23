part of 'offer_price_single_model.dart';

OfferPriceSingleModel _$OfferPriceDetailsModelFromJson(
  Map<String, dynamic> json,
) {
  return OfferPriceSingleModel(
    isConverted: json['is_converted'] as bool?,
    serviceEndDate: json['service_end_date'] as String?,
    workplace: json['workplace'] == null
        ? null
        : Workplace.fromJson(json['workplace'] as Map<String, dynamic>),
    id: (json['id'] as num?)?.toInt(),
    uuid: json['uuid'] as String?,
    identificationNumber: json['identification_number'] as String?,
    referenceNumber: json['reference_number'] as String?,
    date: json['date'] as String?,
    expirationDate: json['expirationDate'] as String?,
    user: json['user'] == null
        ? null
        : ClientsDataModel.fromJson(json['user'] as Map<String, dynamic>),
    admin: json['admin'] as String?,
    employee: json['employee'] as String?,
    clientId: (json['client_id'] as num?)?.toInt(),
    status: json['status']?.toString(), // <-- Safer
    additionalNotes: json['additional_notes'] as String?,
    totalPrice: json['totalPrice']?.toString(), // <-- FIX HERE
    discountPrice: json['discountPrice']?.toString(), // <-- FIX HERE
    itemsDiscountPrice: json['itemsDiscountPrice']?.toString(), // <-- FIX HERE
    netPrice: json['netPrice']?.toString(), // <-- FIX HERE
    invoiceDiscountType: (json['invoiceDiscountType'] as num?)?.toInt(),
    invoiceDiscountValue: (json['invoiceDiscountValue'] as num?)?.toInt(),
    offerPriceDetails: (json['offerPriceDetails'] as List<dynamic>?)
        ?.map((e) => OfferPriceDetailModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    // payments: (json['payments'] as List<dynamic>?)
    //     ?.map((e) => PaymentMethodsModel.fromJson(e as Map<String, dynamic>))
    //     .toList(),
    payments: (json['payments'] as List<dynamic>?)
        ?.map((e) => OfferPricePaymentModel.fromJson(e as Map<String, dynamic>))
        .toList(),

    taxPrice: json['taxPrice'] as num?,
    totalTaxAmounts: (json['total_tax_amounts'] as List<dynamic>?)
        ?.map((e) => TotalTaxAmountModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    files: json['files'] as List<dynamic>?,
    policies: json['policies'] as List<dynamic>?,
    supplyDate: json['supply_date'] as String?,
  );
}

Map<String, dynamic> _$OfferPriceDetailsModelToJson(
  OfferPriceSingleModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'uuid': instance.uuid,
  'identification_number': instance.identificationNumber,
  'reference_number': instance.referenceNumber,
  'date': instance.date,
  'expirationDate': instance.expirationDate,
  'user': instance.user,
  'admin': instance.admin,
  'employee': instance.employee,
  'client_id': instance.clientId,
  'status': instance.status,
  'additional_notes': instance.additionalNotes,
  'totalPrice': instance.totalPrice,
  'discountPrice': instance.discountPrice,
  'itemsDiscountPrice': instance.itemsDiscountPrice,
  'netPrice': instance.netPrice,
  'invoiceDiscountType': instance.invoiceDiscountType,
  'invoiceDiscountValue': instance.invoiceDiscountValue,
  'offerPriceDetails': instance.offerPriceDetails,
  'payments': instance.payments,
  'taxPrice': instance.taxPrice,
  'total_tax_amounts': instance.totalTaxAmounts,
  'files': instance.files,
  'policies': instance.policies,
  'supply_date': instance.supplyDate,
};

TotalTaxAmountModel _$TotalTaxAmountModelFromJson(Map<String, dynamic> json) =>
    TotalTaxAmountModel(
      taxId: (json['tax_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      parentName: json['parent_name'] as String?,
      taxName: json['tax_name'] as String?,
      taxRate: json['tax_rate'] as num?,
      totalAmount: json['total_amount'] as num?,
    );

Map<String, dynamic> _$TotalTaxAmountModelToJson(
  TotalTaxAmountModel instance,
) => <String, dynamic>{
  'tax_id': instance.taxId,
  'name': instance.name,
  'parent_name': instance.parentName,
  'tax_name': instance.taxName,
  'tax_rate': instance.taxRate,
  'total_amount': instance.totalAmount,
};
OfferPricePaymentModel _$OfferPricePaymentModelFromJson(
  Map<String, dynamic> json,
) => OfferPricePaymentModel(
  id: (json['id'] as num?)?.toInt(),
  value: json['value']?.toString() ?? '',
  treasuryId: (json['treasury_id'] as num?)?.toInt(),
  bankId: (json['bank_id'] as num?)?.toInt(),
  bankName: json['bank_name']?.toString(),
  date: json['date'] as String?,
  methodId: json['method_id'] as int?,
  method: json['method'] == null
      ? null
      : PaymentMethodsDataModel.fromJson(
          json['method'] as Map<String, dynamic>,
        ),
  paymentMethod: json['payment_method'] == null
      ? null
      : PaymentMethodsDataModel.fromJson(
          json['payment_method'] as Map<String, dynamic>,
        ),
  guaranteePercent: json['guarantee_percent']?.toString(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$OfferPricePaymentModelToJson(
  OfferPricePaymentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'value': instance.value,
  'method': instance.method?.toJson(),
  'payment_method': instance.paymentMethod?.toJson(),
  'guarantee_percent': instance.guaranteePercent,
  'notes': instance.notes,
};
