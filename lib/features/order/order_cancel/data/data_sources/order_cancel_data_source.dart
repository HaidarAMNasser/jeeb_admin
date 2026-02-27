import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class OrderCancelRemoteDataSource {
  Future<Response> cancelOrder(String id);
}

class OrderCancelRemoteDataSourceImpl implements OrderCancelRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  OrderCancelRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> cancelOrder(String id) {
    return _appApiServiceClient.cancelOrder(id);
  }
}

