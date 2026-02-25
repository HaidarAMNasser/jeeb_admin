import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class UpdateProductRemoteDataSource {
  Future<Response> updateProduct({
    required String id,
    required FormData formData,
  });
}

class UpdateProductRemoteDataSourceImpl
    implements UpdateProductRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  UpdateProductRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> updateProduct({
    required String id,
    required FormData formData,
  }) {
    return _appApiServiceClient.updateProduct(id, formData);
  }
}

