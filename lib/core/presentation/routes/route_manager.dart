import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'routes.dart';
import 'navigation_service.dart';
// import '../dependency_injection/dependency_injection.dart' as di;
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
import '../../../features/auth/profile/presentation/bloc/profile_bloc.dart';
import '../../../features/country/presentation/bloc/country_bloc.dart';
import '../../../features/city/presentation/bloc/city_bloc.dart';
import '../../../features/main_navigation/presentation/pages/main_navigation_page.dart';
import '../../../features/merchant/list_merchant/presentation/pages/list_merchant_page.dart';
import '../../../features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';
import '../../../features/merchant/list_merchant/data/repositories/list_merchant_repository.dart';
import '../../../features/merchant/merchant_details/presentation/pages/merchant_details_page.dart';
import '../../../features/merchant/merchant_details/presentation/bloc/merchant_details_bloc.dart';
import '../../../features/merchant/merchant_details/data/repositories/merchant_details_repository.dart';

import '../../infrastructure/di/dependency_injection.dart' as di;

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
        return _buildRouteWithBloc(
          VerifyPage(email: email),
          settings,
          bloc: () => di.sl<VerifyBloc>(),
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
        return _buildRouteWithBloc(
          const ProfilePage(),
          settings,
          bloc: () => di.sl<ProfileBloc>()..add(const GetProfile()),
        );

      case Routes.products:
        return _buildRouteWithBloc(
          const ListProductPage(),
          settings,
          bloc: () =>
              ListProductBloc(di.sl<ListProductRepository>())
                ..add(const GetProductsEvent()),
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
          ],
        );

      case Routes.productDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'] as String? ?? '';
        return _buildRouteWithBlocs(
          ProductDetailsPage(productId: productId),
          settings,
          providers: [
            BlocProvider<ProductDetailsBloc>(
              create: (_) =>
                  ProductDetailsBloc(di.sl<ProductDetailsRepository>()),
            ),
          ],
        );

      case Routes.mainNavigation:
        return _buildRoute(
          const MainNavigationPage(),
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
                child: Text('Merchant ID not provided'),
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
          ],
        );

      default:
        return _buildRoute(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
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
