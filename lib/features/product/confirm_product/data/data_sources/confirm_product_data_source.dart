import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ConfirmProductRemoteDataSource {
  Future<Response> confirmProduct({
    required String productId,
    required double newPrice,
  });
}

class ConfirmProductRemoteDataSourceImpl
    implements ConfirmProductRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ConfirmProductRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> confirmProduct({
    required String productId,
    required double newPrice,
  }) {
    return _appApiServiceClient.confirmProduct(productId, newPrice);
  }
}

