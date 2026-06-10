import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class MerchantStatisticsRemoteDataSource {
  Future<Response> getMerchantStatistics({
    int? page,
    int? limit,
    String? search,
    String? from,
    String? to,
    int? merchantId,
  });
}

class MerchantStatisticsRemoteDataSourceImpl
    implements MerchantStatisticsRemoteDataSource {
  final AppApiServiceClient _api;

  const MerchantStatisticsRemoteDataSourceImpl(this._api);

  @override
  Future<Response> getMerchantStatistics({
    int? page,
    int? limit,
    String? search,
    String? from,
    String? to,
    int? merchantId,
  }) {
    return _api.getMerchantStatistics(
      page: page,
      limit: limit,
      search: search,
      from: from,
      to: to,
      merchantId: merchantId,
    );
  }
}
