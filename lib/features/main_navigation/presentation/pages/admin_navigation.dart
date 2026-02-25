import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/features/auth/profile/presentation/pages/profile_page.dart';
import 'package:jeeb_admin/features/auth/profile/presentation/bloc/profile_bloc.dart';
import 'package:jeeb_admin/features/main_navigation/presentation/pages/orders_page.dart';
import 'package:jeeb_admin/features/main_navigation/presentation/pages/merchants_page.dart';
import 'package:jeeb_admin/features/main_navigation/presentation/pages/delivery_page.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _currentIndex = 0;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const MerchantsPage();
      case 1:
        return const OrdersPage();
      case 2:
        return const DeliveryPage();
      case 3:
        return BlocProvider<ProfileBloc>(
          create: (_) => di.sl<ProfileBloc>()..add(const GetProfile()),
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Merchants',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining_outlined),
              activeIcon: Icon(Icons.delivery_dining),
              label: 'Delivery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

