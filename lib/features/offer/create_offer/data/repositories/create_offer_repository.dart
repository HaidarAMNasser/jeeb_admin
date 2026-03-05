import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/offer/create_offer/data/data_sources/create_offer_data_source.dart';

class CreateOfferRepository {
  final CreateOfferRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const CreateOfferRepository(this._remoteDataSource, this._networkInfo);

  Future<Either<Failure, void>> createOffer(FormData formData) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.createOffer(formData);
        BaseResponseModel<dynamic> base =
            BaseResponseModel<dynamic>.fromJson(response.data!, (json) => json);
        if (base.status == 200 ||
            base.statusCode == 200 ||
            base.statusCode == 201 ||
            base.success == true) {
          return const Right(null);
        }
        return Left(ErrorHandler.handle(DioException(
          type: DioExceptionType.badResponse,
          response: response,
          requestOptions: RequestOptions(),
        )));
      } catch (error) {
        return Left(ErrorHandler.handle(error));
      }
    }
    return const Left(NetworkFailure());
  }
}
