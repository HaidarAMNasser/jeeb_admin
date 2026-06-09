import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/notification/send_to_customers/data/data_sources/send_to_customers_data_source.dart';

class SendToCustomersRepository {
  final SendToCustomersRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const SendToCustomersRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, void>> sendNotification({
    required String title,
    required String body,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.sendNotification(
          title: title,
          body: body,
        );

        final baseResponseModel = BaseResponseModel<dynamic>.fromJson(
          response.data!,
          (json) => json,
        );

        if (baseResponseModel.success == true ||
            baseResponseModel.status == 200 ||
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
    } else {
      return const Left(NetworkFailure());
    }
  }
}
