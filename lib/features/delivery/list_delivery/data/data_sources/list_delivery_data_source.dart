import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ListDeliveryRemoteDataSource {
  Future<Response> getDeliveryMen({
    int? page,
    int? limit,
    String? search,
  });
}

class ListDeliveryRemoteDataSourceImpl implements ListDeliveryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ListDeliveryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> getDeliveryMen({
    int? page,
    int? limit,
    String? search,
  }) {
    return _appApiServiceClient.getDeliveryMen(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
