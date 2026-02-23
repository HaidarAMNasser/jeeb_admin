import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/classes/network_connection.dart';
import 'package:fatoorahapp/core/models/base_response_model.dart';
import 'package:fatoorahapp/core/services/errors_handler.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/data/data_source/offer_price_details_data_source.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/data/mapper/offer_price_single_mapper.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/data/models/offer_price_single_model.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';

class OfferPriceDetailsRepository {
  final OfferPriceDetailsRemoteDataSource _remoteDataSource;
  final InternetConnection _internetConnection;

  const OfferPriceDetailsRepository(
    this._remoteDataSource,
    this._internetConnection,
  );

  Future<Either<Failure, OfferPriceSingleEntity>> getOfferPriceDetails({
    required String offerPriceId,
  }) async {
    if (await _internetConnection.isConnected) {
      try {
        final response = await _remoteDataSource.getOfferPriceDetails(
          offerPriceId: offerPriceId,
        );

        BaseResponseModel<OfferPriceSingleModel> baseResponseModel =
            BaseResponseModel<OfferPriceSingleModel>.fromJson(
              response.data!,
              (json) =>
                  OfferPriceSingleModel.fromJson(json as Map<String, dynamic>),
            );

        if (baseResponseModel.status == ApiInternalStatus.success &&
            baseResponseModel.data != null) {
          return Right(baseResponseModel.data!.toDomain());
        } else {
          return Left(
            ErrorHandler.handle(
              DioException(
                type: DioExceptionType.badResponse,
                response: response,
                requestOptions: RequestOptions(),
              ),
            ).failure,
          );
        }
      } catch (error) {
        print("in the catch secddddtion ${error.toString()}");
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
}
