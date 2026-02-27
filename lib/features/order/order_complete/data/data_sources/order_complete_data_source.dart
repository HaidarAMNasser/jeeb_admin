import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class OrderCompleteRemoteDataSource {
  Future<Response> completeOrder(String id);
}

class OrderCompleteRemoteDataSourceImpl implements OrderCompleteRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  OrderCompleteRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> completeOrder(String id) {
    return _appApiServiceClient.completeOrder(id);
  }
}

