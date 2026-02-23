import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/services/api_service.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';

class OfferPriceCreateRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  OfferPriceCreateRemoteDataSource(this._appApiServiceClient);

  Future<Response> createOfferPrice({
    required String referenceNumber,
    required int userId,
    required String supplyDate,
    required String serviceEndDate,
    required int workPalceId,
    required String expirationDate,
    required int employeeId,
    required List<PaymentMethodEntryOffer> payments,
    required String date,
    required int status,
    required List<CreateProductEntity> details,
  }) {
    return _appApiServiceClient.createOfferPrice(
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
    );
  }
}
