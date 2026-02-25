import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/features/main_navigation/presentation/pages/merchant_navigation.dart';
import 'package:jeeb_admin/features/main_navigation/presentation/pages/admin_navigation.dart';
import '../../../../core/infrastructure/di/dependency_injection.dart' as di;

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  String? _userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final storageService = di.sl<StorageService>();
    final role = await storageService.getUserRole();
    setState(() {
      _userRole = role;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: ColorManager.background,
        body: Center(
          child: CircularProgressIndicator(
            color: ColorManager.primary,
          ),
        ),
      );
    }

    // Route based on user role
    switch (_userRole) {
      case 'merchant':
        return const MerchantNavigation();
      case 'admin':
        return const AdminNavigation();
      default:
        // If no role found, redirect to login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/login');
        });
        return Scaffold(
          backgroundColor: ColorManager.background,
          body: Center(
            child: CircularProgressIndicator(
              color: ColorManager.primary,
            ),
          ),
        );
    }
  }
}

