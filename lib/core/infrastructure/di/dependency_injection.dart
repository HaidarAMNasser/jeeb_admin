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
import '../realtime/order_status_rtdb_service.dart';
import '../services/dio_factory.dart';
import '../api/api_service.dart';
import '../../config/app_config.dart';
import '../../../features/product/list_product/data/data_sources/list_product_data_source.dart';
import '../../../features/product/list_product/data/repositories/list_product_repository.dart';
import '../../../features/product/product_details/data/data_sources/product_details_data_source.dart';
import '../../../features/product/product_details/data/repositories/product_details_repository.dart';
import '../../../features/category/list_category/data/data_sources/list_category_data_source.dart';
import '../../../features/category/list_category/data/repositories/list_category_repository.dart';
import '../../../features/category/list_category/presentation/bloc/list_category_bloc.dart';
import '../../../features/category/add_category/data/data_sources/add_category_data_source.dart';
import '../../../features/category/add_category/data/repositories/add_category_repository.dart';
import '../../../features/category/add_category/presentation/bloc/add_category_bloc.dart';
import '../../../features/category/update_category/data/data_sources/update_category_data_source.dart';
import '../../../features/category/update_category/data/repositories/update_category_repository.dart';
import '../../../features/category/update_category/presentation/bloc/update_category_bloc.dart';
import '../../../features/category/delete_category/data/data_sources/delete_category_data_source.dart';
import '../../../features/category/delete_category/data/repositories/delete_category_repository.dart';
import '../../../features/category/delete_category/presentation/bloc/delete_category_bloc.dart';
import '../../../features/areas/list_areas/data/data_sources/list_areas_data_source.dart';
import '../../../features/areas/list_areas/data/repositories/list_areas_repository.dart';
import '../../../features/areas/list_areas/presentation/bloc/list_areas_bloc.dart';
import '../../../features/areas/create_area/data/data_sources/create_area_data_source.dart';
import '../../../features/areas/create_area/data/repositories/create_area_repository.dart';
import '../../../features/areas/create_area/presentation/bloc/create_area_bloc.dart';
import '../../../features/areas/update_area/data/data_sources/update_area_data_source.dart';
import '../../../features/areas/update_area/data/repositories/update_area_repository.dart';
import '../../../features/areas/update_area/presentation/bloc/update_area_bloc.dart';
import '../../../features/areas/delete_area/data/data_sources/delete_area_data_source.dart';
import '../../../features/areas/delete_area/data/repositories/delete_area_repository.dart';
import '../../../features/areas/delete_area/presentation/bloc/delete_area_bloc.dart';
import '../../../features/areas/area_details/data/data_sources/area_details_data_source.dart';
import '../../../features/areas/area_details/data/repositories/area_details_repository.dart';
import '../../../features/areas/area_details/presentation/bloc/area_details_bloc.dart';
import '../../../features/auth/login/data/data_sources/login_remote_data_source.dart';
import '../../../features/auth/login/data/repositories/login_repository.dart';
import '../../../features/auth/login/presentation/bloc/login_bloc.dart';
import '../../../features/auth/register/data/data_sources/register_remote_data_source.dart';
import '../../../features/auth/register/data/repositories/register_repository.dart';
import '../../../features/auth/register/presentation/bloc/register_bloc.dart';
import '../../../features/auth/verify/data/data_sources/verify_remote_data_source.dart';
import '../../../features/auth/verify/data/repositories/verify_repository.dart';
import '../../../features/auth/verify/presentation/bloc/verify_bloc.dart';
import '../../../features/auth/forgot_password/data/data_sources/forgot_password_remote_data_source.dart';
import '../../../features/auth/forgot_password/data/repositories/forgot_password_repository.dart';
import '../../../features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import '../../../features/auth/reset_password/data/data_sources/reset_password_remote_data_source.dart';
import '../../../features/auth/reset_password/data/repositories/reset_password_repository.dart';
import '../../../features/auth/reset_password/presentation/bloc/reset_password_bloc.dart';
import '../../../features/auth/profile/data/data_sources/profile_remote_data_source.dart';
import '../../../features/auth/profile/data/repositories/profile_repository.dart';
import '../../../features/auth/profile/presentation/bloc/profiel/profile_bloc.dart';
import '../../../features/auth/profile/presentation/bloc/change_password/change_password_bloc.dart';
import '../../../features/auth/logout/data/data_sources/logout_remote_data_source.dart';
import '../../../features/auth/logout/data/repositories/logout_repository.dart';
import '../../../features/auth/logout/presentation/bloc/logout_bloc.dart';
import '../../../features/country/data/data_sources/country_remote_data_source.dart';
import '../../../features/country/data/repositories/country_repository.dart';
import '../../../features/country/presentation/bloc/country_bloc.dart';
import '../../../features/city/data/data_sources/city_remote_data_source.dart';
import '../../../features/city/data/repositories/city_repository.dart';
import '../../../features/city/presentation/bloc/city_bloc.dart';
import '../../../features/merchant/list_merchant/data/data_sources/list_merchant_data_source.dart';
import '../../../features/merchant/list_merchant/data/repositories/list_merchant_repository.dart';
import '../../../features/merchant/merchant_statistics/data/data_sources/merchant_statistics_data_source.dart';
import '../../../features/merchant/merchant_statistics/data/repositories/merchant_statistics_repository.dart';
import '../../../features/merchant/merchant_details/data/data_sources/merchant_details_data_source.dart';
import '../../../features/merchant/merchant_details/data/repositories/merchant_details_repository.dart';
import '../../../features/merchant/delete_merchant/data/data_sources/delete_merchant_data_source.dart';
import '../../../features/merchant/delete_merchant/data/repositories/delete_merchant_repository.dart';
import '../../../features/merchant/update_merchant/data/data_sources/update_merchant_data_source.dart';
import '../../../features/merchant/update_merchant/data/repositories/update_merchant_repository.dart';
import '../../../features/merchant/update_merchant/presentation/bloc/update_merchant_bloc.dart';
import '../../../features/merchant/create_merchant/data/data_sources/create_merchant_data_source.dart';
import '../../../features/merchant/create_merchant/data/repositories/create_merchant_repository.dart';
import '../../../features/delivery/list_delivery/data/data_sources/list_delivery_data_source.dart';
import '../../../features/delivery/list_delivery/data/repositories/list_delivery_repository.dart';
import '../../../features/delivery/delivery_details/data/data_sources/delivery_details_data_source.dart';
import '../../../features/delivery/delivery_details/data/repositories/delivery_details_repository.dart';
import '../../../features/delivery/create_delivery/data/data_sources/create_delivery_data_source.dart';
import '../../../features/delivery/create_delivery/data/repositories/create_delivery_repository.dart';
import '../../../features/delivery/update_delivery/data/data_sources/update_delivery_data_source.dart';
import '../../../features/delivery/update_delivery/data/repositories/update_delivery_repository.dart';
import '../../../features/delivery/delete_delivery/data/data_sources/delete_delivery_data_source.dart';
import '../../../features/delivery/delete_delivery/data/repositories/delete_delivery_repository.dart';
import '../../../features/delivery/confirm_delivery/data/data_sources/confirm_delivery_data_source.dart';
import '../../../features/delivery/confirm_delivery/data/repositories/confirm_delivery_repository.dart';
import '../../../features/delivery/confirm_delivery/presentation/bloc/confirm_delivery_bloc.dart';
import '../../../features/order/list_order/data/data_sources/list_order_data_source.dart';
import '../../../features/order/list_order/data/repositories/list_order_repository.dart';
import '../../../features/order/order_details/data/data_sources/order_details_data_source.dart';
import '../../../features/order/order_details/data/repositories/order_details_repository.dart';
import '../../../features/order/order_complete/data/data_sources/order_complete_data_source.dart';
import '../../../features/order/order_complete/data/repositories/order_complete_repository.dart';
import '../../../features/order/order_cancel/data/data_sources/order_cancel_data_source.dart';
import '../../../features/order/order_cancel/data/repositories/order_cancel_repository.dart';
import '../../../features/order/list_order/presentation/bloc/list_order_bloc.dart';
import '../../../features/order/confirm_paid_order/data/data_sources/confirm_paid_order_remote_data_source.dart';
import '../../../features/order/confirm_paid_order/data/repositories/confirm_paid_order_repository.dart';
import '../../../features/order/confirm_paid_order/presentation/bloc/confirm_paid_order_bloc.dart';
import '../../../features/offer/list_offer/data/data_sources/list_offer_data_source.dart';
import '../../../features/offer/list_offer/data/repositories/list_offer_repository.dart';
import '../../../features/offer/offer_details/data/data_sources/offer_details_data_source.dart';
import '../../../features/offer/offer_details/data/repositories/offer_details_repository.dart';
import '../../../features/offer/create_offer/data/data_sources/create_offer_data_source.dart';
import '../../../features/offer/create_offer/data/repositories/create_offer_repository.dart';
import '../../../features/offer/update_offer/data/data_sources/update_offer_data_source.dart';
import '../../../features/offer/update_offer/data/repositories/update_offer_repository.dart';
import '../../../features/offer/delete_offer/data/data_sources/delete_offer_data_source.dart';
import '../../../features/offer/delete_offer/data/repositories/delete_offer_repository.dart';
import '../../../features/order/order_details/presentation/bloc/order_details_bloc.dart';
import '../../../features/order/order_complete/presentation/bloc/order_complete_bloc.dart';
import '../../../features/order/order_cancel/presentation/bloc/order_cancel_bloc.dart';
import '../../../features/product/confirm_product/data/data_sources/confirm_product_data_source.dart';
import '../../../features/product/confirm_product/data/repositories/confirm_product_repository.dart';
import '../../../features/product/confirm_product/presentation/bloc/confirm_product_bloc.dart';
import '../../../features/settings/get_settings/data/data_sources/get_settings_data_source.dart';
import '../../../features/settings/get_settings/data/repositories/get_settings_repository.dart';
import '../../../features/settings/get_settings/presentation/bloc/get_settings_bloc.dart';
import '../../../features/settings/edit_settings/data/data_sources/edit_settings_data_source.dart';
import '../../../features/settings/edit_settings/data/repositories/edit_settings_repository.dart';
import '../../../features/settings/edit_settings/presentation/bloc/edit_settings_bloc.dart';
import '../../../features/notification/update_device_token/data/data_sources/update_device_token_remote_data_source.dart';
import '../../../features/notification/update_device_token/data/repositories/update_device_token_repository.dart';
import '../../../features/notification/update_device_token/presentation/bloc/update_device_token_bloc.dart';
import '../../../features/notification/send_to_customers/data/data_sources/send_to_customers_data_source.dart';
import '../../../features/notification/send_to_customers/data/repositories/send_to_customers_repository.dart';
import '../../../features/notification/send_to_customers/presentation/bloc/send_to_customers_bloc.dart';
import '../services/notification_service.dart';

final sl = GetIt.instance;

/// Initialize Dependency Injection
Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  //! Core Services
  sl.registerLazySingleton<StorageService>(() => StorageServiceImpl(sl()));
  await sl<StorageService>().hydrateAppConstantsCache();
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
  sl.registerFactory(() => ListCategoryBloc(sl()));

  //! Category Add Dependencies
  sl.registerFactory<AddCategoryRemoteDataSource>(
    () => AddCategoryRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => AddCategoryRepository(sl(), sl()));
  sl.registerFactory(() => AddCategoryBloc(sl()));

  //! Category Update Dependencies
  sl.registerFactory<UpdateCategoryRemoteDataSource>(
    () => UpdateCategoryRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => UpdateCategoryRepository(sl(), sl()));
  sl.registerFactory(() => UpdateCategoryBloc(sl()));

  //! Category Delete Dependencies
  sl.registerFactory<DeleteCategoryRemoteDataSource>(
    () => DeleteCategoryRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => DeleteCategoryRepository(sl(), sl()));
  sl.registerFactory(() => DeleteCategoryBloc(sl()));

  //! Areas List Dependencies
  sl.registerFactory<ListAreasRemoteDataSource>(
    () => ListAreasRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ListAreasRepository(sl(), sl()));
  sl.registerFactory(() => ListAreasBloc(sl()));

  //! Areas Create Dependencies
  sl.registerFactory<CreateAreaRemoteDataSource>(
    () => CreateAreaRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => CreateAreaRepository(sl(), sl()));
  sl.registerFactory(() => CreateAreaBloc(sl()));

  //! Areas Update Dependencies
  sl.registerFactory<UpdateAreaRemoteDataSource>(
    () => UpdateAreaRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => UpdateAreaRepository(sl(), sl()));
  sl.registerFactory(() => UpdateAreaBloc(sl()));

  //! Areas Delete Dependencies
  sl.registerFactory<DeleteAreaRemoteDataSource>(
    () => DeleteAreaRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => DeleteAreaRepository(sl(), sl()));
  sl.registerFactory(() => DeleteAreaBloc(sl()));

  //! Areas Details Dependencies
  sl.registerFactory<AreaDetailsRemoteDataSource>(
    () => AreaDetailsRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => AreaDetailsRepository(sl(), sl()));
  sl.registerFactory(() => AreaDetailsBloc(sl()));

  //! Product List Dependencies
  sl.registerFactory<ListProductRemoteDataSource>(
    () => ListProductRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ListProductRepository(sl(), sl()));

  //! Product Confirm Dependencies
  sl.registerFactory<ConfirmProductRemoteDataSource>(
    () => ConfirmProductRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ConfirmProductRepository(sl(), sl()));
  sl.registerFactory(() => ConfirmProductBloc(sl()));

  //! Settings - Get Settings
  sl.registerFactory<GetSettingsRemoteDataSource>(
    () => GetSettingsRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => GetSettingsRepository(sl(), sl()));
  sl.registerFactory(() => GetSettingsBloc(sl()));

  //! Settings - Edit Settings
  sl.registerFactory<EditSettingsRemoteDataSource>(
    () => EditSettingsRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => EditSettingsRepository(sl(), sl()));
  sl.registerFactory(() => EditSettingsBloc(sl()));

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

  //! Auth Dependencies - Login
  sl.registerFactory<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => LoginRepository(sl(), sl()));
  sl.registerFactory(() => LoginBloc(sl(), sl()));

  //! Auth Dependencies - Register
  sl.registerFactory<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => RegisterRepository(sl(), sl()));
  sl.registerFactory(() => RegisterBloc(sl(), sl<StorageService>()));

  //! Auth Dependencies - Verify
  sl.registerFactory<VerifyRemoteDataSource>(
    () => VerifyRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => VerifyRepository(sl(), sl()));
  sl.registerFactory(
      () => VerifyBloc(sl(), sl<StorageService>(), sl<ProfileRepository>(), sl<LoginRepository>()));

  //! Auth Dependencies - Forgot Password
  sl.registerFactory<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => ForgotPasswordRepository(sl(), sl()));
  sl.registerFactory(() => ForgotPasswordBloc(sl()));

  //! Auth Dependencies - Reset Password
  sl.registerFactory<ResetPasswordRemoteDataSource>(
    () => ResetPasswordRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => ResetPasswordRepository(sl(), sl()));
  sl.registerFactory(() => ResetPasswordBloc(sl()));

  //! Auth Dependencies - Profile
  sl.registerFactory<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => ProfileRepository(sl(), sl()));
  sl.registerFactory(() => ProfileBloc(sl<ProfileRepository>(), sl<StorageService>()));
  sl.registerFactory(() => ChangePasswordBloc(sl<ProfileRepository>()));

  //! Auth Dependencies - Logout
  sl.registerFactory<LogoutRemoteDataSource>(
    () => LogoutRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => LogoutRepository(sl(), sl()));
  sl.registerFactory(() => LogoutBloc(sl(), sl()));

  //! Country Dependencies
  sl.registerFactory<CountryRemoteDataSource>(
    () => CountryRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => CountryRepository(sl(), sl()));
  sl.registerFactory(() => CountryBloc(sl()));

  //! City Dependencies
  sl.registerFactory<CityRemoteDataSource>(
    () => CityRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => CityRepository(sl(), sl()));
  sl.registerFactory(() => CityBloc(sl()));

  //! Merchant List Dependencies
  sl.registerFactory<ListMerchantRemoteDataSource>(
    () => ListMerchantRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ListMerchantRepository(sl(), sl()));

  //! Merchant Statistics Dependencies
  sl.registerFactory<MerchantStatisticsRemoteDataSource>(
    () => MerchantStatisticsRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => MerchantStatisticsRepository(sl(), sl()));

  //! Merchant Details Dependencies
  sl.registerFactory<MerchantDetailsRemoteDataSource>(
    () => MerchantDetailsRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => MerchantDetailsRepository(sl(), sl()));

  //! Merchant Delete Dependencies
  sl.registerFactory<DeleteMerchantRemoteDataSource>(
    () => DeleteMerchantRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => DeleteMerchantRepository(sl(), sl()));
  //! Merchant Update Dependencies
  sl.registerFactory<UpdateMerchantRemoteDataSource>(
    () => UpdateMerchantRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => UpdateMerchantRepository(sl(), sl()));
  sl.registerFactory(() => UpdateMerchantBloc(sl()));
  //! Merchant Create Dependencies
  sl.registerFactory<CreateMerchantRemoteDataSource>(
    () => CreateMerchantRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => CreateMerchantRepository(sl(), sl()));
  //! Delivery List Dependencies
  sl.registerFactory<ListDeliveryRemoteDataSource>(
    () => ListDeliveryRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ListDeliveryRepository(sl(), sl()));

  //! Delivery Details Dependencies
  sl.registerFactory<DeliveryDetailsRemoteDataSource>(
    () => DeliveryDetailsRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => DeliveryDetailsRepository(sl(), sl()));

  //! Delivery Confirm Dependencies
  sl.registerFactory<ConfirmDeliveryRemoteDataSource>(
    () => ConfirmDeliveryRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ConfirmDeliveryRepository(sl(), sl()));
  sl.registerFactory(() => ConfirmDeliveryBloc(sl()));

  //! Delivery Create/Update/Delete Dependencies
  sl.registerFactory<CreateDeliveryRemoteDataSource>(
    () => CreateDeliveryRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory<UpdateDeliveryRemoteDataSource>(
    () => UpdateDeliveryRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory<DeleteDeliveryRemoteDataSource>(
    () => DeleteDeliveryRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => CreateDeliveryRepository(sl(), sl()));
  sl.registerFactory(() => UpdateDeliveryRepository(sl(), sl()));
  sl.registerFactory(() => DeleteDeliveryRepository(sl(), sl()));

  //! Order List Dependencies
  sl.registerFactory<ListOrderRemoteDataSource>(
    () => ListOrderRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ListOrderRepository(sl(), sl()));
  sl.registerFactory(() => ListOrderBloc(sl()));

  //! Order — admin confirm delivery payment (POST complete + payload)
  sl.registerFactory<ConfirmPaidOrderRemoteDataSource>(
    () => ConfirmPaidOrderRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => ConfirmPaidOrderRepository(sl(), sl()));
  sl.registerFactory(() => ConfirmPaidOrderBloc(sl()));

  //! Order Details Dependencies
  sl.registerFactory<OrderDetailsRemoteDataSource>(
    () => OrderDetailsRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => OrderDetailsRepository(sl(), sl()));
  sl.registerFactory(() => OrderDetailsBloc(sl()));

  //! Order Complete Dependencies
  sl.registerFactory<OrderCompleteRemoteDataSource>(
    () => OrderCompleteRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => OrderCompleteRepository(sl(), sl()));
  sl.registerFactory(() => OrderCompleteBloc(sl()));

  //! Order Cancel Dependencies
  sl.registerFactory<OrderCancelRemoteDataSource>(
    () => OrderCancelRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => OrderCancelRepository(sl(), sl()));
  sl.registerFactory(() => OrderCancelBloc(sl()));

  //! Offer List
  sl.registerFactory<ListOfferRemoteDataSource>(
    () => ListOfferRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => ListOfferRepository(sl(), sl()));

  //! Offer Details
  sl.registerFactory<OfferDetailsRemoteDataSource>(
    () => OfferDetailsRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => OfferDetailsRepository(sl(), sl()));

  //! Offer Create / Update / Delete
  sl.registerFactory<CreateOfferRemoteDataSource>(
    () => CreateOfferRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory<UpdateOfferRemoteDataSource>(
    () => UpdateOfferRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory<DeleteOfferRemoteDataSource>(
    () => DeleteOfferRemoteDataSourceImpl(sl()),
  );
  sl.registerFactory(() => CreateOfferRepository(sl(), sl()));
  sl.registerFactory(() => UpdateOfferRepository(sl(), sl()));
  sl.registerFactory(() => DeleteOfferRepository(sl(), sl()));

  //! FCM — device token (single endpoint)
  sl.registerFactory<UpdateDeviceTokenRemoteDataSource>(
    () => UpdateDeviceTokenRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => UpdateDeviceTokenRepository(sl(), sl()));
  sl.registerLazySingleton(() => UpdateDeviceTokenBloc(sl(), sl()));

  //! Send notification to all customers (admin)
  sl.registerFactory<SendToCustomersRemoteDataSource>(
    () => SendToCustomersRemoteDataSourceImpl(sl<AppApiServiceClient>()),
  );
  sl.registerFactory(() => SendToCustomersRepository(sl(), sl()));
  sl.registerFactory(() => SendToCustomersBloc(sl()));
  sl.registerLazySingleton(
    () => NotificationService(
      sl<UpdateDeviceTokenBloc>(),
      sl<NavigationService>(),
      sl<StorageService>(),
    ),
  );

  sl.registerLazySingleton<OrderStatusRtdbService>(
    () => OrderStatusRtdbService(),
  );
}
