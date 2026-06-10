import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/features/auth/profile/presentation/pages/profile_page.dart';
import 'package:jeeb_admin/features/auth/profile/presentation/bloc/profiel/profile_bloc.dart';
import 'package:jeeb_admin/features/auth/logout/presentation/bloc/logout_bloc.dart';
import 'package:jeeb_admin/features/notification/send_to_customers/presentation/bloc/send_to_customers_bloc.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/pages/list_order_page.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/bloc/list_order_bloc.dart';
import 'package:jeeb_admin/features/order/confirm_paid_order/presentation/bloc/confirm_paid_order_bloc.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/pages/list_delivery_page.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/presentation/bloc/list_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/list_delivery/data/repositories/list_delivery_repository.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/pages/list_merchant_page.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/data/repositories/list_merchant_repository.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/bloc/update_merchant_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
class AdminNavigation extends StatefulWidget {
  final int initialIndex;

  const AdminNavigation({super.key, this.initialIndex = 0});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return MultiBlocProvider(
          providers: [
            BlocProvider<ListMerchantBloc>(
              create: (_) =>
                  ListMerchantBloc(di.sl<ListMerchantRepository>())
                    ..add(const GetMerchantsEvent()),
            ),
            BlocProvider<UpdateMerchantBloc>(
              create: (_) => di.sl<UpdateMerchantBloc>(),
            ),
          ],
          child: const ListMerchantPage(),
        );
      case 1:
        return MultiBlocProvider(
          providers: [
            BlocProvider<ListOrderBloc>(
              create: (_) => di.sl<ListOrderBloc>()
                ..add(const GetOrdersEvent()),
            ),
            BlocProvider<ConfirmPaidOrderBloc>(
              create: (_) => di.sl<ConfirmPaidOrderBloc>(),
            ),
          ],
          child: const ListOrderPage(),
        );
      case 2:
        return BlocProvider<ListDeliveryBloc>(
          create: (_) =>
              ListDeliveryBloc(di.sl<ListDeliveryRepository>())
                ..add(const GetDeliveryMenEvent()),
          child: const ListDeliveryPage(),
        );
      case 3:
        return MultiBlocProvider(
          providers: [
            BlocProvider<ProfileBloc>(
              create: (_) => di.sl<ProfileBloc>()..add(const GetProfile()),
            ),
            BlocProvider<LogoutBloc>(
              create: (_) => di.sl<LogoutBloc>(),
            ),
            BlocProvider<SendToCustomersBloc>(
              create: (_) => di.sl<SendToCustomersBloc>(),
            ),
          ],
          child: const ProfilePage(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ColorManager.primaryDark,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: ColorManager.primaryDark,
              selectedItemColor: ColorManager.primary,
              unselectedItemColor: ColorManager.textSecondary,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: getSemiBoldStyle(
                fontSize: AppFontSize.s12,
                color: ColorManager.primary,
              ),
              unselectedLabelStyle: getRegularStyle(
                fontSize: AppFontSize.s12,
                color: ColorManager.textSecondary,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.store_outlined),
                  activeIcon: Icon(Icons.store),
                  label: AppTranslation.merchants,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  activeIcon: Icon(Icons.shopping_bag),
                  label: AppTranslation.orders,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.delivery_dining_outlined),
                  activeIcon: Icon(Icons.delivery_dining),
                  label: AppTranslation.deliveryMen,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: AppTranslation.profile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

