import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/common/errors/failure.dart';
import '../../../../../core/common/models/api_response_model.dart';
import '../../../../../core/common/utils/error_handler.dart';
import '../../../../../core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/token_entity.dart';
import 'package:jeeb_admin/features/auth/login/data/models/token_model.dart';
import '../data_sources/register_remote_data_source.dart';

class RegisterRepository {
  final RegisterRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const RegisterRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  /// Returns [TokenEntity] when the register API returns access_token and user (store in SharedPreferences).
  /// Returns null when success but no token (e.g. old API only returns userId). Verify will rely on stored token.
  Future<Either<Failure, TokenEntity?>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String role,
    int? countryId,
    int? cityId,
    double? latitude,
    double? longitude,
    required String notificationChannel,
    String? address,
    String? restaurantName,
    String? merchantType,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
        role: role,
        countryId: countryId,
        cityId: cityId,
        latitude: latitude,
        longitude: longitude,
        notificationChannel: notificationChannel,
        address: address,
        restaurantName: restaurantName,
        merchantType: merchantType,
      );

      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json is Map<String, dynamic> ? json : {},
      );

      if (apiResponse.isSuccess) {
        final data = apiResponse.data ?? {};
        final accessToken = data['access_token'];
        final user = data['user'];
        if (accessToken != null &&
            accessToken.toString().isNotEmpty &&
            user is Map<String, dynamic>) {
          try {
            final tokenModel = TokenModel.fromJson(data);
            return Right(tokenModel.toDomain());
          } catch (_) {
            // Fallback: success with no token (e.g. userId only)
            return const Right(null);
          }
        }
        // Success but no token in response (e.g. only userId)
        return const Right(null);
      }

      return Left(ErrorHandler.handle(
        DioException(
          type: DioExceptionType.badResponse,
          response: response,
          requestOptions: response.requestOptions,
        ),
      ));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}

