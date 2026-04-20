import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/common/errors/failure.dart';
import '../../../../../core/common/models/api_response_model.dart';
import '../../../../../core/common/utils/error_handler.dart';
import '../../../../../core/infrastructure/network/network_info.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/token_entity.dart';
import 'package:jeeb_admin/features/auth/login/data/models/token_model.dart';
import '../data_sources/register_remote_data_source.dart';

/// Outcome of [RegisterRepository.register]: optional session token and/or API `userId`.
class RegisterResult {
  final TokenEntity? token;
  final int? userId;

  const RegisterResult({this.token, this.userId});

  int get resolvedUserId => token?.user.id ?? userId ?? 0;
}

class RegisterRepository {
  final RegisterRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const RegisterRepository(
    this._remoteDataSource,
    this._networkInfo,
  );

  int? _parseUserId(Map<String, dynamic> data) {
    final v = data['userId'];
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  /// Returns [RegisterResult] with [TokenEntity] when the API returns access_token and user.
  /// OTP-only responses (201 + userId) return token null and [RegisterResult.userId] set.
  Future<Either<Failure, RegisterResult>> register({
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
        final parsedUserId = _parseUserId(data);
        final accessToken = data['access_token'];
        final user = data['user'];
        if (accessToken != null &&
            accessToken.toString().isNotEmpty &&
            user is Map<String, dynamic>) {
          try {
            final tokenModel = TokenModel.fromJson(data);
            final token = tokenModel.toDomain();
            return Right(
              RegisterResult(
                token: token,
                userId: parsedUserId ?? token.user.id,
              ),
            );
          } catch (_) {
            return Right(RegisterResult(token: null, userId: parsedUserId));
          }
        }
        return Right(RegisterResult(token: null, userId: parsedUserId));
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
