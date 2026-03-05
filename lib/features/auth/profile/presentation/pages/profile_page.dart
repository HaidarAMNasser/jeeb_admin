import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/language_selection_dialog.dart';
import 'package:jeeb_admin/core/presentation/widgets/logout_dialog.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_service.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart'
    as di;
import 'package:jeeb_admin/core/common/classes/user_roles.dart';
import 'package:jeeb_admin/features/auth/profile/presentation/widgets/location_map_picker_page.dart';
import 'package:jeeb_admin/features/auth/profile/presentation/widgets/profile_page_content.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../bloc/profile_bloc.dart';
import '../../../logout/presentation/bloc/logout_bloc.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isProfileLoaded = false;
  bool _pendingUpdateSuccess = false;
  bool _isMerchant = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _loadUserRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileBloc>().add(const GetProfile());
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserRole() async {
    final role = await di.sl<StorageService>().getUserRole();
    if (!mounted) return;
    setState(() => _isMerchant = role == UserRoles.merchant.name);
  }

  void _handleUpdateProfile() {
    if (_formKey.currentState!.validate()) {
      _pendingUpdateSuccess = true;
      context.read<ProfileBloc>().add(
        UpdateProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
        ),
      );
    }
  }

  void _handleLocationPicked(double latitude, double longitude) {
    _pendingUpdateSuccess = true;
    context.read<ProfileBloc>().add(
      UpdateProfile(latitude: latitude, longitude: longitude),
    );
  }

  void _handleActiveChanged(bool isActive) {
    _pendingUpdateSuccess = true;
    context.read<ProfileBloc>().add(UpdateProfile(isActive: isActive));
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showLogoutDialog(context);
    if (shouldLogout == true && mounted) {
      context.read<LogoutBloc>().add(const LogoutSubmitted());
    }
  }

  Future<void> _openMapPicker(UserEntity user) async {
    final result = await Navigator.of(context).push<LocationMapPickerResult>(
      MaterialPageRoute(
        builder: (context) => LocationMapPickerPage(
          initialLatitude: user.currentLat,
          initialLongitude: user.currentLng,
        ),
      ),
    );
    if (result != null && mounted)
      _handleLocationPicked(result.latitude, result.longitude);
  }

  Future<void> _onChangeLanguage() async {
    final storageService = di.sl<StorageService>();
    final currentLanguage = storageService.getAppLanguage();
    final selectedLanguage = await showDialog<String>(
      context: context,
      builder: (context) => LanguageSelectionDialog(
        currentLanguage: currentLanguage.isEmpty ? null : currentLanguage,
      ),
    );
    if (selectedLanguage == null ||
        selectedLanguage == currentLanguage ||
        !mounted)
      return;
    await storageService.setAppLanguage(selectedLanguage);
    if (!context.mounted) return;
    await context.setLocale(Locale(selectedLanguage));
    if (!context.mounted) return;
    customToast(msg: AppTranslation.languageChangedSuccessfully);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
      listener: (context, logoutState) {
        if (logoutState is LogoutSuccess) {
          customToast(msg: AppTranslation.logoutSuccess);
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => NavigationService().pushNamedAndRemoveUntil(Routes.login),
          );
        } else if (logoutState is LogoutError) {
          customToast(msg: logoutState.message);
        }
      },
      builder: (context, logoutState) {
        return BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              if (!_isProfileLoaded) {
                _firstNameController.text = state.user.firstName;
                _lastNameController.text = state.user.lastName;
                _phoneController.text = state.user.phone;
                _addressController.text = state.user.address ?? '';
                _isProfileLoaded = true;
              } else if (_pendingUpdateSuccess) {
                _pendingUpdateSuccess = false;
                customToast(msg: AppTranslation.profileUpdatedSuccess);
              }
            } else if (state is ProfileError) {
              customToast(msg: state.message);
            }
          },
          builder: (context, state) {
            final isUpdateLoading = state is ProfileLoading && _isProfileLoaded;
            final isLogoutLoading = logoutState is LogoutLoading;
            return ModalProgressHUD(
              progressIndicator: const CustomCircleIndicator(),
              inAsyncCall: isUpdateLoading || isLogoutLoading,
              child: Scaffold(
                backgroundColor: ColorManager.background,
                appBar: CustomAppBar(
                  title: AppTranslation.profile,
                  actions: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppPadding.p10),
                      child: IconButton(
                        icon: const Icon(Icons.logout),
                        color: ColorManager.defaultWhite,
                        onPressed: _handleLogout,
                      ),
                    ),
                  ],
                ),
                body: BlocStateHandler<ProfileBloc, ProfileState>(
                  bloc: context.read<ProfileBloc>(),
                  isLoading: (s) => s is ProfileLoading && !_isProfileLoaded,
                  isError: (s) => s is ProfileError && !_isProfileLoaded,
                  getErrorMessage: (s) => (s as ProfileError).message,
                  isSuccess: (s) => s is ProfileLoaded,
                  getRetryCallback: (_) =>
                      () => context.read<ProfileBloc>().add(const GetProfile()),
                  successBuilder: (context, profileState) {
                    final loadedState = profileState as ProfileLoaded;
                    return ProfilePageContent(
                      user: loadedState.user,
                      formKey: _formKey,
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      phoneController: _phoneController,
                      addressController: _addressController,
                      isMerchant: _isMerchant,
                      onUpdate: _handleUpdateProfile,
                      onChangeLanguage: _onChangeLanguage,
                      onUpdateLocation: () => _openMapPicker(loadedState.user),
                      onAccountStatusChanged: _handleActiveChanged,
                      isUpdateLoading: isUpdateLoading,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
