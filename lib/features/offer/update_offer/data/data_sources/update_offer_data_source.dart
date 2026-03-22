import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class UpdateOfferRemoteDataSource {
  Future<Response> updateOffer(String id, Map<String, dynamic> body);
}

class UpdateOfferRemoteDataSourceImpl implements UpdateOfferRemoteDataSource {
  final AppApiServiceClient _client;

  UpdateOfferRemoteDataSourceImpl(this._client);

  @override
  Future<Response> updateOffer(String id, Map<String, dynamic> body) {
    return _client.updateOffer(id, body);
  }
}
