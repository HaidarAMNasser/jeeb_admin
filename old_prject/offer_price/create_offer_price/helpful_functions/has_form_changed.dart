import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'check_payment_differences.dart';

void dispatchChangesIfNeeded({
  required BuildContext context,
  required OfferPriceSingleEntity? initialData,
  required String initialAdminId,
  required String currentClientId,
  required String currentAdminId,
  required int currentWorkplaceId,
  required String currentExpirationDate,
  required String currentSupplyDate,
  required String currentServiceEndDate,
  required String currentReferenceNumber,
}) {
  if (initialData == null) return;

  final bloc = context.read<OfferPriceCreateBloc>();

  final currentPayments = bloc.getPayments();

  final initialPaymentsFromBloc = bloc.initialPayments;



  bool hasFormChanged = false;

  if (initialData.user.id.toString() != currentClientId ||
      initialAdminId != currentAdminId ||
      initialData.workplaceEntity.id != currentWorkplaceId ||
      initialData.referenceNumber != currentReferenceNumber ||
      (currentExpirationDate.isNotEmpty &&
          initialData.expirationDate != currentExpirationDate) ||
      (currentSupplyDate.isNotEmpty &&
          initialData.supplyDate != currentSupplyDate) ||
      (currentServiceEndDate.isNotEmpty &&
          initialData.serviceEndDate != currentServiceEndDate) ||
      checkPaymentDifferences(initialPaymentsFromBloc, currentPayments)) {
    hasFormChanged = true;
  }
  bloc.add(ChangeHasChanges(hasChanges: hasFormChanged));
}
