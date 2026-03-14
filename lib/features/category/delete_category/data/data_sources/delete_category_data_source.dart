import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class DeleteCategoryRemoteDataSource {
  Future<Response> deleteCategory(String id);
}

class DeleteCategoryRemoteDataSourceImpl
    implements DeleteCategoryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  DeleteCategoryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> deleteCategory(String id) {
    return _appApiServiceClient.deleteCategory(id);
  }
}
