import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ListOfferRemoteDataSource {
  Future<Response> getOffers({
    int? page,
    int? limit,
    String? merchantId,
  });
}

class ListOfferRemoteDataSourceImpl implements ListOfferRemoteDataSource {
  final AppApiServiceClient _client;

  ListOfferRemoteDataSourceImpl(this._client);

  @override
  Future<Response> getOffers({
    int? page,
    int? limit,
    String? merchantId,
  }) {
    return _client.getOffers(
      page: page,
      limit: limit,
      merchantId: merchantId,
    );
  }
}
