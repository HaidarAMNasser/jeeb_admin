import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ResetDeliveryPasswordRemoteDataSource {
  Future<Response> resetDeliveryPassword({
    required String id,
    required String password,
  });
}

class ResetDeliveryPasswordRemoteDataSourceImpl
    implements ResetDeliveryPasswordRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ResetDeliveryPasswordRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> resetDeliveryPassword({
    required String id,
    required String password,
  }) {
    return _appApiServiceClient.resetDeliveryPassword(id, password);
  }
}
