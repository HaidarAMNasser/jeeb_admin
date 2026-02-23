import 'package:dio/dio.dart';

part 'api_service_impl.dart';

/// API Service Client Interface
/// Defines all API endpoints for the application
abstract class AppApiServiceClient {
  factory AppApiServiceClient({required Dio dio, required String baseUrlApi}) =
      _AppApiServiceClientImpl;

  // Authentication endpoints
  @POST("apiAdmin/Auth_general/login")
  Future<Response> loginWithPhone(
    @Field('phone') String phone,
    @Field('password') String password,
    @Field('is_mobile_pass') bool directLogin,
    @Field('phone_code_id') int phoneCodeId,
  );

  @POST("apiAdmin/Auth_general/login")
  Future<Response> loginWithEmail(
    @Field('email') String email,
    @Field('password') String password,
    @Field('is_mobile_pass') bool directLogin,
  );

  // Category endpoints
  @GET("apiAdmin/Category/all")
  Future<Response> getCategories();

  @POST("apiAdmin/Category/create")
  Future<Response> addCategory(@Field('name') String name);

  // Product endpoints
  @GET("apiAdmin/Product/all")
  Future<Response> getProducts();

  @GET("apiAdmin/Product/{id}")
  Future<Response> getProductDetails(@Path('id') String id);

  @POST("apiAdmin/Product/create")
  Future<Response> createProduct(@Field('name') String name, @Field('description') String? description, @Field('price') double price, @Field('category_id') String categoryId, @Field('quantity') int? quantity, @Field('images') List<String> images);

  @PUT("apiAdmin/Product/{id}")
  Future<Response> updateProduct(@Path('id') String id, @Field('name') String name, @Field('description') String? description, @Field('price') double price, @Field('category_id') String categoryId, @Field('quantity') int? quantity, @Field('images') List<String> images);

  @DELETE("apiAdmin/Product/{id}")
  Future<Response> deleteProduct(@Path('id') String id);
}

// Annotations for API methods (simplified versions)
class POST {
  final String path;
  const POST(this.path);
}

class GET {
  final String path;
  const GET(this.path);
}

class PUT {
  final String path;
  const PUT(this.path);
}

class DELETE {
  final String path;
  const DELETE(this.path);
}

class PATCH {
  final String path;
  const PATCH(this.path);
}

class Field {
  final String name;
  const Field(this.name);
}

class Query {
  final String name;
  const Query(this.name);
}

class Queries {
  const Queries();
}

class Path {
  final String name;
  const Path(this.name);
}

