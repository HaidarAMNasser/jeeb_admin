import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class CreateAreaRemoteDataSource {
  Future<Response> createArea(Map<String, dynamic> body);
}

class CreateAreaRemoteDataSourceImpl implements CreateAreaRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  CreateAreaRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> createArea(Map<String, dynamic> body) {
    return _appApiServiceClient.createArea(body);
  }
}
