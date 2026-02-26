import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/delivery/delete_delivery/data/data_sources/delete_delivery_data_source.dart';

class DeleteDeliveryRepository {
  final DeleteDeliveryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const DeleteDeliveryRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, void>> deleteDeliveryMan(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.deleteDeliveryMan(id);

        BaseResponseModel<dynamic> baseResponseModel =
            BaseResponseModel<dynamic>.fromJson(
          response.data!,
          (json) => json,
        );

        if (baseResponseModel.status == 200 ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 200) {
          return const Right(null);
        } else {
          return Left(ErrorHandler.handle(DioException(
            type: DioExceptionType.badResponse,
            response: response,
            requestOptions: RequestOptions(),
          )));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
