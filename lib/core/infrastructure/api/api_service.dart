import 'package:dio/dio.dart';

part 'api_service_impl.dart';

/// API Service Client Interface
/// Defines all API endpoints for the application
abstract class AppApiServiceClient {
  factory AppApiServiceClient({required Dio dio, required String baseUrlApi}) =
      _AppApiServiceClientImpl;

  // Authentication endpoints
  @POST("auth/login")
  Future<Response> loginWithPhone(
    @Field('phone') String phone,
    @Field('password') String password,
    @Field('is_mobile_pass') bool directLogin,
    @Field('phone_code_id') int phoneCodeId,
  );

  @POST("auth/login")
  Future<Response> loginWithEmail(
    @Field('email') String email,
    @Field('password') String password,
    @Field('is_mobile_pass') bool directLogin,
  );

  @POST("auth/register")
  Future<Response> register(
    @Field('firstName') String firstName,
    @Field('lastName') String lastName,
    @Field('email') String email,
    @Field('password') String password,
    @Field('phone') String phone,
    @Field('role') String role,
    @Field('countryId') int? countryId,
    @Field('cityId') int? cityId,
    @Field('latitude') double? latitude,
    @Field('longitude') double? longitude,
    @Field('notificationChannel') String notificationChannel,
    @Field('address') String? address,
    @Field('restaurantName') String? restaurantName,
    /// `RESTAURANT` or `STORE` when [role] is `MERCHANT`.
    @Field('type') String? merchantType,
  );

  @POST("auth/verify")
  Future<Response> verify(
    @Field('email') String email,
    @Field('otp') String otp,
  );

  @POST("auth/resend-otp")
  Future<Response> resendOtp(@Field('email') String email);

  @POST("auth/forgot-password")
  Future<Response> forgotPassword(@Field('email') String email);

  @POST("auth/reset-password")
  Future<Response> resetPassword(
    @Field('email') String email,
    @Field('otp') String otp,
    @Field('password') String password,
  );

  @GET("auth/profile")
  Future<Response> getProfile();

  @PATCH("auth/profile")
  Future<Response> updateProfile({
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
    /// Merchant: `RESTAURANT` or `STORE` (API field `type`).
    String? type,
    String? password,
    String? newPassword,
    String? confirmedPassword,
    MultipartFile? image,
  });

  @POST("auth/logout")
  Future<Response> logout();

  /// Registers or updates the device FCM token for the current user.
  @POST("auth/firebase-token")
  Future<Response> updateDeviceToken({
    @Field('token') required String token,
    @Field('platform') required String platform,
  });

  // Category endpoints
  @GET("categories")
  Future<Response> getCategories(
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
  );

  @POST("categories")
  Future<Response> addCategory(FormData formData);

  @PATCH("categories/{id}")
  Future<Response> updateCategory(@Path('id') String id, FormData formData);

  @DELETE("categories/{id}")
  Future<Response> deleteCategory(@Path('id') String id);

  // Area endpoints
  @GET("areas")
  Future<Response> getAreas(
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
  );

  @GET("areas/{id}")
  Future<Response> getAreaDetails(@Path('id') String id);

  @POST("areas")
  Future<Response> createArea(FormData formData);

  @PATCH("areas/{id}")
  Future<Response> updateArea(@Path('id') String id, FormData formData);

  @DELETE("areas/{id}")
  Future<Response> deleteArea(@Path('id') String id);

  // Product endpoints
  @GET("products")
  Future<Response> getProducts(
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('categoryId') String? categoryId,
    @Query('restaurantId') String? restaurantId,
  );

  @GET("products/{id}")
  Future<Response> getProductDetails(@Path('id') String id);

  @POST("products")
  Future<Response> createProduct(FormData formData);

  @PATCH("products/{id}")
  Future<Response> updateProduct(@Path('id') String id, FormData formData);

  /// Confirm product and set final price so it becomes visible to clients.
  @POST("products/{id}/confirm")
  Future<Response> confirmProduct(
    @Path('id') String id,
    @Field('newPrice') double newPrice,
  );

  @DELETE("products/{id}")
  Future<Response> deleteProduct(@Path('id') String id);

  @DELETE("products/images/{imageId}")
  Future<Response> deleteProductImage(@Path('imageId') String imageId);

  // Countries & Cities endpoints
  @GET("countries")
  Future<Response> getCountries(
    @Query('page') int? page,
    @Query('limit') int? limit,
  );

  @GET("cities")
  Future<Response> getCities(
    @Query('countryId') int countryId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  );

  // Merchant endpoints
  @GET("users/merchants")
  Future<Response> getMerchants({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('countryId') int? countryId,
    @Query('cityId') int? cityId,
    @Query('isActive') bool? isActive,
  });

  @GET("users/merchants/{id}")
  Future<Response> getMerchantDetails(@Path('id') String id);

  @POST("users/merchants")
  Future<Response> createMerchant(FormData formData);

  @PATCH("users/merchants/{id}")
  Future<Response> updateMerchant(@Path('id') String id, FormData formData);

  @DELETE("users/merchants/{id}")
  Future<Response> deleteMerchant(@Path('id') String id);

  // Merchant Review endpoints
  @GET("merchants/{merchantId}/reviews")
  Future<Response> getMerchantReviews({
    @Path('merchantId') required String merchantId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  // Delivery endpoints
  @GET("users/deliveries")
  Future<Response> getDeliveryMen({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('isOnline') bool? isOnline,
    @Query('officeOwnerId') int? officeOwnerId,
    @Query('countryId') int? countryId,
    @Query('cityId') int? cityId,
  });

  @GET("users/deliveries/{id}")
  Future<Response> getDeliveryManDetails(@Path('id') String id);

  @POST("users/deliveries")
  Future<Response> createDeliveryMan(FormData formData);

  @PATCH("users/deliveries/{id}")
  Future<Response> updateDeliveryMan(@Path('id') String id, FormData formData);

  @DELETE("users/deliveries/{id}")
  Future<Response> deleteDeliveryMan(@Path('id') String id);

  @POST("users/deliveries/{id}/confirm")
  Future<Response> confirmDeliveryMan(@Path('id') String id);

  // Order endpoints
  @GET("orders")
  Future<Response> getOrders({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('status') String? status,
    @Header('merchantId') String? merchantId,
  }); // status: PENDING, CONFIRMED, etc. (see Orders API)

  Future<Response> confirmOrder(String id, Map<String, dynamic>? body);

  /// Merchant: set status to preparing (`POST orders/{id}/preparing`).
  Future<Response> setOrderPreparing(String id);

  /// Merchant: set status to ready for pickup (`POST orders/{id}/ready-for-pickup`).
  Future<Response> setOrderReadyForPickup(String id);

  @GET("orders/{id}")
  Future<Response> getOrderDetails(@Path('id') String id);

  @POST("orders/{id}/complete")
  Future<Response> completeOrder(
    @Path('id') String id, {
    Map<String, dynamic>? body,
  });

  @POST("orders/{id}/cancel")
  Future<Response> cancelOrder(@Path('id') String id);

  // Offer endpoints (merchant & admin)
  @GET("offers")
  Future<Response> getOffers({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('merchantId') String? merchantId,
  });

  @GET("offers/{id}")
  Future<Response> getOfferDetails(@Path('id') String id);

  @POST("offers")
  Future<Response> createOffer(Map<String, dynamic> body);

  @POST("offers/{id}")
  Future<Response> updateOffer(
    @Path('id') String id,
    Map<String, dynamic> body,
  );

  @DELETE("offers/{id}")
  Future<Response> deleteOffer(@Path('id') String id);

  // Settings endpoints (admin only for PATCH)
  @GET("settings")
  Future<Response> getSettings();

  @PATCH("settings")
  Future<Response> patchSettings(List<Map<String, dynamic>> body);

  // Notification endpoints
  @POST("notifications/send-to-customers")
  Future<Response> sendNotificationToCustomers(Map<String, dynamic> body);
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

class Header {
  final String name;
  const Header(this.name);
}
