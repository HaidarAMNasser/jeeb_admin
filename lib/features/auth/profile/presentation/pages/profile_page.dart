import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/language_selection_dialog.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_service.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../login/domain/entities/user_entity.dart';
import '../../../logout/presentation/bloc/logout_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../helpers/profile_state_helper.dart';
import '../widgets/profile_page_content.dart';

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
  bool _wasUpdating = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileBloc>().add(const GetProfile());
      }
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

  void _onUpdateProfile() {
    if (_formKey.currentState!.validate()) {
      _wasUpdating = true;
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

  void _onLogout() {
    context.read<LogoutBloc>().add(const LogoutSubmitted());
  }

  void _initFormValuesFromUser(UserEntity user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _phoneController.text = user.phone;
    _addressController.text = user.address ?? '';
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

    if (selectedLanguage != null &&
        selectedLanguage != currentLanguage &&
        mounted) {
      await storageService.setAppLanguage(selectedLanguage);
      await context.setLocale(Locale(selectedLanguage));
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
        final isLogoutLoading = logoutState is LogoutLoading;

        return BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              if (!state.formValuesInitialized) {
                _initFormValuesFromUser(state.user);
                context.read<ProfileBloc>().add(const FormValuesInitialized());
              } else if (_wasUpdating) {
                customToast(msg: AppTranslation.profileUpdatedSuccess);
                _wasUpdating = false;
              }
              _isProfileLoaded = true;
            } else if (state is ProfileError) {
              customToast(msg: state.message);
            }
          },
          builder: (context, state) {
            final isUpdateLoading =
                state is ProfileLoading && _isProfileLoaded;
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
                    final user = getProfileUserFromState(profileState);
                    if (user == null) return const SizedBox.shrink();

                    return ProfilePageContent(
                      user: user,
                      formKey: _formKey,
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      phoneController: _phoneController,
                      addressController: _addressController,
                      onUpdate: _onUpdateProfile,
                      isUpdateLoading: isUpdateLoading,
                      onChangeLanguage: () => _onChangeLanguage(),
                      onLogout: _onLogout,
                      isLogoutLoading: isLogoutLoading,
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
