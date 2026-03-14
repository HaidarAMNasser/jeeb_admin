import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class UpdateCategoryRemoteDataSource {
  Future<Response> updateCategory({
    required int id,
    required String name,
    String? imagePath,
  });
}

class UpdateCategoryRemoteDataSourceImpl
    implements UpdateCategoryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  UpdateCategoryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> updateCategory({
    required int id,
    required String name,
    String? imagePath,
  }) async {
    final formDataMap = <String, dynamic>{'name': name};
    if (imagePath != null && imagePath.isNotEmpty) {
      formDataMap['image'] = await MultipartFile.fromFile(imagePath);
    }
    final formData = FormData.fromMap(formDataMap);
    return _appApiServiceClient.updateCategory(id.toString(), formData);
  }
}
