import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/classes/network_connection.dart';
import 'package:fatoorahapp/core/models/base_response_model.dart';
import 'package:fatoorahapp/core/services/errors_handler.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/data/data_sourse/offer_price_data_sourse.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/data/models/offer_price_model.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/mapper/offer_price_mapper.dart';

class OfferPriceRepository {
  final OfferPriceRemoteDataSource _offerPriceRemoteDataSource;
  final InternetConnection _internetConnection;

  const OfferPriceRepository(
      this._offerPriceRemoteDataSource, this._internetConnection);

  Future<Either<Failure, OfferPriceEntity>> offerPrices({
    required Map<String, dynamic> queries,
  }) async {
    if (await _internetConnection.isConnected) {
      try {
        final response =
            await _offerPriceRemoteDataSource.offerPrices(queries: queries);

        BaseResponseModel<OfferPriceModel> baseResponseModel =
            BaseResponseModel<OfferPriceModel>.fromJson(
          response.data!,
          (json) => OfferPriceModel.fromJson(json as Map<String, dynamic>),
        );

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
        print("in the catch$error");
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
}
