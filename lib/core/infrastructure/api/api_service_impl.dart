part of 'api_service.dart';

class _AppApiServiceClientImpl implements AppApiServiceClient {
  _AppApiServiceClientImpl({required this.dio, required this.baseUrlApi});

  final Dio dio;
  final String baseUrlApi;

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  @override
  Future<Response> loginWithPhone(
    String phone,
    String password,
    bool directLogin,
    int phoneCodeId,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {
      'phone': phone,
      'password': password,
      'is_mobile_pass': directLogin,
      'phone_code_id': phoneCodeId,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'apiAdmin/Auth_general/login',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> loginWithEmail(
    String email,
    String password,
    bool directLogin,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {
      'email': email,
      'password': password,
      'is_mobile_pass': directLogin,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'apiAdmin/Auth_general/login',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String phone,
    String role,
    int countryId,
    int cityId,
    String notificationChannel,
    String? address,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'countryId': countryId,
      'cityId': cityId,
      'notificationChannel': notificationChannel,
      if (address != null) 'address': address,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'auth/register',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> verify(
    String email,
    String otp,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {
      'email': email,
      'otp': otp,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'auth/verify',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> resendOtp(
    String email,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {
      'email': email,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'auth/resend-otp',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> forgotPassword(
    String email,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {
      'email': email,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'auth/forgot-password',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> resetPassword(
    String email,
    String otp,
    String password,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {
      'email': email,
      'otp': otp,
      'password': password,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'auth/reset-password',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getProfile() async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'auth/profile',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> updateProfile(
    String? firstName,
    String? lastName,
    String? phone,
    int? countryId,
    int? cityId,
    String? address,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (phone != null) data['phone'] = phone;
    if (countryId != null) data['countryId'] = countryId;
    if (cityId != null) data['cityId'] = cityId;
    if (address != null) data['address'] = address;

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'PATCH', headers: headers, extra: extra)
            .compose(
              dio.options,
              'auth/profile',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getCategories() async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'apiAdmin/Category/all',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> addCategory(String name) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {'name': name};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'apiAdmin/Category/create',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getProducts(
    int? page,
    int? limit,
    String? search,
    String? categoryId,
    String? restaurantId,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    if (search != null && search.isNotEmpty) queryParameters['search'] = search;
    if (categoryId != null && categoryId.isNotEmpty) queryParameters['categoryId'] = categoryId;
    if (restaurantId != null && restaurantId.isNotEmpty) queryParameters['restaurantId'] = restaurantId;
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'products',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getProductDetails(String id) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'products/$id',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> createProduct(FormData formData) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{
      'Content-Type': 'multipart/form-data',
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'products',
              queryParameters: queryParameters,
              data: formData,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> updateProduct(String id, FormData formData) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{
      'Content-Type': 'multipart/form-data',
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'PATCH', headers: headers, extra: extra)
            .compose(
              dio.options,
              'products/$id',
              queryParameters: queryParameters,
              data: formData,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> deleteProduct(String id) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'DELETE', headers: headers, extra: extra)
            .compose(
              dio.options,
              'products/$id',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> deleteProductImage(String imageId) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'DELETE', headers: headers, extra: extra)
            .compose(
              dio.options,
              'products/images/$imageId',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getCountries(
    int? page,
    int? limit,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'countries',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getCities(
    int countryId,
    int? page,
    int? limit,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'countryId': countryId,
    };
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'cities',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getMerchants({
    int? page,
    int? limit,
    String? search,
  }) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    if (search != null && search.isNotEmpty) queryParameters['search'] = search;
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'merchants',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getMerchantDetails(String id) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'merchants/$id',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getMerchantReviews({
    required String merchantId,
    int? page,
    int? limit,
  }) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'merchants/$merchantId/reviews',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getDeliveryMen({
    int? page,
    int? limit,
    String? search,
  }) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    if (search != null && search.isNotEmpty) queryParameters['search'] = search;
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'delivery-men',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> getDeliveryManDetails(String id) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'delivery-men/$id',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> createDeliveryMan(
    String name,
    String phone,
    String email,
    String? vehicleType,
    String? status,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
      if (vehicleType != null && vehicleType.isNotEmpty) 'vehicleType': vehicleType,
      if (status != null && status.isNotEmpty) 'status': status,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'delivery-men',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> updateDeliveryMan(
    String id,
    String? name,
    String? phone,
    String? email,
    String? vehicleType,
    String? status,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (email != null) data['email'] = email;
    if (vehicleType != null) data['vehicleType'] = vehicleType;
    if (status != null) data['status'] = status;

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'PATCH', headers: headers, extra: extra)
            .compose(
              dio.options,
              'delivery-men/$id',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> deleteDeliveryMan(String id) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'DELETE', headers: headers, extra: extra)
            .compose(
              dio.options,
              'delivery-men/$id',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }
}

