import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ListProductRemoteDataSource {
  Future<Response> getProducts();
}

class ListProductRemoteDataSourceImpl implements ListProductRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ListProductRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> getProducts() {
    return _appApiServiceClient.getProducts();
  }
}

