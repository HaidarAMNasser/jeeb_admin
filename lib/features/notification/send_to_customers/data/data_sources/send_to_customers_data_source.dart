import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class SendToCustomersRemoteDataSource {
  Future<Response> sendNotification({
    required String title,
    required String body,
  });
}

class SendToCustomersRemoteDataSourceImpl
    implements SendToCustomersRemoteDataSource {
  final AppApiServiceClient _client;

  SendToCustomersRemoteDataSourceImpl(this._client);

  @override
  Future<Response> sendNotification({
    required String title,
    required String body,
  }) {
    return _client.sendNotificationToCustomers({
      'title': title,
      'body': body,
    });
  }
}
