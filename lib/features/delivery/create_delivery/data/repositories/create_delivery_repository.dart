import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/common/errors/failure.dart';
import 'package:jeeb_admin/core/common/models/base_response_model.dart';
import 'package:jeeb_admin/core/common/utils/error_handler.dart';
import 'package:jeeb_admin/core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/data/data_sources/create_delivery_data_source.dart';

class CreateDeliveryRepository {
  final CreateDeliveryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const CreateDeliveryRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<Either<Failure, void>> createDeliveryMan({
    required String name,
    required String phone,
    required String email,
    String? vehicleType,
    String? status,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.createDeliveryMan(
          name: name,
          phone: phone,
          email: email,
          vehicleType: vehicleType,
          status: status,
        );

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
