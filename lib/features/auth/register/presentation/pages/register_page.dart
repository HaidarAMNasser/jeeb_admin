import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_display.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/infrastructure/api/api_service.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/features/auth/login/data/models/country_model.dart';
import 'package:jeeb_admin/features/auth/login/data/models/city_model.dart';
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
  String? _selectedRole = 'MERCHANT';
  String? _selectedNotificationChannel = 'EMAIL';
  int? _selectedCountryId;
  int? _selectedCityId;
  
  List<CountryModel> _countries = [];
  List<CityModel> _cities = [];
  bool _isLoadingCountries = false;
  bool _isLoadingCities = false;
  final AppApiServiceClient _apiService = di.sl<AppApiServiceClient>();

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchCountries() async {
    setState(() => _isLoadingCountries = true);
    try {
      final response = await _apiService.getCountries(1, 100);
      final responseData = response.data as Map<String, dynamic>;
      final dataList = responseData['data'] as List<dynamic>?;
      if (dataList != null) {
        setState(() {
          _countries = dataList
              .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
              .toList();
          _isLoadingCountries = false;
        });
      } else {
        setState(() => _isLoadingCountries = false);
        customToast(msg: 'Failed to load countries');
      }
    } catch (e) {
      setState(() => _isLoadingCountries = false);
      customToast(msg: 'Error loading countries');
    }
  }

  Future<void> _fetchCities(int countryId) async {
    setState(() {
      _isLoadingCities = true;
      _selectedCityId = null;
      _cities = [];
    });
    try {
      final response = await _apiService.getCities(countryId, 1, 100);
      final responseData = response.data as Map<String, dynamic>;
      final dataList = responseData['data'] as List<dynamic>?;
      if (dataList != null) {
        setState(() {
          _cities = dataList
              .map((item) => CityModel.fromJson(item as Map<String, dynamic>))
              .toList();
          _isLoadingCities = false;
        });
      } else {
        setState(() => _isLoadingCities = false);
        customToast(msg: 'Failed to load cities');
      }
    } catch (e) {
      setState(() => _isLoadingCities = false);
      customToast(msg: 'Error loading cities');
    }
  }

  void _onCountryChanged(int? countryId) {
    setState(() {
      _selectedCountryId = countryId;
      _selectedCityId = null;
      _cities = [];
    });
    if (countryId != null) {
      _fetchCities(countryId);
    }
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCountryId == null) {
        customToast(msg: AppTranslation.pleaseSelectCountry);
        return;
      }
      if (_selectedCityId == null) {
        customToast(msg: AppTranslation.pleaseSelectCity);
        return;
      }

      context.read<RegisterBloc>().add(
            RegisterSubmitted(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              phone: _phoneController.text.trim(),
              role: _selectedRole!,
              countryId: _selectedCountryId!,
              cityId: _selectedCityId!,
              notificationChannel: _selectedNotificationChannel!,
              address: _addressController.text.trim().isEmpty
                  ? null
                  : _addressController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          customToast(msg: AppTranslation.registerSuccess);
          context.pushNamed(
            Routes.verify,
            arguments: {'email': state.email},
          );
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
            appBar: AppBar(
              backgroundColor: ColorManager.background,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorManager.titlesColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: CustomTextDisplay(
                text: AppTranslation.register,
                fontSize: AppFontSize.s24,
                color: ColorManager.titlesColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppPadding.p24),
                child: RegisterForm(
                  formKey: _formKey,
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  phoneController: _phoneController,
                  addressController: _addressController,
                  selectedRole: _selectedRole,
                  selectedNotificationChannel: _selectedNotificationChannel,
                  selectedCountryId: _selectedCountryId,
                  selectedCityId: _selectedCityId,
                  countries: _countries,
                  cities: _cities,
                  isLoadingCountries: _isLoadingCountries,
                  isLoadingCities: _isLoadingCities,
                  onCountryChanged: _onCountryChanged,
                  onCityChanged: (cityId) => setState(() => _selectedCityId = cityId),
                  onRoleChanged: (role) => setState(() => _selectedRole = role),
                  onNotificationChannelChanged: (channel) => setState(() => _selectedNotificationChannel = channel),
                  onRegister: _handleRegister,
                  isLoading: state is RegisterLoading,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

