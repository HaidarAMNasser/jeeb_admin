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
  Future<Response> getProducts() async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'GET', headers: headers, extra: extra)
            .compose(
              dio.options,
              'apiAdmin/Product/all',
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
              'apiAdmin/Product/$id',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> createProduct(
    String name,
    String? description,
    double price,
    String categoryId,
    int? quantity,
    List<String> images,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'quantity': quantity,
      'images': images,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'POST', headers: headers, extra: extra)
            .compose(
              dio.options,
              'apiAdmin/Product/create',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }

  @override
  Future<Response> updateProduct(
    String id,
    String name,
    String? description,
    double price,
    String categoryId,
    int? quantity,
    List<String> images,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = {
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'quantity': quantity,
      'images': images,
    };

    final result = await dio.fetch<Map<String, dynamic>>(
      _setStreamType(
        Options(method: 'PUT', headers: headers, extra: extra)
            .compose(
              dio.options,
              'apiAdmin/Product/$id',
              queryParameters: queryParameters,
              data: data,
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
              'apiAdmin/Product/$id',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: baseUrlApi),
      ),
    );

    return result;
  }
}

