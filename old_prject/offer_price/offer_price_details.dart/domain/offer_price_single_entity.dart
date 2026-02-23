import 'package:equatable/equatable.dart';
import 'package:fatoorahapp/core/classes/entities/workplace_entity.dart';
import 'package:fatoorahapp/feature/clients/clients/domain/entities/clients_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/payment_method/domain/entities/payment_methods_entity.dart';

class OfferPriceSingleEntity extends Equatable {
  final int id;
  final String uuid;
  final String identificationNumber;
  final String referenceNumber;
  final String date;
  final String expirationDate;
  final bool isConverted;
  final ClientsDataEntity user;
  final String admin;
  final String employee;
  final int clientId;
  final String status;
  final String additionalNotes;
  final String totalPrice;
  final String discountPrice;
  final String itemsDiscountPrice;
  final String netPrice;
  final int invoiceDiscountType;
  final int invoiceDiscountValue;
  final List<OfferPriceDetailEntity> offerPriceDetails;
  final List<OfferPricePaymentEntity> payments;
  final num taxPrice;
  final List<TotalTaxAmountEntity> totalTaxAmounts;
  final List<dynamic> files;
  final List<dynamic> policies;
  final String supplyDate;
  final WorkplaceEntity workplaceEntity;
  final String serviceEndDate;
  // final TaxEntity taxEntity;

  const OfferPriceSingleEntity({
    required this.id,
    required this.uuid,
    required this.identificationNumber,
    required this.referenceNumber,
    required this.workplaceEntity,
    required this.date,
    required this.expirationDate,
    required this.isConverted,
    required this.user,
    required this.admin,
    required this.employee,
    required this.clientId,
    required this.status,
    required this.additionalNotes,
    required this.totalPrice,
    required this.discountPrice,
    required this.itemsDiscountPrice,
    required this.netPrice,
    required this.invoiceDiscountType,
    required this.invoiceDiscountValue,
    required this.offerPriceDetails,
    required this.payments,
    required this.taxPrice,
    required this.totalTaxAmounts,
    required this.files,
    required this.policies,
    required this.supplyDate,
    required this.serviceEndDate,
    // required this.taxEntity
  });

  @override
  List<Object?> get props => [
    id,
    uuid,
    identificationNumber,
    referenceNumber,
    date,
    expirationDate,
    user,
    admin,
    employee,
    clientId,
    status,
    additionalNotes,
    totalPrice,
    discountPrice,
    itemsDiscountPrice,
    netPrice,
    invoiceDiscountType,
    invoiceDiscountValue,
    offerPriceDetails,
    payments,
    taxPrice,
    totalTaxAmounts,
    files,
    policies,
    supplyDate,
  ];
}

class TotalTaxAmountEntity extends Equatable {
  final int taxId;
  final String name;
  final String parentName;
  final String taxName;
  final num taxRate;
  final num totalAmount;

  const TotalTaxAmountEntity({
    required this.taxId,
    required this.name,
    required this.parentName,
    required this.taxName,
    required this.taxRate,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [
    taxId,
    name,
    parentName,
    taxName,
    taxRate,
    totalAmount,
  ];
}

class OfferPricePaymentEntity extends Equatable {
  final int id;
  final String value;
  final PaymentMethodsDataEntity method;
  final int bankId;
  final int treasuryId;
  final String date;
  final int methodId;
  final String? bankName;
  final String? treasuryName;
  final String? guaranteePercent;
  final String? notes; // For Business Guarantee notes

  const OfferPricePaymentEntity({
    required this.id,
    required this.value,
    required this.method,
    required this.bankId,
    required this.date,
    required this.methodId,
    this.bankName,
    this.treasuryName,
    required this.treasuryId,
    this.guaranteePercent,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    value,
    method,
    bankId,
    treasuryId,
    date,
    methodId,
    bankName,
    treasuryName,
    guaranteePercent,
  ];
}

/// Extension to get effective payment method ID for UI/behavior classification
/// Returns parent_id if it exists (for child payment methods), otherwise returns the actual id
extension OfferPricePaymentEntityExtension on OfferPricePaymentEntity {
  /// Returns the effective payment method ID to use for UI/behavior classification
  /// If parent_id exists, use it; otherwise use the actual id
  /// This allows child payment methods to inherit the behavior of their parent
  int get effectivePaymentMethodId {
    return method.parentId ?? method.id;
  }
}
