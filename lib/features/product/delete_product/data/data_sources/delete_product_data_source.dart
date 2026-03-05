import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class DeleteProductRemoteDataSource {
  Future<Response> deleteProduct(String id);
  Future<Response> deleteProductImage(String imageId);
}

class DeleteProductRemoteDataSourceImpl
    implements DeleteProductRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  DeleteProductRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> deleteProduct(String id) {
    return _appApiServiceClient.deleteProduct(id);
  }

  @override
  Future<Response> deleteProductImage(String imageId) {
    return _appApiServiceClient.deleteProductImage(imageId);
  }
}
