import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/notification/update_device_token/data/data_sources/update_device_token_remote_data_source.dart';

class UpdateDeviceTokenRepository {
  final UpdateDeviceTokenRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  const UpdateDeviceTokenRepository(this._remote, this._networkInfo);

  Future<Either<Failure, void>> updateDeviceToken({
    required String token,
    required String platform,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remote.updateDeviceToken(
        token: token,
        platform: platform,
      );

      final baseResponse = BaseResponseModel<dynamic>.fromJson(
        response.data!,
        (json) => json,
      );

      if (baseResponse.status == 200 ||
          baseResponse.success == true ||
          baseResponse.statusCode == 200) {
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
}
