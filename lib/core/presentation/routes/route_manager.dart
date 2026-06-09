import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'routes.dart';
import 'navigation_service.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';
import '../../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../../features/product/list_product/presentation/pages/list_product_page.dart';
import '../../../features/product/list_product/presentation/bloc/list_product_bloc.dart';
import '../../../features/product/list_product/data/repositories/list_product_repository.dart';
import '../../../features/product/create_product/presentation/pages/create_product_page.dart';
import '../../../features/product/create_product/presentation/bloc/create_product_bloc.dart';
import '../../../features/product/create_product/data/repositories/create_product_repository.dart';
import '../../../features/product/update_product/presentation/bloc/update_product_bloc.dart';
import '../../../features/product/update_product/data/repositories/update_product_repository.dart';
import '../../../features/product/delete_product/presentation/bloc/delete_product_bloc.dart';
import '../../../features/product/delete_product/data/repositories/delete_product_repository.dart';
import '../../../features/product/product_details/presentation/pages/product_details_page.dart';
import '../../../features/product/product_details/presentation/bloc/product_details_bloc.dart';
import '../../../features/product/product_details/data/repositories/product_details_repository.dart';
import '../../../features/product/confirm_product/presentation/bloc/confirm_product_bloc.dart';
import '../../../features/category/list_category/presentation/bloc/list_category_bloc.dart';
import '../../../features/category/list_category/data/repositories/list_category_repository.dart';
import '../../../features/auth/login/presentation/pages/login_page.dart';
import '../../../features/auth/login/presentation/bloc/login_bloc.dart';
import '../../../features/auth/register/presentation/pages/register_page.dart';
import '../../../features/auth/register/presentation/bloc/register_bloc.dart';
import '../../../features/auth/verify/presentation/pages/verify_page.dart';
import '../../../features/auth/verify/presentation/bloc/verify_bloc.dart';
import '../../../features/auth/forgot_password/presentation/pages/forgot_password_page.dart';
import '../../../features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import '../../../features/auth/reset_password/presentation/pages/reset_password_page.dart';
import '../../../features/auth/reset_password/presentation/bloc/reset_password_bloc.dart';
import '../../../features/auth/profile/presentation/pages/profile_page.dart';
import '../../../features/auth/profile/presentation/pages/change_password_page.dart';
import '../../../features/auth/profile/presentation/bloc/profiel/profile_bloc.dart';
import '../../../features/auth/profile/presentation/bloc/change_password/change_password_bloc.dart';
import '../../../features/auth/logout/presentation/bloc/logout_bloc.dart';
import '../../../features/country/presentation/bloc/country_bloc.dart';
import '../../../features/city/presentation/bloc/city_bloc.dart';
import '../../../features/order/list_order/presentation/pages/list_order_page.dart';
import '../../../features/order/list_order/presentation/bloc/list_order_bloc.dart';
import '../../../features/order/confirm_paid_order/presentation/bloc/confirm_paid_order_bloc.dart';
import '../../../features/order/order_details/presentation/pages/order_details_page.dart';
import '../../../features/order/order_details/presentation/bloc/order_details_bloc.dart';
import '../../../features/order/order_status_section/presentation/pages/order_status_page.dart';
import '../../../features/order/order_status_section/presentation/bloc/order_status_bloc.dart';
import '../../../features/order/order_details/domain/entities/order_status.dart';
import '../../infrastructure/realtime/order_status_rtdb_service.dart';
import '../../../features/order/order_complete/presentation/bloc/order_complete_bloc.dart';
import '../../../features/order/order_cancel/presentation/bloc/order_cancel_bloc.dart';
import '../../../features/main_navigation/presentation/pages/main_navigation_page.dart';
import '../../../features/merchant/list_merchant/presentation/pages/list_merchant_page.dart';
import '../../../features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';
import '../../../features/merchant/list_merchant/data/repositories/list_merchant_repository.dart';
import '../../../features/merchant/merchant_details/presentation/pages/merchant_details_page.dart';
import '../../../features/merchant/merchant_details/presentation/bloc/merchant_details_bloc.dart';
import '../../../features/merchant/merchant_details/data/repositories/merchant_details_repository.dart';
import '../../../features/merchant/delete_merchant/presentation/bloc/delete_merchant_bloc.dart';
import '../../../features/merchant/delete_merchant/data/repositories/delete_merchant_repository.dart';
import '../../../features/merchant/update_merchant/presentation/pages/edit_merchant_page.dart';
import '../../../features/merchant/update_merchant/presentation/bloc/update_merchant_bloc.dart';
import '../../../features/merchant/update_merchant/data/repositories/update_merchant_repository.dart';
import '../../../features/delivery/list_delivery/presentation/pages/list_delivery_page.dart';
import '../../../features/delivery/list_delivery/presentation/bloc/list_delivery_bloc.dart';
import '../../../features/delivery/list_delivery/data/repositories/list_delivery_repository.dart';
import '../../../features/delivery/delivery_details/presentation/pages/delivery_details_page.dart';
import '../../../features/delivery/delivery_details/presentation/bloc/delivery_details_bloc.dart';
import '../../../features/delivery/delivery_details/data/repositories/delivery_details_repository.dart';
import '../../../features/delivery/create_delivery/presentation/pages/add_delivery_page.dart';
import '../../../features/delivery/create_delivery/presentation/bloc/create_delivery_bloc.dart';
import '../../../features/delivery/create_delivery/data/repositories/create_delivery_repository.dart';
import '../../../features/delivery/update_delivery/presentation/bloc/update_delivery_bloc.dart';
import '../../../features/delivery/update_delivery/data/repositories/update_delivery_repository.dart';
import '../../../features/delivery/delete_delivery/presentation/bloc/delete_delivery_bloc.dart';
import '../../../features/delivery/delete_delivery/data/repositories/delete_delivery_repository.dart';
import '../../../features/delivery/confirm_delivery/presentation/bloc/confirm_delivery_bloc.dart';
import '../../../features/delivery/confirm_delivery/data/repositories/confirm_delivery_repository.dart';
import '../../../features/delivery/delivery_details/domain/entities/delivery_man_entity.dart';
import '../../../features/offer/list_offer/presentation/pages/list_offer_page.dart';
import '../../../features/offer/list_offer/presentation/bloc/list_offer_bloc.dart';
import '../../../features/offer/list_offer/data/repositories/list_offer_repository.dart';
import '../../../features/offer/offer_details/presentation/pages/offer_details_page.dart';
import '../../../features/offer/offer_details/presentation/bloc/offer_details_bloc.dart';
import '../../../features/offer/offer_details/data/repositories/offer_details_repository.dart';
import '../../../features/offer/create_offer/presentation/pages/create_offer_page.dart';
import '../../../features/offer/create_offer/presentation/bloc/create_offer_bloc.dart';
import '../../../features/offer/create_offer/data/repositories/create_offer_repository.dart';
import '../../../features/offer/update_offer/presentation/bloc/update_offer_bloc.dart';
import '../../../features/offer/update_offer/data/repositories/update_offer_repository.dart';
import '../../../features/offer/delete_offer/presentation/bloc/delete_offer_bloc.dart';
import '../../../features/offer/delete_offer/data/repositories/delete_offer_repository.dart';
import '../../../features/offer/list_offer/domain/entities/offer_entity.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/settings/get_settings/presentation/bloc/get_settings_bloc.dart';
import '../../../features/settings/edit_settings/presentation/bloc/edit_settings_bloc.dart';
import '../../../features/category/presentation/pages/categories_page.dart';
import '../../../features/category/add_category/presentation/bloc/add_category_bloc.dart';
import '../../../features/category/update_category/presentation/bloc/update_category_bloc.dart';
import '../../../features/category/delete_category/presentation/bloc/delete_category_bloc.dart';

import '../../infrastructure/di/dependency_injection.dart' as di;

double? routeArgAsDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

/// Application Router
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(const SplashPage(), settings);

      case Routes.onboarding:
        return _buildRouteWithBloc(
          const OnboardingPage(),
          settings,
          bloc: () => OnboardingBloc(),
        );

      case Routes.login:
        return _buildRouteWithBloc(
          const LoginPage(),
          settings,
          bloc: () => di.sl<LoginBloc>(),
        );

      case Routes.register:
        return _buildRouteWithBlocs(
          const RegisterPage(),
          settings,
          providers: [
            BlocProvider<RegisterBloc>(
              create: (_) => di.sl<RegisterBloc>(),
            ),
            BlocProvider<CountryBloc>(
              create: (_) => di.sl<CountryBloc>(),
            ),
            BlocProvider<CityBloc>(
              create: (_) => di.sl<CityBloc>(),
            ),
          ],
        );

      case Routes.verify:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String? ?? '';
        final password = args?['password'] as String?;
        final registerBloc = args?['registerBloc'] as RegisterBloc?;
        return _buildRouteWithBlocs(
          VerifyPage(email: email, password: password),
          settings,
          providers: [
            BlocProvider<VerifyBloc>(
              create: (_) => di.sl<VerifyBloc>(),
            ),
            if (registerBloc != null)
              BlocProvider<RegisterBloc>.value(value: registerBloc),
          ],
        );

      case Routes.forgotPassword:
        return _buildRouteWithBloc(
          const ForgotPasswordPage(),
          settings,
          bloc: () => di.sl<ForgotPasswordBloc>(),
        );

      case Routes.resetPassword:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String? ?? '';
        return _buildRouteWithBloc(
          ResetPasswordPage(email: email),
          settings,
          bloc: () => di.sl<ResetPasswordBloc>(),
        );

      case Routes.profile:
        return _buildRouteWithBlocs(
          const ProfilePage(),
          settings,
          providers: [
            BlocProvider<ProfileBloc>(
              create: (_) => di.sl<ProfileBloc>()..add(const GetProfile()),
            ),
            BlocProvider<LogoutBloc>(
              create: (_) => di.sl<LogoutBloc>(),
            ),
          ],
        );

      case Routes.changePassword:
        return _buildRouteWithBloc(
          const ChangePasswordPage(),
          settings,
          bloc: () => di.sl<ChangePasswordBloc>(),
        );

      case Routes.settings:
        return _buildRouteWithBlocs(
          const SettingsPage(),
          settings,
          providers: [
            BlocProvider<GetSettingsBloc>(
              create: (_) => di.sl<GetSettingsBloc>(),
            ),
            BlocProvider<EditSettingsBloc>(
              create: (_) => di.sl<EditSettingsBloc>(),
            ),
          ],
        );

      case Routes.categories:
        return _buildRouteWithBlocs(
          const CategoriesPage(),
          settings,
          providers: [
            BlocProvider<ListCategoryBloc>(
              create: (_) => di.sl<ListCategoryBloc>(),
            ),
            BlocProvider<AddCategoryBloc>(
              create: (_) => di.sl<AddCategoryBloc>(),
            ),
            BlocProvider<UpdateCategoryBloc>(
              create: (_) => di.sl<UpdateCategoryBloc>(),
            ),
            BlocProvider<DeleteCategoryBloc>(
              create: (_) => di.sl<DeleteCategoryBloc>(),
            ),
          ],
        );

      case Routes.products:
// <<<<<<< HEAD
        final productArgs = settings.arguments as Map<String, dynamic>?;
        final productMerchantId = productArgs?['merchantId'] as String?;
//         return _buildRouteWithBloc(
//           const ListProductPage(),
//           settings,
//           bloc: () =>
//               ListProductBloc(di.sl<ListProductRepository>())
//                 ..add(GetProductsEvent(merchantId: productMerchantId)),
// =======
        return _buildRouteWithBlocs(
          ListProductPage(merchantId: productMerchantId),
          settings,
          providers: [
            BlocProvider<ListProductBloc>(
              create: (_) =>
                 ListProductBloc(di.sl<ListProductRepository>())
                ..add(GetProductsEvent(merchantId: productMerchantId)),
            ),
            BlocProvider<ConfirmProductBloc>(
              create: (_) => di.sl<ConfirmProductBloc>(),
            ),
          ],
// >>>>>>> 01548bdab41b53e5162e3d8617375f258e8805f2
        );

      case Routes.addProduct:
        final args = settings.arguments as Map<String, dynamic>?;
        final product = args?['product'];
        return _buildRouteWithBlocs(
          CreateProductPage(product: product),
          settings,
          providers: [
            BlocProvider<CreateProductBloc>(
              create: (_) =>
                  CreateProductBloc(di.sl<CreateProductRepository>()),
            ),
            BlocProvider<UpdateProductBloc>(
              create: (_) =>
                  UpdateProductBloc(di.sl<UpdateProductRepository>()),
            ),
            BlocProvider<DeleteProductBloc>(
              create: (_) =>
                  DeleteProductBloc(di.sl<DeleteProductRepository>()),
            ),
            BlocProvider<ProductDetailsBloc>(
              create: (_) =>
                  ProductDetailsBloc(di.sl<ProductDetailsRepository>()),
            ),
            BlocProvider<ListCategoryBloc>(
              create: (_) =>
                  ListCategoryBloc(di.sl<ListCategoryRepository>()),
            ),
          ],
        );

      case Routes.productDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'] as String? ?? '';
        final tabIndexOnBack = args?['tabIndexOnBack'] as int? ?? 0;
        return _buildRouteWithBlocs(
          ProductDetailsPage(productId: productId, tabIndexOnBack: tabIndexOnBack),
          settings,
          providers: [
            BlocProvider<ProductDetailsBloc>(
              create: (_) =>
                  ProductDetailsBloc(di.sl<ProductDetailsRepository>()),
            ),
            BlocProvider<ConfirmProductBloc>(
              create: (_) => di.sl<ConfirmProductBloc>(),
            ),
            BlocProvider<DeleteProductBloc>(
              create: (_) =>
                  DeleteProductBloc(di.sl<DeleteProductRepository>()),
            ),
          ],
        );

      case Routes.mainNavigation:
        final mainArgs = settings.arguments as Map<String, dynamic>?;
        final tabIndex = mainArgs?['tabIndex'] as int? ?? 0;
        return _buildRoute(
          MainNavigationPage(initialTabIndex: tabIndex),
          settings,
        );

      case Routes.merchants:
        return _buildRouteWithBloc(
          const ListMerchantPage(),
          settings,
          bloc: () =>
              ListMerchantBloc(di.sl<ListMerchantRepository>())
                ..add(const GetMerchantsEvent()),
        );

      case Routes.merchantDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final merchantId = args?['merchantId'] as String? ?? '';
        if (merchantId.isEmpty) {
          return _buildRoute(
            Scaffold(
              body: Center(
                child: CustomText(
                  text: 'Merchant ID not provided',
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s16,
                    color: ColorManager.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            settings,
          );
        }
        return _buildRouteWithBlocs(
          MerchantDetailsPage(merchantId: merchantId),
          settings,
          providers: [
            BlocProvider<MerchantDetailsBloc>(
              create: (_) =>
                  MerchantDetailsBloc(di.sl<MerchantDetailsRepository>()),
            ),
            BlocProvider<ListProductBloc>(
              create: (_) =>
                  ListProductBloc(di.sl<ListProductRepository>()),
            ),
            BlocProvider<ListOfferBloc>(
              create: (_) =>
                  ListOfferBloc(di.sl<ListOfferRepository>()),
            ),
            BlocProvider<DeleteMerchantBloc>(
              create: (_) =>
                  DeleteMerchantBloc(di.sl<DeleteMerchantRepository>()),
            ),
            BlocProvider<UpdateMerchantBloc>(
              create: (_) => UpdateMerchantBloc(di.sl<UpdateMerchantRepository>()),
            ),
          ],
        );

      case Routes.editMerchant:
        final args = settings.arguments as Map<String, dynamic>?;
        final merchantId = args?['merchantId'] as String? ?? '';
        if (merchantId.isEmpty) {
          return _buildRoute(
            Scaffold(
              body: Center(
                child: CustomText(
                  text: 'Merchant ID not provided',
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s16,
                    color: ColorManager.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            settings,
          );
        }
        return _buildRouteWithBlocs(
          EditMerchantPage(merchantId: merchantId),
          settings,
          providers: [
            BlocProvider<MerchantDetailsBloc>(
              create: (_) =>
                  MerchantDetailsBloc(di.sl<MerchantDetailsRepository>()),
            ),
            BlocProvider<UpdateMerchantBloc>(
              create: (_) => UpdateMerchantBloc(di.sl<UpdateMerchantRepository>()),
            ),
            BlocProvider<CountryBloc>(
              create: (_) => di.sl<CountryBloc>(),
            ),
            BlocProvider<CityBloc>(
              create: (_) => di.sl<CityBloc>(),
            ),
          ],
        );

      case Routes.delivery:
        return _buildRouteWithBlocs(
          const ListDeliveryPage(),
          settings,
          providers: [
            BlocProvider<ListDeliveryBloc>(
              create: (_) =>
                  ListDeliveryBloc(di.sl<ListDeliveryRepository>())
                    ..add(const GetDeliveryMenEvent()),
            ),
          ],
        );

      case Routes.deliveryDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final deliveryManId = args?['deliveryManId'] as String? ?? '';
        if (deliveryManId.isEmpty) {
          return _buildRoute(
            Scaffold(
              body: Center(
                child: CustomText(
                  text: 'Delivery man ID not provided',
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s16,
                    color: ColorManager.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            settings,
          );
        }
        return _buildRouteWithBlocs(
          DeliveryDetailsPage(deliveryManId: deliveryManId),
          settings,
          providers: [
            BlocProvider<DeliveryDetailsBloc>(
              create: (_) =>
                  DeliveryDetailsBloc(di.sl<DeliveryDetailsRepository>())
                    ..add(GetDeliveryManDetailsEvent(id: deliveryManId)),
            ),
            BlocProvider<DeleteDeliveryBloc>(
              create: (_) => DeleteDeliveryBloc(di.sl<DeleteDeliveryRepository>()),
            ),
            BlocProvider<ConfirmDeliveryBloc>(
              create: (_) => ConfirmDeliveryBloc(di.sl<ConfirmDeliveryRepository>()),
            ),
          ],
        );

      case Routes.addDelivery:
        final args = settings.arguments as Map<String, dynamic>?;
        final deliveryMan = args?['deliveryMan'] as DeliveryManEntity?;
        return _buildRouteWithBlocs(
          AddDeliveryPage(deliveryMan: deliveryMan),
          settings,
          providers: [
            BlocProvider<CountryBloc>(
              create: (_) => di.sl<CountryBloc>(),
            ),
            BlocProvider<CityBloc>(
              create: (_) => di.sl<CityBloc>(),
            ),
            BlocProvider<CreateDeliveryBloc>(
              create: (_) =>
                  CreateDeliveryBloc(di.sl<CreateDeliveryRepository>()),
            ),
            BlocProvider<UpdateDeliveryBloc>(
              create: (_) =>
                  UpdateDeliveryBloc(di.sl<UpdateDeliveryRepository>()),
            ),
            BlocProvider<DeleteDeliveryBloc>(
              create: (_) =>
                  DeleteDeliveryBloc(di.sl<DeleteDeliveryRepository>()),
            ),
          ],
        );

      case Routes.orders:
        return _buildRouteWithBlocs(
          const ListOrderPage(),
          settings,
          providers: [
            BlocProvider<ListOrderBloc>(
              create: (_) => di.sl<ListOrderBloc>(),
            ),
            BlocProvider<ConfirmPaidOrderBloc>(
              create: (_) => di.sl<ConfirmPaidOrderBloc>(),
            ),
          ],
        );

      case Routes.orderDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final orderId = args?['orderId'] as String? ?? '';
        if (orderId.isEmpty) {
          return _buildRoute(
            Scaffold(
              body: Center(
                child: CustomText(
                  text: 'Order ID not provided',
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s16,
                    color: ColorManager.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            settings,
          );
        }
        return _buildRouteWithBlocs(
          OrderDetailsPage(orderId: orderId),
          settings,
          providers: [
            BlocProvider<OrderDetailsBloc>(
              create: (_) => di.sl<OrderDetailsBloc>()
                ..add(GetOrderDetailsEvent(orderId)),
            ),
            BlocProvider<OrderCompleteBloc>(
              create: (_) => di.sl<OrderCompleteBloc>(),
            ),
            BlocProvider<OrderCancelBloc>(
              create: (_) => di.sl<OrderCancelBloc>(),
            ),
            BlocProvider<ConfirmPaidOrderBloc>(
              create: (_) => di.sl<ConfirmPaidOrderBloc>(),
            ),
          ],
        );

      case Routes.orderStatus:
        final osArgs = settings.arguments as Map<String, dynamic>?;
        final orderStatusId = osArgs?['orderId'] as String? ?? '';
        final initialWire = osArgs?['initialStatus'] as String?;
        final initialStatus = OrderStatus.fromString(initialWire);
        final deliveryLat = routeArgAsDouble(osArgs?['deliveryLatitude']);
        final deliveryLng = routeArgAsDouble(osArgs?['deliveryLongitude']);
        if (orderStatusId.isEmpty) {
          return _buildRoute(
            Scaffold(
              body: Center(
                child: CustomText(
                  text: 'Order ID not provided',
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s16,
                    color: ColorManager.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            settings,
          );
        }
        return _buildRouteWithBlocs(
          const OrderStatusPage(),
          settings,
          providers: [
            BlocProvider<OrderStatusBloc>(
              create: (_) => OrderStatusBloc(
                orderId: orderStatusId,
                initialStatus: initialStatus,
                initialStatusWire: initialWire,
                deliveryLatitude: deliveryLat,
                deliveryLongitude: deliveryLng,
                orderStatusRtdb: di.sl<OrderStatusRtdbService>(),
              ),
            ),
          ],
        );

      case Routes.offers:
        final offerArgs = settings.arguments as Map<String, dynamic>?;
        final offerMerchantId = offerArgs?['merchantId'] as String?;
        return _buildRouteWithBloc(
          const ListOfferPage(),
          settings,
          bloc: () =>
              ListOfferBloc(di.sl<ListOfferRepository>())
                ..add(GetOffersEvent(merchantId: offerMerchantId)),
        );

      case Routes.offerDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final offerId = args?['offerId'] as String? ?? '';
        if (offerId.isEmpty) {
          return _buildRoute(
            Scaffold(
              body: Center(
                child: CustomText(
                  text: 'Offer ID not provided',
                  textStyle: getRegularStyle(
                    fontSize: AppFontSize.s16,
                    color: ColorManager.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            settings,
          );
        }
        return _buildRouteWithBlocs(
          OfferDetailsPage(offerId: offerId),
          settings,
          providers: [
            BlocProvider<OfferDetailsBloc>(
              create: (_) =>
                  OfferDetailsBloc(di.sl<OfferDetailsRepository>()),
            ),
          ],
        );

      case Routes.addOffer:
        final args = settings.arguments as Map<String, dynamic>?;
        final offer = args?['offer'] as OfferEntity?;
        return _buildRouteWithBlocs(
          CreateOfferPage(offer: offer),
          settings,
          providers: [
            BlocProvider<ListProductBloc>(
              create: (_) =>
                  ListProductBloc(di.sl<ListProductRepository>())
                    ..add(const GetProductsEvent()),
            ),
            BlocProvider<CreateOfferBloc>(
              create: (_) =>
                  CreateOfferBloc(di.sl<CreateOfferRepository>()),
            ),
            BlocProvider<UpdateOfferBloc>(
              create: (_) =>
                  UpdateOfferBloc(di.sl<UpdateOfferRepository>()),
            ),
            BlocProvider<DeleteOfferBloc>(
              create: (_) =>
                  DeleteOfferBloc(di.sl<DeleteOfferRepository>()),
            ),
          ],
        );

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: CustomText(
                text: 'No route defined for ${settings.name}',
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s16,
                  color: ColorManager.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Build route with a single BLoC provider
  /// Usage: _buildRouteWithBloc(MyScreen(), settings, bloc: () => di.sl<MyBloc>())
  // ignore: unused_element
  static PageRouteBuilder _buildRouteWithBloc<
    T extends StateStreamableSource<Object?>
  >(Widget page, RouteSettings settings, {required T Function() bloc}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) =>
          BlocProvider<T>(create: (_) => bloc(), child: page),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Build route with an existing BLoC value (passed from previous screen)
  /// Usage: _buildRouteWithBlocValue(MyScreen(), settings, bloc: existingBloc)
  // ignore: unused_element
  static PageRouteBuilder _buildRouteWithBlocValue<
    T extends StateStreamableSource<Object?>
  >(Widget page, RouteSettings settings, {required T bloc}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) =>
          BlocProvider<T>.value(value: bloc, child: page),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Build route with multiple BLoC providers
  /// Usage:
  /// ```dart
  /// final args = settings.arguments as Map<String, dynamic>?;
  /// return _buildRouteWithBlocs(
  ///   MyScreen(id: args?['id']),
  ///   settings,
  ///   providers: [
  ///     BlocProvider(create: (_) => di.sl<MyBloc>()),
  ///     BlocProvider(create: (_) => di.sl<AnotherBloc>()),
  ///   ],
  /// );
  /// ```
  static PageRouteBuilder _buildRouteWithBlocs(
    Widget page,
    RouteSettings settings, {
    required List<BlocProvider> providers,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        return MultiBlocProvider(providers: providers, child: page);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Navigation methods using NavigationService
  static void navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    NavigationService().pushNamed(routeName, arguments: arguments);
  }

  static void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    NavigationService().pushReplacementNamed(routeName, arguments: arguments);
  }

  static void navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    NavigationService().pushNamedAndRemoveUntil(
      routeName,
      arguments: arguments,
    );
  }

  static void goBack(BuildContext context) {
    NavigationService().back();
  }
}
