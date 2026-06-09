import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ConfirmPaidOrderRemoteDataSource {
  Future<Response> confirmPaidOrder(
    String orderId, {
    String? imagePayFromDelivery,
  });
}

class ConfirmPaidOrderRemoteDataSourceImpl
    implements ConfirmPaidOrderRemoteDataSource {
  final AppApiServiceClient _client;

  ConfirmPaidOrderRemoteDataSourceImpl(this._client);

  @override
  Future<Response> confirmPaidOrder(
    String orderId, {
    String? imagePayFromDelivery,
  }) {
    return _client.completeOrder(
      orderId,
      body: {
        'imagePayFromDelivery': imagePayFromDelivery ?? '',
      },
    );
  }
}
