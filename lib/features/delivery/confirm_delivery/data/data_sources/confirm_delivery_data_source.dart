import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ConfirmDeliveryRemoteDataSource {
  Future<Response> confirmDeliveryMan(String id);
}

class ConfirmDeliveryRemoteDataSourceImpl
    implements ConfirmDeliveryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ConfirmDeliveryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> confirmDeliveryMan(String id) {
    return _appApiServiceClient.confirmDeliveryMan(id);
  }
}

