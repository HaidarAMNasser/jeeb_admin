import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class DeleteCategoryRemoteDataSource {

  Future<Response> deleteCategory(int id);
}

class DeleteCategoryRemoteDataSourceImpl
    implements DeleteCategoryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  DeleteCategoryRemoteDataSourceImpl(this._appApiServiceClient);

  @override

  Future<Response> deleteCategory(int id) {
    return _appApiServiceClient.deleteCategory(id.toString());
  }
}
