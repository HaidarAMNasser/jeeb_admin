import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class DeleteOfferRemoteDataSource {
  Future<Response> deleteOffer(String id);
}

class DeleteOfferRemoteDataSourceImpl implements DeleteOfferRemoteDataSource {
  final AppApiServiceClient _client;

  DeleteOfferRemoteDataSourceImpl(this._client);

  @override
  Future<Response> deleteOffer(String id) {
    return _client.deleteOffer(id);
  }
}
