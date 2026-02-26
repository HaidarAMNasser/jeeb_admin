import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ListMerchantRemoteDataSource {
  Future<Response> getMerchants({
    int? page,
    int? limit,
    String? search,
  });
}

class ListMerchantRemoteDataSourceImpl implements ListMerchantRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ListMerchantRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> getMerchants({
    int? page,
    int? limit,
    String? search,
  }) {
    return _appApiServiceClient.getMerchants(
      page: page,
      limit: limit,
      search: search,
    );
  }
}

