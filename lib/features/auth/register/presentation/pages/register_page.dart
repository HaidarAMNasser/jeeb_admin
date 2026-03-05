import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_service.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:jeeb_admin/features/country/domain/entities/country_entity.dart';
import 'package:jeeb_admin/features/city/domain/entities/city_entity.dart';
import 'package:jeeb_admin/core/common/utils/location_permission_helper.dart';
import '../bloc/register_bloc.dart';
import '../widgets/register_form.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  String? _selectedRole = 'MERCHANT';
  String? _selectedNotificationChannel = 'EMAIL';
  CountryEntity? _selectedCountry;
  CityEntity? _selectedCity;
  double? _useLocationLat;
  double? _useLocationLng;
  bool _isLocationLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _restaurantNameController.dispose();
    super.dispose();
  }

  void _onCountryChanged(CountryEntity? country) {
    setState(() {
      _selectedCountry = country;
      _selectedCity = null;
      _useLocationLat = null;
      _useLocationLng = null;
    });
  }

  void _onCityChanged(CityEntity? city) {
    setState(() {
      _selectedCity = city;
      _useLocationLat = null;
      _useLocationLng = null;
    });
  }

  Future<void> _onUseMyLocation() async {
    setState(() => _isLocationLoading = true);
    final position = await LocationPermissionHelper.requestAndGetPosition();
    if (!mounted) return;
    setState(() {
      _isLocationLoading = false;
      if (position != null) {
        _useLocationLat = position.latitude;
        _useLocationLng = position.longitude;
        _selectedCountry = null;
        _selectedCity = null;
      }
    });
    if (position == null) {
      customToast(msg: AppTranslation.locationPermissionDenied);
    }
  }

  void _onClearDeviceLocation() {
    setState(() {
      _useLocationLat = null;
      _useLocationLng = null;
    });
  }

  /// Register button: go to home directly (dev/build flow).
  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      final storage = di.sl<StorageService>();
      await storage.setUserToken('dev_access_token');
      await storage.setUserRole(UserRole.merchant.name);
      if (!mounted) return;
      NavigationService().pushNamedAndRemoveUntil(Routes.mainNavigation);
    } catch (e) {
      if (mounted) customToast(msg: 'Could not continue: $e');
    }
  }

  /// Skip registration and go to app home (for development / building).
  Future<void> _handleAccessApp() async {
    try {
      final storage = di.sl<StorageService>();
      await storage.setUserToken('dev_access_token');
      await storage.setUserRole(UserRole.merchant.name);
      if (!mounted) return;
      NavigationService().pushNamedAndRemoveUntil(Routes.mainNavigation);
    } catch (e) {
      if (mounted) customToast(msg: 'Could not access app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          customToast(msg: AppTranslation.registerSuccess);
          context.pushNamed(Routes.verify, arguments: {'email': state.email});
        } else if (state is RegisterError) {
          customToast(msg: state.message);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          progressIndicator: const CustomCircleIndicator(),
          inAsyncCall: state is RegisterLoading,
          child: Scaffold(
            backgroundColor: ColorManager.background,
            appBar: CustomAppBar(title: AppTranslation.register),

            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppPadding.p24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RegisterForm(
                  formKey: _formKey,
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  phoneController: _phoneController,
                  addressController: _addressController,
                  restaurantNameController: _restaurantNameController,
                  selectedRole: _selectedRole,
                  selectedNotificationChannel: _selectedNotificationChannel,
                  selectedCountry: _selectedCountry,
                  selectedCity: _selectedCity,
                  useLocationLatitude: _useLocationLat,
                  useLocationLongitude: _useLocationLng,
                  onCountryChanged: _onCountryChanged,
                  onCityChanged: _onCityChanged,
                  onUseMyLocation: _onUseMyLocation,
                  onClearDeviceLocation: _onClearDeviceLocation,
                  onRoleChanged: (role) => setState(() => _selectedRole = role),
                  onNotificationChannelChanged: (channel) =>
                      setState(() => _selectedNotificationChannel = channel),
                  onRegister: _handleRegister,
                  isLoading: state is RegisterLoading,
                  isLocationLoading: _isLocationLoading,
                ),
                    SizedBox(height: AppHeight.s16),
                    Center(
                      child: TextButton(
                        onPressed: _handleAccessApp,
                        child: Text(
                          'Access app',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorManager.descriptionColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
