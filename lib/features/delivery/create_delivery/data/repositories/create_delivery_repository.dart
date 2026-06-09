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
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    int? countryId,
    int? cityId,
    String? address,
    String? birthday,
    String? notificationChannel,
    int? officeOwnerId,
    String? imagePath,
    double? latitude,
    double? longitude,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.createDeliveryMan(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          phone: phone,
          countryId: countryId,
          cityId: cityId,
          address: address,
          birthday: birthday,
          notificationChannel: notificationChannel,
          officeOwnerId: officeOwnerId,
          imagePath: imagePath,
          latitude: latitude,
          longitude: longitude,
        );

        BaseResponseModel<dynamic> baseResponseModel =
            BaseResponseModel<dynamic>.fromJson(
          response.data!,
          (json) => json,
        );

        if (baseResponseModel.status == 201 ||
            baseResponseModel.success == true ||
            baseResponseModel.statusCode == 201) {
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
