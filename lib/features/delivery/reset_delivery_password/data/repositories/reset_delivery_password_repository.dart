import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/delivery/reset_delivery_password/data/data_sources/reset_delivery_password_data_source.dart';

class ResetDeliveryPasswordRepository {
  final ResetDeliveryPasswordRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const ResetDeliveryPasswordRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, void>> resetDeliveryPassword({
    required String id,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.resetDeliveryPassword(
          id: id,
          password: password,
        );

        final baseResponseModel = BaseResponseModel<dynamic>.fromJson(
          response.data!,
          (json) => json,
        );

        if (baseResponseModel.status == 200 ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 200) {
          return const Right(null);
        }

        return Left(
          ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: RequestOptions(),
            ),
          ),
        );
      } catch (error) {
        return Left(ErrorHandler.handle(error));
      }
    }
    return const Left(NetworkFailure());
  }
}
