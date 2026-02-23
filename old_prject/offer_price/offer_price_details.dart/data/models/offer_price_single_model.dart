import 'package:fatoorahapp/core/classes/models/workplace_model/workplace_model.dart';
import 'package:fatoorahapp/feature/clients/clients/data/models/clients_model.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/data/models/offer_price_model.dart';
import 'package:fatoorahapp/feature/payment_method/data/models/payment_methods_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_price_single_model.g.dart';

@JsonSerializable()
class OfferPriceSingleModel {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'uuid')
  String? uuid;
  @JsonKey(name: 'identification_number')
  String? identificationNumber;
  @JsonKey(name: 'reference_number')
  String? referenceNumber;
  @JsonKey(name: 'date')
  String? date;
  @JsonKey(name: 'expirationDate')
  String? expirationDate;
  @JsonKey(name: 'user')
  ClientsDataModel? user;
  @JsonKey(name: 'admin')
  String? admin;
  @JsonKey(name: 'employee')
  String? employee;
  @JsonKey(name: 'client_id')
  int? clientId;
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'additional_notes')
  String? additionalNotes;
  @JsonKey(name: 'totalPrice')
  String? totalPrice;
  @JsonKey(name: 'discountPrice')
  String? discountPrice;
  @JsonKey(name: 'itemsDiscountPrice')
  String? itemsDiscountPrice;
  @JsonKey(name: 'netPrice')
  String? netPrice;
  @JsonKey(name: 'invoiceDiscountType')
  int? invoiceDiscountType;
  @JsonKey(name: 'invoiceDiscountValue')
  int? invoiceDiscountValue;
  @JsonKey(name: 'offerPriceDetails')
  List<OfferPriceDetailModel>? offerPriceDetails;
  @JsonKey(name: 'payments')
  List<OfferPricePaymentModel>? payments;

  @JsonKey(name: 'taxPrice')
  num? taxPrice;
  @JsonKey(name: 'total_tax_amounts')
  List<TotalTaxAmountModel>? totalTaxAmounts;
  @JsonKey(name: 'files')
  List<dynamic>? files;
  @JsonKey(name: 'policies')
  List<dynamic>? policies;
  @JsonKey(name: 'supply_date')
  String? supplyDate;
  @JsonKey(name: 'service_end_date')
  String? serviceEndDate;
  @JsonKey(name: 'workplace')
  Workplace? workplace;
  @JsonKey(name: 'is_converted')
  bool? isConverted;
  // @JsonKey(name: 'tax')
  // TaxModel? taxEntity;

  OfferPriceSingleModel({
    this.id,
    this.uuid,
    this.identificationNumber,
    this.referenceNumber,
    this.date,
    this.isConverted,
    this.expirationDate,
    this.user,
    this.admin,
    this.employee,
    this.clientId,
    this.workplace,
    this.status,
    this.serviceEndDate,
    this.additionalNotes,
    this.totalPrice,
    this.discountPrice,
    this.itemsDiscountPrice,
    this.netPrice,
    this.invoiceDiscountType,
    this.invoiceDiscountValue,
    this.offerPriceDetails,
    this.payments,
    this.taxPrice,
    this.totalTaxAmounts,
    this.files,
    this.policies,
    this.supplyDate,
  });

  factory OfferPriceSingleModel.fromJson(Map<String, dynamic> json) =>
      _$OfferPriceDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferPriceDetailsModelToJson(this);
}

@JsonSerializable()
class TotalTaxAmountModel {
  @JsonKey(name: 'tax_id')
  int? taxId;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'parent_name')
  String? parentName;
  @JsonKey(name: 'tax_name')
  String? taxName;
  @JsonKey(name: 'tax_rate')
  num? taxRate;
  @JsonKey(name: 'total_amount')
  num? totalAmount;

  TotalTaxAmountModel({
    this.taxId,
    this.name,
    this.parentName,
    this.taxName,
    this.taxRate,
    this.totalAmount,
  });

  factory TotalTaxAmountModel.fromJson(Map<String, dynamic> json) =>
      _$TotalTaxAmountModelFromJson(json);

  Map<String, dynamic> toJson() => _$TotalTaxAmountModelToJson(this);
}

@JsonSerializable()
class OfferPricePaymentModel {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'value')
  String? value;
  @JsonKey(name: 'method')
  PaymentMethodsDataModel? method; // For older API responses
  @JsonKey(name: 'payment_method')
  PaymentMethodsDataModel? paymentMethod; // For newer API responses
  @JsonKey(name: 'bank_id')
  int? bankId;

  @JsonKey(name: 'bank_name')
  String? bankName;

  @JsonKey(name: 'date')
  String? date;
  @JsonKey(name: 'treasury_id')
  int? treasuryId;
  @JsonKey(name: 'method_id')
  int? methodId;
  @JsonKey(name: 'guarantee_percent')
  String? guaranteePercent;
  @JsonKey(name: 'notes')
  String? notes; // For Business Guarantee notes

  OfferPricePaymentModel({
    this.id,
    this.value,
    this.method,
    this.paymentMethod,
    this.bankId,
    this.bankName,
    this.date,
    this.treasuryId,
    this.methodId,
    this.guaranteePercent,
    this.notes,
  });

  factory OfferPricePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$OfferPricePaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferPricePaymentModelToJson(this);
}
