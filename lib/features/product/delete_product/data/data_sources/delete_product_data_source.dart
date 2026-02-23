import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class DeleteProductRemoteDataSource {
  Future<Response> deleteProduct(String id);
}

class DeleteProductRemoteDataSourceImpl
    implements DeleteProductRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  DeleteProductRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> deleteProduct(String id) {
    return _appApiServiceClient.deleteProduct(id);
  }
}

