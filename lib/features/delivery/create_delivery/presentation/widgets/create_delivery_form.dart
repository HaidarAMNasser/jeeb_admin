import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/presentation/bloc/create_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/update_delivery/presentation/bloc/update_delivery_bloc.dart';
import 'package:jeeb_admin/features/delivery/create_delivery/helpful_functions/delivery_validation.dart';

class CreateDeliveryForm extends StatelessWidget {
  final bool isEdit;
  final String? deliveryManId;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const CreateDeliveryForm({
    super.key,
    required this.isEdit,
    this.deliveryManId,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: firstNameController,
              title: AppTranslation.firstName,
              hintText: AppTranslation.enterFirstName,
            ),
            SizedBox(height: AppHeight.s16),
            CustomTextField(
              controller: lastNameController,
              title: AppTranslation.lastName,
              hintText: AppTranslation.enterLastName,
            ),
            SizedBox(height: AppHeight.s16),
            CustomTextField(
              controller: phoneController,
              title: AppTranslation.phone,
              hintText: AppTranslation.enterPhone,
            ),
            SizedBox(height: AppHeight.s16),
            CustomTextField(
              controller: emailController,
              title: AppTranslation.email,
              hintText: AppTranslation.enterEmail,
            ),
            if (!isEdit) ...[
              SizedBox(height: AppHeight.s16),
              CustomTextField(
                controller: passwordController,
                title: AppTranslation.password,
                hintText: AppTranslation.enterPassword,
                obscureText: true,
              ),
            ],
            SizedBox(height: AppHeight.s24),
            CustomButton(
              text: isEdit ? AppTranslation.save : AppTranslation.addDeliveryMan,
              onPressed: () {
                // Show validation toast if form is invalid
                deliveryValidationToast(
                  firstName: firstNameController.text.trim(),
                  lastName: lastNameController.text.trim(),
                  phone: phoneController.text.trim(),
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  isEditMode: isEdit,
                );

                // Only proceed if form is valid
                if (!isDeliveryFormValid(
                  firstName: firstNameController.text.trim(),
                  lastName: lastNameController.text.trim(),
                  phone: phoneController.text.trim(),
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  isEditMode: isEdit,
                )) {
                  return;
                }

                if (isEdit && deliveryManId != null) {
                  context.read<UpdateDeliveryBloc>().add(
                        UpdateDeliverySubmitted(
                          id: deliveryManId!,
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          phone: phoneController.text.trim(),
                          email: emailController.text.trim(),
                        ),
                      );
                } else {
                  context.read<CreateDeliveryBloc>().add(
                        CreateDeliverySubmitted(
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          phone: phoneController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          notificationChannel: 'WHATSAPP', // Default value
                        ),
                      );
                }
              },
              isLoading: false, // ModalProgressHUD handles loading overlay
            ),
          ],
        ),
      ),
    );
  }
}

