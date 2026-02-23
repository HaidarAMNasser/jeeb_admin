import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/services/api_service.dart';

class DeleteOfferPriceRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  DeleteOfferPriceRemoteDataSource(this._appApiServiceClient);

  Future<Response> deleteOfferPrice({required String id}) {
    return _appApiServiceClient.deleteOfferPrice(id);
  }
}
