import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/location_permission_helper.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/auth/register/data/helpful_functions/register_form_validate.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import '../bloc/register_bloc.dart';
import '../widgets/register_form.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  /// On Register tap: validate form, call register API, then navigate to verify on success.
  Future<void> _onRegisterTapped(BuildContext context) async {
    final bloc = context.read<RegisterBloc>();

    registerValidationToast(
      firstName: bloc.firstNameController.text.trim(),
      lastName: bloc.lastNameController.text.trim(),
      email: bloc.emailController.text.trim(),
      phone: bloc.phoneController.text.trim(),
      password: bloc.passwordController.text.trim(),
      address: bloc.addressController.text.trim(),
      restaurantName: bloc.restaurantNameController.text.trim(),
      latitude: bloc.useLocationLat,
      longitude: bloc.useLocationLng,
      countryId: bloc.selectedCountry?.id,
      cityId: bloc.selectedCity?.id,
    );

    if (!isRegisterFormValid(
      firstName: bloc.firstNameController.text.trim(),
      lastName: bloc.lastNameController.text.trim(),
      email: bloc.emailController.text.trim(),
      phone: bloc.phoneController.text.trim(),
      password: bloc.passwordController.text.trim(),
      address: bloc.addressController.text.trim(),
      restaurantName: bloc.restaurantNameController.text.trim(),
      latitude: bloc.useLocationLat,
      longitude: bloc.useLocationLng,
      countryId: bloc.selectedCountry?.id,
      cityId: bloc.selectedCity?.id,
    )) {
      return;
    }

    bloc.add(const RegisterSubmitted());
  }

  Future<void> _onUseMyLocation(BuildContext context) async {
    final bloc = context.read<RegisterBloc>();

    bloc.add(const RegisterLocationLoadingChanged(true));
    try {
      final position = await LocationPermissionHelper.requestAndGetPosition();
      if (!context.mounted) return;

      if (position != null) {
        bloc.add(
          RegisterLocationUpdated(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
        return;
      }

      customToast(msg: AppTranslation.locationPermissionDenied);
    } finally {
      // Always clear loading so the row stays tappable after deny, error, or
      // if the widget unmounted during await (bloc still needs a consistent state).
      bloc.add(const RegisterLocationLoadingChanged(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is RegisterSuccess || s is RegisterError,
      ),
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.pushNamed(
            Routes.verify,
            arguments: {'email': state.email, 'password': state.password},
          );
        } else if (state is RegisterError) {
          customToast(msg: state.message);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          progressIndicator: const CustomCircleIndicator(),
          inAsyncCall: state is RegisterLoading,
          child: 
        
        Scaffold(
        backgroundColor: ColorManager.background,
        appBar: CustomAppBar(title: AppTranslation.register),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppPadding.p24),
            child: RegisterForm(
              onRegister: () => _onRegisterTapped(context),
              onUseMyLocation: () => _onUseMyLocation(context),
            ),
          ),
          ),)
        );
      },
    );
  }
}
