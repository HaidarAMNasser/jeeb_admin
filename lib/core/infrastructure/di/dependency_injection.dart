import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jeeb_admin/features/product/create_product/data/data_sources/create_product_data_source.dart';
import 'package:jeeb_admin/features/product/create_product/data/repositories/create_product_repository.dart';
import 'package:jeeb_admin/features/product/delete_product/data/data_sources/delete_product_data_source.dart';
import 'package:jeeb_admin/features/product/delete_product/data/repositories/delete_product_repository.dart';
import 'package:jeeb_admin/features/product/update_product/data/data_sources/update_product_data_source.dart';
import 'package:jeeb_admin/features/product/update_product/data/repositories/update_product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/network_info.dart';
import '../../presentation/routes/navigation_service.dart';
import '../services/storage_service.dart';
import '../services/dio_factory.dart';
import '../api/api_service.dart';
import '../../config/app_config.dart';
import '../../../features/product/list_product/data/data_sources/list_product_data_source.dart';
import '../../../features/product/list_product/data/repositories/list_product_repository.dart';
import '../../../features/product/product_details/data/data_sources/product_details_data_source.dart';
import '../../../features/product/product_details/data/repositories/product_details_repository.dart';
import '../../../features/category/list_category/data/data_sources/list_category_data_source.dart';
import '../../../features/category/list_category/data/repositories/list_category_repository.dart';

final sl = GetIt.instance;

/// Initialize Dependency Injection
Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  //! Core Services
  sl.registerLazySingleton<StorageService>(() => StorageServiceImpl(sl()));
  sl.registerLazySingleton(() => NavigationService());

  //! Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Dio Factory
  sl.registerLazySingleton<DioFactory>(
    () => DioFactory(sl<StorageService>(), sl<NavigationService>()),
  );

  //! Dio Instance - Initialize asynchronously using registered factory
  final dioFactory = sl<DioFactory>();
  final dio = await dioFactory.getDio();
  sl.registerLazySingleton<Dio>(() => dio);

  //! API Service Client
  sl.registerLazySingleton<AppApiServiceClient>(
    () => AppApiServiceClient(dio: sl<Dio>(), baseUrlApi: AppConfig.baseUrl),
  );

  //! Category List Dependencies
  sl.registerFactory<ListCategoryRemoteDataSource>(
    () => ListCategoryRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ListCategoryRepository(sl(), sl()));

  //! Product List Dependencies
  sl.registerFactory<ListProductRemoteDataSource>(
    () => ListProductRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ListProductRepository(sl(), sl()));

  //! Product Details Dependencies
  sl.registerFactory<ProductDetailsRemoteDataSource>(
    () => ProductDetailsRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ProductDetailsRepository(sl(), sl()));

  //! Product Create/Update/Delete Dependencies
  sl.registerFactory<CreateProductRemoteDataSource>(
    () => CreateProductRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory<UpdateProductRemoteDataSource>(
    () => UpdateProductRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory<DeleteProductRemoteDataSource>(
    () => DeleteProductRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => CreateProductRepository(sl(), sl()));
  sl.registerFactory(() => UpdateProductRepository(sl(), sl()));
  sl.registerFactory(() => DeleteProductRepository(sl(), sl()));

  // Register your dependencies here
  // Example:
  // sl.registerFactory(() => LoginUseCase(sl()));
  // sl.registerFactory(() => AuthRepository(sl()));
}
