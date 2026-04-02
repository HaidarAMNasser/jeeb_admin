import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ListOrderRemoteDataSource {
  Future<Response> getOrders({
    int? page,
    int? limit,
    String? search,
    String? status,
    String? merchantId,
  });

  Future<Response> confirmOrder(String id, Map<String, dynamic>? body);

  Future<Response> setOrderPreparing(String id);

  Future<Response> setOrderReadyForPickup(String id);
}

class ListOrderRemoteDataSourceImpl implements ListOrderRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ListOrderRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> getOrders({
    int? page,
    int? limit,
    String? search,
    String? status,
    String? merchantId,
  }) {
    return _appApiServiceClient.getOrders(
      page: page,
      limit: limit,
      search: search,
      status: status,
      merchantId: merchantId,
    );
  }

  @override
  Future<Response> confirmOrder(String id, Map<String, dynamic>? body) {
    return _appApiServiceClient.confirmOrder(id, body);
  }

  @override
  Future<Response> setOrderPreparing(String id) {
    return _appApiServiceClient.setOrderPreparing(id);
  }

  @override
  Future<Response> setOrderReadyForPickup(String id) {
    return _appApiServiceClient.setOrderReadyForPickup(id);
  }
}

