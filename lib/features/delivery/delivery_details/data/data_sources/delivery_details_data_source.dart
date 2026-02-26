import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class DeliveryDetailsRemoteDataSource {
  Future<Response> getDeliveryManDetails(String id);
}

class DeliveryDetailsRemoteDataSourceImpl
    implements DeliveryDetailsRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  DeliveryDetailsRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> getDeliveryManDetails(String id) {
    return _appApiServiceClient.getDeliveryManDetails(id);
  }
}
