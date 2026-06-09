import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class AreaDetailsRemoteDataSource {
  Future<Response> getAreaDetails(String id);
}

class AreaDetailsRemoteDataSourceImpl implements AreaDetailsRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  AreaDetailsRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> getAreaDetails(String id) {
    return _appApiServiceClient.getAreaDetails(id);
  }
}
