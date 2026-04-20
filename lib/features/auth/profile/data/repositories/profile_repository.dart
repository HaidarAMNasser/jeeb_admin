import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/common/errors/failure.dart';
import '../../../../../core/common/utils/error_handler.dart';
import '../../../../../core/infrastructure/network/network_info.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../../../login/data/models/user_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const ProfileRepository(this._remoteDataSource, this._networkInfo);

  Future<Either<Failure, UserEntity>> getProfile() async {
    if (!await _networkInfo.isConnected) {
      return Right(_fakeUser());
    }
    try {
      final response = await _remoteDataSource.getProfile();
      final raw = response.data as Map<String, dynamic>?;
      if (raw == null) {
        return Left(
          ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: response.requestOptions,
            ),
          ),
        );
      }

      final statusCode = raw['statusCode'] as int? ?? 200;
      if (statusCode < 200 || statusCode >= 300) {
        return Left(
          ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: response.requestOptions,
            ),
          ),
        );
      }

      final userEntity = _parseUserFromResponseData(raw['data']);
      if (userEntity != null) return Right(userEntity);
      return Right(_fakeUser());
    } catch (error) {
      return Right(_fakeUser());
    }
  }

  /// Parses response data that may be the user object directly or nested under 'user'.
  static UserEntity? _parseUserFromResponseData(dynamic data) {
    if (data == null) return null;
    Map<String, dynamic> userJson;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
        userJson = data['user'] as Map<String, dynamic>;
      } else {
        userJson = data;
      }
    } else {
      return null;
    }
    try {
      return UserModel.fromJson(userJson).toDomain();
    } catch (_) {
      return null;
    }
  }

  static UserEntity _fakeUser({
    double? latitude,
    double? longitude,
    bool? isActive,
    bool? isOpen,
  }) {
    final now = DateTime.now();
    return UserEntity(
      id: 1,
      firstName: 'Dev',
      lastName: 'User',
      email: 'dev@test.com',
      phone: '',
      role: UserRole.merchant,
      notificationChannel: NotificationChannel.email,
      countryId: 0,
      cityId: 0,
      createdAt: now,
      updatedAt: now,
      address: null,
      isActive: isActive ?? true,
      isOpen: isOpen ?? true,
      isVerified: true,
      currentLat: latitude,
      currentLng: longitude,
      restaurantName: null,
      merchantType: null,
    );
  }

  Future<Either<Failure, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    int? countryId,
    int? cityId,
    String? address,
    double? latitude,
    double? longitude,
    bool? isActive,
    bool? isOpen,
    String? restaurantName,
    String? merchantType,
    String? password,
    String? newPassword,
    String? confirmedPassword,
    dynamic imageFile,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Right(
        _fakeUser(
          latitude: latitude,
          longitude: longitude,
          isActive: isActive,
          isOpen: isOpen,
        ),
      );
    }
    try {
      // Pass through File or XFile; data source sends image as multipart file (not string).
      final response = await _remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        countryId: countryId,
        cityId: cityId,
        address: address,
        latitude: latitude,
        longitude: longitude,
        isActive: isActive,
        isOpen: isOpen,
        restaurantName: restaurantName,
        merchantType: merchantType,
        password: password,
        newPassword: newPassword,
        confirmedPassword: confirmedPassword,
        imageFile: imageFile,
      );

      final raw = response.data as Map<String, dynamic>?;
      if (raw == null || (raw['statusCode'] as int? ?? 0) >= 300) {
        return Left(
          ErrorHandler.handle(
            DioException(
              type: DioExceptionType.badResponse,
              response: response,
              requestOptions: response.requestOptions,
            ),
          ),
        );
      }
      final userEntity = _parseUserFromResponseData(raw['data']);
      if (userEntity != null) {
        return Right(userEntity);
      }
      final code = raw['statusCode'] as int? ?? 0;
      if (code >= 200 && code < 300) {
        return getProfile();
      }
      return Left(
        ErrorHandler.handle(
          DioException(
            type: DioExceptionType.badResponse,
            response: response,
            requestOptions: response.requestOptions,
          ),
        ),
      );
    } catch (error) {
      return Right(
        _fakeUser(
          latitude: latitude,
          longitude: longitude,
          isActive: isActive,
          isOpen: isOpen,
        ),
      );
    }
  }
}
