import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/language_selection_dialog.dart';
import 'package:jeeb_admin/core/presentation/widgets/logout_dialog.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_service.dart';
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart'
    as di;
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:jeeb_admin/core/presentation/maps/google_map_location_picker_page.dart';
import 'package:jeeb_admin/features/auth/profile/presentation/widgets/profile_page_content.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../bloc/profiel/profile_bloc.dart';
import '../../../logout/presentation/bloc/logout_bloc.dart';

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
  late TextEditingController _restaurantNameController;
  bool _isAdminFromStorage = false;
  bool _isMerchantFromStorage = false;
  /// Synced from profile API `type` when role is merchant (RESTAURANT / STORE).
  String _merchantBusinessType = 'RESTAURANT';

  static String _normalizeMerchantType(String? raw) {
    final u = raw?.toUpperCase().trim();
    if (u == 'STORE' || u == 'RESTAURANT') return u!;
    return 'RESTAURANT';
  }

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _restaurantNameController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      context.read<ProfileBloc>().add(const GetProfile());
      final role = await di.sl<StorageService>().getUserRole();
      final r = role?.toLowerCase();
      if (mounted) {
        setState(() {
          _isAdminFromStorage = r == UserRole.admin.name;
          _isMerchantFromStorage = r == UserRole.merchant.name;
        });
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _restaurantNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is LogoutSuccess || s is LogoutError,
      ),
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
          listenWhen: (previous, current) {
            if (current is ProfileError) return previous is! ProfileError;
            return true;
          },
          listener: (context, state) {
            if (state is ProfileLoaded) {
              if (!state.formValuesInitialized) {
                setState(() {
                  _firstNameController.text = state.user.firstName;
                  _lastNameController.text = state.user.lastName;
                  _phoneController.text = state.user.phone;
                  _addressController.text = state.user.address ?? '';
                  _restaurantNameController.text =
                      state.user.restaurantName ?? '';
                  _merchantBusinessType =
                      _normalizeMerchantType(state.user.merchantType);
                });
                context.read<ProfileBloc>().add(const FormValuesInitialized());
              } else if (state.updateSuccess) {
                customToast(msg: AppTranslation.profileUpdatedSuccess);
                if (mounted) {
                  setState(() {
                    _merchantBusinessType =
                        _normalizeMerchantType(state.user.merchantType);
                  });
                }
                context.read<ProfileBloc>().add(const ClearUpdateSuccess());
              }
              if (state.localeToApply != null) {
                context.setLocale(state.localeToApply!);
                customToast(msg: AppTranslation.languageChangedSuccessfully);
                context.read<ProfileBloc>().add(const ClearLocaleToApply());
              }
            } else if (state is ProfileError) {
              customToast(msg: state.message);
            }
          },
          builder: (context, state) {
            final loaded = state is ProfileLoaded ? state : null;
            final isUpdateLoading = loaded?.isUpdating ?? false;
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
                        onPressed: () async {
                          final ok = await showLogoutDialog(context);
                          if (ok == true && mounted) {
                            context.read<LogoutBloc>().add(
                              const LogoutSubmitted(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                body: BlocStateHandler<ProfileBloc, ProfileState>(
                  bloc: context.read<ProfileBloc>(),
                  isLoading: (s) => s is ProfileLoading,
                  isError: (s) => s is ProfileError && loaded == null,
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
                      restaurantNameController: _restaurantNameController,
                      isAdminFromStorage: _isAdminFromStorage,
                      isMerchantFromStorage: _isMerchantFromStorage,
                      merchantBusinessType: _merchantBusinessType,
                      onMerchantBusinessTypeChanged: (v) {
                        setState(() => _merchantBusinessType = v);
                      },
                      onUpdate: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(
                            SaveProfile(
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              phone: _phoneController.text.trim(),
                              address: _addressController.text.trim().isEmpty
                                  ? null
                                  : _addressController.text.trim(),
                              restaurantName: _isMerchantFromStorage
                                  ? _restaurantNameController.text.trim()
                                  : null,
                              merchantType: _isMerchantFromStorage
                                  ? _merchantBusinessType
                                  : null,
                            ),
                          );
                        }
                      },
                      onChangeLanguage: () => _showLanguageDialog(context),
                      onChangePassword: () =>
                          context.pushNamed(Routes.changePassword),
                      onUpdateLocation: () =>
                          _openMapPicker(context, loadedState),
                      onAccountStatusChanged: (v) => context
                          .read<ProfileBloc>()
                          .add(UpdateAccountActive(v)),
                      isUpdateLoading: isUpdateLoading,
                      onPickImage: () => _pickAndUpdateImage(context),
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

  Future<void> _showLanguageDialog(BuildContext context) async {
    final storage = di.sl<StorageService>();
    final current = storage.getAppLanguage();
    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => LanguageSelectionDialog(
        currentLanguage: current.isEmpty ? null : current,
      ),
    );
    if (selected != null && selected != current && mounted) {
      context.read<ProfileBloc>().add(ChangeLanguage(selected));
    }
  }

  Future<void> _pickAndUpdateImage(BuildContext context) async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null && context.mounted) {
      context.read<ProfileBloc>().add(UpdateProfile(imageFile: xFile));
    }
  }

  Future<void> _openMapPicker(
    BuildContext context,
    ProfileLoaded loaded,
  ) async {
    final result = await Navigator.of(context).push<GoogleMapLocationPickResult>(
      MaterialPageRoute(
        builder: (ctx) => GoogleMapLocationPickerPage(
          initialLatitude: loaded.user.currentLat,
          initialLongitude: loaded.user.currentLng,
        ),
      ),
    );
    if (result != null && context.mounted) {
      context.read<ProfileBloc>().add(
        UpdateLocation(latitude: result.latitude, longitude: result.longitude),
      );
    }
  }
}
