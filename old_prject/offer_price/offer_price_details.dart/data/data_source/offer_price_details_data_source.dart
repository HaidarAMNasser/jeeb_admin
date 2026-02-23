import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/services/api_service.dart';

class OfferPriceDetailsRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  OfferPriceDetailsRemoteDataSource(this._appApiServiceClient);

  Future<Response> getOfferPriceDetails({required String offerPriceId}) {
    return _appApiServiceClient.getOfferPriceDetails(offerPriceId);
  }
}
