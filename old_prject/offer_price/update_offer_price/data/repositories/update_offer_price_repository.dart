import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/classes/network_connection.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/models/base_response_model.dart';
import 'package:fatoorahapp/core/services/errors_handler.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/data/models/offer_price_model.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/mapper/offer_price_mapper.dart';
import 'package:fatoorahapp/feature/offer_price/update_offer_price/data/data_source/update_offer_price_data_source.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';

class OfferPriceUpdateRepository {
  final OfferPriceUpdateRemoteDataSource _remoteDataSource;
  final InternetConnection _internetConnection;

  const OfferPriceUpdateRepository(
    this._remoteDataSource,
    this._internetConnection,
  );

  Future<Either<Failure, OfferPriceEntity>> updateOfferPrice({
    required String offerPriceId,
    required String referenceNumber,
    required int userId,
    required String supplyDate,
    required String serviceEndDate,
    required int workPalceId,
    required String expirationDate,
    required int employeeId,
    required List<PaymentMethodEntryOffer> payments,
    required String date,
    required int status,
    required List<CreateProductEntity> details,
  }) async {
    if (await _internetConnection.isConnected) {
      try {
        final response = await _remoteDataSource.updateOfferPrice(
          offerPriceId: offerPriceId,
          referenceNumber: referenceNumber,
          userId: userId,
          supplyDate: supplyDate,
          serviceEndDate: serviceEndDate,
          workPalceId: workPalceId,
          expirationDate: expirationDate,
          employeeId: employeeId,
          payments: payments,
          date: date,
          status: status,
          details: details,
        );

        BaseResponseModel<OfferPriceModel> baseResponseModel =
            BaseResponseModel<OfferPriceModel>.fromJson(
          response.data!,
          (json) => OfferPriceModel.fromJson(json as Map<String, dynamic>),
        );

        if (baseResponseModel.status == ApiInternalStatus.success) {
          return Right(baseResponseModel.data!.toDomain());
        } else {
          return Left(ErrorHandler.handle(DioException(
            type: DioExceptionType.badResponse,
            response: response,
            requestOptions: RequestOptions(),
          )).failure);
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
}
