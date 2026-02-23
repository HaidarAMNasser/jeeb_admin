import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/services/api_service.dart';

class MapOfferToInvoiceRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  MapOfferToInvoiceRemoteDataSource(this._appApiServiceClient);

  Future<Response> mapOfferToInvoice({required String uuid}) {
    return _appApiServiceClient.mapOfferToInvoice(uuid);
  }
}
