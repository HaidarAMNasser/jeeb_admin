import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/auth/register/presentation/widgets/location_source_selector.dart';
import 'package:jeeb_admin/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:jeeb_admin/features/country/presentation/widgets/country_city_widget.dart';

class RegisterForm extends StatelessWidget {
  final VoidCallback onRegister;
  final Future<void> Function() onUseMyLocation;

  const RegisterForm({
    super.key,
    required this.onRegister,
    required this.onUseMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();

    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Form(
          key: bloc.formKey,
          child: Column(
            spacing: AppHeight.s24,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                title: AppTranslation.firstName,
                hintText: AppTranslation.firstName,
                controller: bloc.firstNameController,
              ),
              CustomTextField(
                title: AppTranslation.lastName,
                hintText: AppTranslation.lastName,
                controller: bloc.lastNameController,
              ),
              CustomTextField(
                title: AppTranslation.email,
                hintText: AppTranslation.enterEmail,
                controller: bloc.emailController,
              ),
              CustomTextField(
                keyboardType: TextInputType.phone,
                title: AppTranslation.phone,
                hintText: AppTranslation.enterPhone,
                controller: bloc.phoneController,
              ),
              CustomTextField(
                obscureText: true,
                title: AppTranslation.password,
                hintText: AppTranslation.enterPassword,
                controller: bloc.passwordController,
              ),
              CustomTextField(
                title: AppTranslation.address,
                hintText: AppTranslation.enterAddress,
                controller: bloc.addressController,
              ),
              CustomTextField(
                title: AppTranslation.restaurantName,
                hintText: AppTranslation.enterRestaurantName,
                controller: bloc.restaurantNameController,
              ),
              if (bloc.selectedRole == 'MERCHANT') ...[
                SizedBox(height: AppHeight.s4),
                CustomText(
                  text: AppTranslation.merchantBusinessType,
                  textStyle: getMediumStyle(
                    color: ColorManager.textColor,
                    fontSize: AppFontSize.s14,
                  ),
                ),
                SizedBox(height: AppHeight.s8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 340;
                    Widget tile(String value, String label) {
                      final selected = state.merchantBusinessType == value;
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => bloc.add(RegisterMerchantTypeChanged(value)),
                          borderRadius: BorderRadius.circular(8.r),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              vertical: 14.h,
                              horizontal: 12.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: selected
                                    ? ColorManager.primary
                                    : ColorManager.borderColor,
                                width: selected ? 2 : 1,
                              ),
                              color: selected
                                  ? ColorManager.primary.withValues(alpha: 0.08)
                                  : ColorManager.surface,
                            ),
                            child: Center(
                              child: CustomText(
                                text: label,
                                textStyle: getMediumStyle(
                                  color: selected
                                      ? ColorManager.primary
                                      : ColorManager.textColor,
                                  fontSize: AppFontSize.s14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (narrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          tile('RESTAURANT', AppTranslation.merchantTypeRestaurant),
                          SizedBox(height: 12.h),
                          tile('STORE', AppTranslation.merchantTypeMarket),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: tile(
                            'RESTAURANT',
                            AppTranslation.merchantTypeRestaurant,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: tile(
                            'STORE',
                            AppTranslation.merchantTypeMarket,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
              LocationSourceSelector(
                title: AppTranslation.location,
                useMyLocationHint: AppTranslation.useMyLocation,
                locationSetHint: AppTranslation.locationSetFormat,
                latitude: state.useLocationLat,
                longitude: state.useLocationLng,
                isRequired: true,
                onUseMyLocation: onUseMyLocation,
                onClearLocation:
                    (state.useLocationLat != null || state.useLocationLng != null)
                        ? () => bloc.add(const RegisterLocationCleared())
                        : null,
                isLoading: state.isLocationLoading,
              ),
              CountryCityWidget(
                selectedCountry: state.selectedCountry,
                selectedCity: state.selectedCity,
                onSelectCountry: (country) {
                  bloc.add(RegisterCountryChanged(country));
                },
                onSelectCity: (city) {
                  bloc.add(RegisterCityChanged(city));
                },
                isRequired: true,
                isReadOnly: false,
              ),
              CustomButton(
                text: AppTranslation.register,
                onPressed: onRegister,
                color: ColorManager.primary,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: AppTranslation.alreadyHaveAccount,
                    textStyle: getRegularStyle(
                      fontSize: AppFontSize.s14,
                      color: ColorManager.textColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(Routes.login);
                    },
                    child: CustomText(
                      text: AppTranslation.login,
                      textStyle: getMediumStyle(
                        fontSize: AppFontSize.s14,
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
