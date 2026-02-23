import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/services/api_service.dart';

class OfferPriceRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;
  
  OfferPriceRemoteDataSource(this._appApiServiceClient);

  Future<Response> offerPrices({required Map<String, dynamic> queries}) {
    return _appApiServiceClient.offerPrices(queries);
  }
}
