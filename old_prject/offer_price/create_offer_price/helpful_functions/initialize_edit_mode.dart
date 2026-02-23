import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Initializes edit mode data from offer price entity
class EditModeInitializer {
  /// Initialize all fields and dispatch bloc event for edit mode
  static void initializeEditMode({
    required BuildContext context,
    required OfferPriceSingleEntity entity,
    required String? adminId,
    required TextEditingController refrenceNumber,
    required TextEditingController identificationNumber,
    required Function(String) setSelectedAdmin,
    required Function(String) setSelectedClient,
    required Function(int) setSelectedWorkPlace,
    required Function(String) setDate,
    required Function(String) setExpirationDate,
    required Function(String) setSupplyDate,
    required Function(String) setServiceEndDate,
  }) {
    // Initialize basic fields
    setSelectedAdmin(adminId ?? "");
    setSelectedClient(entity.user.id.toString());
    setSelectedWorkPlace(entity.workplaceEntity.id);
    refrenceNumber.text = entity.referenceNumber.toString();
    identificationNumber.text = entity.identificationNumber.toString();

    // Initialize date fields from backend if not null or empty
    if (entity.date.isNotEmpty && entity.date != "null") {
      setDate(entity.date);
    }
    if (entity.expirationDate.isNotEmpty && entity.expirationDate != "null") {
      setExpirationDate(entity.expirationDate);
    }
    if (entity.supplyDate.isNotEmpty && entity.supplyDate != "null") {
      setSupplyDate(entity.supplyDate);
    }
    if (entity.serviceEndDate.isNotEmpty && entity.serviceEndDate != "null") {
      setServiceEndDate(entity.serviceEndDate);
    }

    // Initialize products
    final initialProducts = entity.offerPriceDetails
        .map(
          (e) => CreateProductEntity(
            salePrice: e.product.salePrice,
            highestDiscountRate: e.product.highestDiscountRate,
            name: e.product.name,
            id: e.product.id.toString(),
            discountValue: e.discountValue.toString(),
            discountType: e.discountType == 1
                ? LocalData.instance.disCountTypes[0].title
                : LocalData.instance.disCountTypes[1].title,
            discountTypeId: e.discountType.toString(),
            tax: e.taxes.map((e) => e.taxName).join(','),
            price: e.price,
            taxValue: e.taxes.map((e) => e.taxRate).join(','),
            quantity: e.quantity,
            taxId: e.taxes.map((e) => e.id).join(','),
            taxKey: e.taxes.map((e) => e.key).join(','),
            disCountReason: '',
            disCountReasonId: e.reasonId.toString(),
            taxReasonId: e.taxes.map((e) => e.taxReason?.id).join(','),
            taxReason: e.taxes.map((e) => e.taxReason?.descriptionAr).join(','),
          ),
        )
        .toList();

    // Initialize payments
    final initialPayments = entity.payments.map((e) {
      // Use effectivePaymentMethodId to determine behavior
      final effectiveId = e.effectivePaymentMethodId;

      return PaymentMethodEntryOffer(
        id: e.method.id.toString(),
        paymentType: e.method.name,
        type: e.method.type, // Preserve type
        parentId: e.method.parentId, // Preserve parentId
        amount: TextEditingController(text: e.value),
        bankId: effectiveId == 1 || effectiveId == 3 || effectiveId == 5
            ? e.bankId.toString()
            : null,
        bankName: effectiveId == 1 || effectiveId == 3 || effectiveId == 5
            ? e.bankName
            : null,
        dueDate: effectiveId == 2 || effectiveId == 8 ? e.date : null,
        note: e.notes, // Preserve notes for Business Guarantee
        guaranteePercent: e.guaranteePercent, // Preserve guarantee percent
      );
    }).toList();

    // Dispatch initialization event to bloc
    BlocProvider.of<OfferPriceCreateBloc>(context).add(
      LoadInitData(
        payments: initialPayments,
        details: initialProducts,
        adminId: entity.admin.toString(),
        clientId: entity.user.id.toString(),
        workPalceId: entity.workplaceEntity.id.toString(),
      ),
    );
  }
}
