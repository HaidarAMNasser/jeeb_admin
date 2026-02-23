import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/classes/entities/sale_invoice_entity.dart';
import 'package:fatoorahapp/core/classes/mappers/sale_invoice_mapper.dart';
import 'package:fatoorahapp/core/classes/models/sale_invoice_model/sale_invoice_model.dart';
import 'package:fatoorahapp/core/classes/network_connection.dart';
import 'package:fatoorahapp/core/models/base_response_model.dart';
import 'package:fatoorahapp/core/services/errors_handler.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/data/data_source/offer_to_sale_Invoice_data_source.dart';

class MapOfferToInvoiceRepository {
  final MapOfferToInvoiceRemoteDataSource _remoteDataSource;
  final InternetConnection _internetConnection;

  MapOfferToInvoiceRepository(this._remoteDataSource, this._internetConnection);

  Future<Either<Failure, SaleInvoiceEntity>> mapOfferToInvoice(
      {required String uuid}) async {
    if (await _internetConnection.isConnected) {
      try {
        final response = await _remoteDataSource.mapOfferToInvoice(uuid: uuid);
        BaseResponseModel<SaleInvoiceModel> baseResponseModel =
            BaseResponseModel<SaleInvoiceModel>.fromJson(
                response.data,
                (json) =>
                    SaleInvoiceModel.fromJson(json as Map<String, dynamic>));
        if (baseResponseModel.status == ApiInternalStatus.success) {
          return Right(baseResponseModel.data.toDomain());
        } else {
          return Left(ErrorHandler.handle(DioException(
                  type: DioExceptionType.badResponse,
                  response: response,
                  requestOptions: RequestOptions()))
              .failure);
        }
      } catch (error) {
        print("in the catch section $error");
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
}
