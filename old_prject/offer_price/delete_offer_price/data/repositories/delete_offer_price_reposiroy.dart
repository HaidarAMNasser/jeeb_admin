import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fatoorahapp/core/classes/entities/base_response_entity.dart';
import 'package:fatoorahapp/core/classes/mappers/base_response_mapper.dart';
import 'package:fatoorahapp/core/classes/network_connection.dart';
import 'package:fatoorahapp/core/models/base_response_model.dart';
import 'package:fatoorahapp/feature/offer_price/delete_offer_price/data/data_source/delete_offer_price_data_sourse.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/errors_handler.dart';


class DeleteOfferPriceRepository {
  final DeleteOfferPriceRemoteDataSource _deleteOfferPriceRemoteDataSource;
  final InternetConnection _internetConnection;

  DeleteOfferPriceRepository(
      this._deleteOfferPriceRemoteDataSource, this._internetConnection);

  Future<Either<Failure, BaseResponseEntity>> deleteOfferPrice(
      {required String id}) async {
    if (await _internetConnection.isConnected) {
      try {
        final response =
            await _deleteOfferPriceRemoteDataSource.deleteOfferPrice(id: id);
        BaseResponseModel baseResponseModel =
            BaseResponseModel.fromJson(response.data!, (json) => null);
        if (baseResponseModel.status == ApiInternalStatus.success) {
          return Right(baseResponseModel.toDomain());
        } else {
          return Left(ErrorHandler.handle(DioException(
                  type: DioExceptionType.badResponse,
                  response: response,
                  requestOptions: RequestOptions()))
              .failure);
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
}
