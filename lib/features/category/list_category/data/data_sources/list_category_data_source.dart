import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ListCategoryRemoteDataSource {
  Future<Response> getCategories({int? page, int? limit, String? search});
}

class ListCategoryRemoteDataSourceImpl implements ListCategoryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ListCategoryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> getCategories({int? page, int? limit, String? search}) {
    return _appApiServiceClient.getCategories(page, limit, search);
  }
}

