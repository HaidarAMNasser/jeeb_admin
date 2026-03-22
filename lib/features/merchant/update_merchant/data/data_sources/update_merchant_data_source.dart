import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class UpdateMerchantRemoteDataSource {
  Future<Response> updateMerchant({
    required String id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    int? countryId,
    int? cityId,
    String? address,
    bool? hidePhoneNumber,
    String? imagePath,
  });
}

class UpdateMerchantRemoteDataSourceImpl
    implements UpdateMerchantRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  UpdateMerchantRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> updateMerchant({
    required String id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    int? countryId,
    int? cityId,
    String? address,
    bool? hidePhoneNumber,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      if (firstName != null && firstName.isNotEmpty) 'firstName': firstName,
      if (lastName != null && lastName.isNotEmpty) 'lastName': lastName,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (countryId != null) 'countryId': countryId,
      if (cityId != null) 'cityId': cityId,
      if (address != null && address.isNotEmpty) 'address': address,
      if (hidePhoneNumber != null) 'hidePhoneNumber': hidePhoneNumber,
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(imagePath),
    });

    return _appApiServiceClient.updateMerchant(id, formData);
  }
}
