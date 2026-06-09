import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class DeleteAreaRemoteDataSource {
  Future<Response> deleteArea(String id);
}

class DeleteAreaRemoteDataSourceImpl implements DeleteAreaRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  DeleteAreaRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> deleteArea(String id) {
    return _appApiServiceClient.deleteArea(id);
  }
}
