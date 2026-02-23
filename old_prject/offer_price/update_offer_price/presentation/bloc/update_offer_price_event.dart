part of 'update_offer_price_bloc.dart';

abstract class OfferPriceUpdateEvent extends Equatable {
  const OfferPriceUpdateEvent();

  @override
  List<Object?> get props => [];
}

class OfferPriceUpdateSubmitted extends OfferPriceUpdateEvent {
  final String offerPriceId;
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

  const OfferPriceUpdateSubmitted({
    required this.offerPriceId,
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

  @override
  List<Object?> get props => [
        offerPriceId,
        referenceNumber,
        userId,
        supplyDate,
        serviceEndDate,
        workPalceId,
        expirationDate,
        employeeId,
        payments,
        date,
        status,
        details,
      ];
}

class ResetUpdateToInit extends OfferPriceUpdateEvent {
  final List<CreateProductEntity> details;
  final List<PaymentMethodEntryOffer> payments;
  final String referenceNumber;
  final int userId;
  final String supplyDate;
  final String serviceEndDate;
  final int workPalceId;
  final String expirationDate;
  final int employeeId;
  final String date;
  final int status;

  const ResetUpdateToInit({
    required this.details,
    required this.payments,
    required this.referenceNumber,
    required this.userId,
    required this.supplyDate,
    required this.serviceEndDate,
    required this.workPalceId,
    required this.expirationDate,
    required this.employeeId,
    required this.date,
    required this.status,
  });
}