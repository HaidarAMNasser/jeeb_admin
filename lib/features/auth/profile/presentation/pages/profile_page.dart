import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/language_selection_dialog.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_service.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart'
    as di;
import 'package:jeeb_admin/core/common/classes/user_roles.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/profile_bloc.dart';
import '../../../logout/presentation/bloc/logout_bloc.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_form.dart';
import '../pages/location_map_picker_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';

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
  /// Set true when we dispatch UpdateProfile; only then show "profile updated" toast.
  bool _pendingUpdateSuccess = false;
  /// From storage: only show location/account status for merchant, not admin.
  bool _isMerchant = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _loadStoredRole();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileBloc>().add(const GetProfile());
      }
    });
  }

  Future<void> _loadStoredRole() async {
    final role = await di.sl<StorageService>().getUserRole();
    if (!mounted) return;
    setState(() => _isMerchant = role == UserRoles.merchant.name);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
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
          UpdateProfile(
            latitude: latitude,
            longitude: longitude,
          ),
        );
  }

  void _handleActiveChanged(bool isActive) {
    _pendingUpdateSuccess = true;
    context.read<ProfileBloc>().add(UpdateProfile(isActive: isActive));
  }

  void _handleLogout() {
    context.read<LogoutBloc>().add(const LogoutSubmitted());
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
    if (result != null && mounted) {
      _handleLocationPicked(result.latitude, result.longitude);
    }
  }

  Future<void> _showAccountStatusDialog(UserEntity user) async {
    final isActive = user.isActive ?? true;
    final newValue = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r20),
        ),
        child: Container(
          padding: EdgeInsets.all(AppPadding.p24),
          decoration: BoxDecoration(
            color: ColorManager.background,
            borderRadius: BorderRadius.circular(AppRadius.r20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomText(
                text: AppTranslation.accountStatus,
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s18,
                  color: ColorManager.titlesColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppHeight.s24),
              _AccountStatusOption(
                label: AppTranslation.accountActive,
                isSelected: isActive,
                onTap: () => Navigator.of(context).pop(true),
              ),
              SizedBox(height: AppHeight.s16),
              _AccountStatusOption(
                label: AppTranslation.accountInactive,
                isSelected: !isActive,
                onTap: () => Navigator.of(context).pop(false),
              ),
              SizedBox(height: AppHeight.s24),
              CustomButton(
                text: AppTranslation.close,
                onPressed: () => Navigator.of(context).pop(),
                isOutlined: true,
                color: ColorManager.primary,
              ),
            ],
          ),
        ),
      ),
    );
    if (newValue != null && mounted) {
      _handleActiveChanged(newValue);
    }
  }

  void _initFormValuesFromUser(UserEntity user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _phoneController.text = user.phone;
    _addressController.text = user.address ?? '';
  }

  Future<void> _handleChangeLanguage() async {
    final storageService = di.sl<StorageService>();
    final currentLanguage = storageService.getAppLanguage();

    final selectedLanguage = await showDialog<String>(
      context: context,
      builder: (context) => LanguageSelectionDialog(
        currentLanguage: currentLanguage.isEmpty ? null : currentLanguage,
      ),
    );

    if (selectedLanguage != null &&
        selectedLanguage != currentLanguage &&
        mounted) {
      await storageService.setAppLanguage(selectedLanguage);

      if (!context.mounted) return;
      await context.setLocale(Locale(selectedLanguage));

      if (!context.mounted) return;
      customToast(msg: AppTranslation.languageChangedSuccessfully);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
      listener: (context, logoutState) {
        if (logoutState is LogoutSuccess) {
          customToast(msg: AppTranslation.logoutSuccess);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService().pushNamedAndRemoveUntil(Routes.login);
          });
        } else if (logoutState is LogoutError) {
          customToast(msg: logoutState.message);
        }
      },
      builder: (context, logoutState) {
        return BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              if (!_isProfileLoaded) {
                _initFormValuesFromUser(state.user);
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
            final showProgressHUD = isUpdateLoading || isLogoutLoading;

            return ModalProgressHUD(
              progressIndicator: const CustomCircleIndicator(),
              inAsyncCall: showProgressHUD,
              child: Scaffold(
                backgroundColor: ColorManager.background,
                appBar: CustomAppBar(title: AppTranslation.profile),
                body: BlocStateHandler<ProfileBloc, ProfileState>(
                  bloc: context.read<ProfileBloc>(),
                  isLoading: (s) => s is ProfileLoading && !_isProfileLoaded,
                  isError: (s) => s is ProfileError && !_isProfileLoaded,
                  getErrorMessage: (s) => (s as ProfileError).message,
                  isSuccess: (s) => s is ProfileLoaded,
                  getRetryCallback: (_) => () {
                    context.read<ProfileBloc>().add(const GetProfile());
                  },
                  successBuilder: (context, profileState) {
                    final loadedState = profileState as ProfileLoaded;
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(AppPadding.p24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProfileHeader(user: loadedState.user),
                          SizedBox(height: AppHeight.s32),
                          ProfileForm(
                            formKey: _formKey,
                            user: loadedState.user,
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            phoneController: _phoneController,
                            addressController: _addressController,
                            onUpdate: _handleUpdateProfile,
                            isLoading: isUpdateLoading,
                            onChangeLanguage: _handleChangeLanguage,
                          ),
                          SizedBox(height: AppHeight.s24),
                          if (_isMerchant) ...[
                            CustomButton(
                              text: AppTranslation.updateLocation,
                              onPressed: () => _openMapPicker(loadedState.user),
                              isLoading: false,
                              color: ColorManager.primary,
                              isOutlined: true,
                            ),
                            SizedBox(height: AppHeight.s16),
                            CustomButton(
                              text: AppTranslation.accountStatus,
                              onPressed: () => _showAccountStatusDialog(loadedState.user),
                              isLoading: false,
                              color: ColorManager.primary,
                              isOutlined: true,
                            ),
                            SizedBox(height: AppHeight.s24),
                          ],
                          SizedBox(height: AppHeight.s24),
                          CustomButton(
                            text: AppTranslation.changeLanguage,
                            onPressed: _handleChangeLanguage,
                            isLoading: false,
                            color: ColorManager.primary,
                            isOutlined: true,
                          ),
                          SizedBox(height: AppHeight.s16),
                          CustomButton(
                            text: AppTranslation.logout,
                            onPressed: _handleLogout,
                            isLoading: isLogoutLoading,
                            color: ColorManager.error,
                          ),
                        ],
                      ),
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

class _AccountStatusOption extends StatelessWidget {
  const _AccountStatusOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: Container(
        padding: EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primary.withOpacity(0.1)
              : ColorManager.background,
          border: Border.all(
            color: isSelected
                ? ColorManager.primary
                : ColorManager.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: label,
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s18,
                  color: isSelected
                      ? ColorManager.primary
                      : ColorManager.titlesColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: ColorManager.primary,
                size: AppSize.s24,
              ),
          ],
        ),
      ),
    );
  }
}
