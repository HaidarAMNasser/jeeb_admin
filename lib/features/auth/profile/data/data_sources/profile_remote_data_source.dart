import 'dart:io' show File;

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class ProfileRemoteDataSource {
  Future<Response> getProfile();

  Future<Response> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    int? countryId,
    int? cityId,
    String? address,
    double? latitude,
    double? longitude,
    bool? isOpen,
    /// Pass [File] or [XFile]; image is always sent as multipart file (not string).
    dynamic imageFile,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  ProfileRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> getProfile() {
    return _appApiServiceClient.getProfile();
  }

  @override
  Future<Response> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    int? countryId,
    int? cityId,
    String? address,
    double? latitude,
    double? longitude,
    bool? isOpen,
    dynamic imageFile,
  }) async {
    MultipartFile? image;
    if (imageFile != null) {
      if (imageFile is File) {
        final path = imageFile.path;
        final name = path.contains(RegExp(r'[/\\]'))
            ? path.split(RegExp(r'[/\\]')).last
            : path;
        image = await MultipartFile.fromFile(path, filename: name);
      } else if (imageFile is XFile) {
        final bytes = await imageFile.readAsBytes();
        final name = imageFile.name.isNotEmpty
            ? imageFile.name
            : 'profile_pic.jpg';
        image = MultipartFile.fromBytes(bytes, filename: name);
      }
    }
    return _appApiServiceClient.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      countryId: countryId,
      cityId: cityId,
      address: address,
      latitude: latitude,
      longitude: longitude,
      isOpen: isOpen,
      image: image,
    );
  }
}
