import 'package:dio/dio.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';

abstract class AddCategoryRemoteDataSource {
  Future<Response> addCategory({required String name, String? imagePath});
}

class AddCategoryRemoteDataSourceImpl
    implements AddCategoryRemoteDataSource {
  final AppApiServiceClient _appApiServiceClient;

  AddCategoryRemoteDataSourceImpl(this._appApiServiceClient);

  @override
  Future<Response> addCategory({required String name, String? imagePath}) async {
    final formDataMap = <String, dynamic>{'name': name};
    if (imagePath != null && imagePath.isNotEmpty) {
      formDataMap['image'] = await MultipartFile.fromFile(imagePath);
    }
    final formData = FormData.fromMap(formDataMap);
    return _appApiServiceClient.addCategory(formData);
  }
}

