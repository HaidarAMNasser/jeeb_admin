import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class DeleteDeliveryRemoteDataSource {
  Future<Response> deleteDeliveryMan(String id);
}

class DeleteDeliveryRemoteDataSourceImpl
    implements DeleteDeliveryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  DeleteDeliveryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> deleteDeliveryMan(String id) {
    return _appApiServiceClient.deleteDeliveryMan(id);
  }
}
