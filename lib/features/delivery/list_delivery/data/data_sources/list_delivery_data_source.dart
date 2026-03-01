import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ListDeliveryRemoteDataSource {
  Future<Response> getDeliveryMen({
    int? page,
    int? limit,
    String? search,
    bool? isOnline,
    int? officeOwnerId,
    int? countryId,
    int? cityId,
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
    bool? isOnline,
    int? officeOwnerId,
    int? countryId,
    int? cityId,
  }) {
    return _appApiServiceClient.getDeliveryMen(
      page: page,
      limit: limit,
      search: search,
      isOnline: isOnline,
      officeOwnerId: officeOwnerId,
      countryId: countryId,
      cityId: cityId,
    );
  }
}
