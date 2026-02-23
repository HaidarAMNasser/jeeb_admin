import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/services/api_service.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:intl/intl.dart';

class OfferPriceUpdateRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  OfferPriceUpdateRemoteDataSource(this._appApiServiceClient);

  Future<Response> updateOfferPrice({
    required String offerPriceId,
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
    return _appApiServiceClient.updateOfferPrice(
      offerPriceId.toString(),
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
