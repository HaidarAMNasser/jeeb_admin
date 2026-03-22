import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class CreateOfferRemoteDataSource {
  Future<Response> createOffer(Map<String, dynamic> body);
}

class CreateOfferRemoteDataSourceImpl implements CreateOfferRemoteDataSource {
  final AppApiServiceClient _client;

  CreateOfferRemoteDataSourceImpl(this._client);

  @override
  Future<Response> createOffer(Map<String, dynamic> body) {
    return _client.createOffer(body);
  }
}
