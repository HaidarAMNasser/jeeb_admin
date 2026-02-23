import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class AddCategoryRemoteDataSource {
  Future<Response> addCategory({required String name});
}

class AddCategoryRemoteDataSourceImpl
    implements AddCategoryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  AddCategoryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> addCategory({required String name}) {
    return _appApiServiceClient.addCategory(name);
  }
}

