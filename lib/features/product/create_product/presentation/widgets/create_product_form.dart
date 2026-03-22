import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/bloc/create_product_bloc.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/widgets/product_images_section.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/widgets/product_form_fields.dart';
import 'package:jeeb_admin/features/product/update_product/presentation/bloc/update_product_bloc.dart';
import 'package:jeeb_admin/features/product/create_product/helpful_functions/product_validation.dart';

class CreateProductForm extends StatelessWidget {
  final CreateProductBloc bloc;
  final CreateProductState state;
  final bool isEdit;

  const CreateProductForm({
    super.key,
    required this.bloc,
    required this.state,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Form(
        key: bloc.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductFormFields(bloc: bloc),
            SizedBox(height: AppHeight.s24),
            ProductImagesSection(bloc: bloc),
            SizedBox(height: AppHeight.s32),
            BlocBuilder<UpdateProductBloc, UpdateProductState>(
              builder: (context, updateState) {
                final isValid = state.isValid;
                return CustomButton(
                  text: isEdit
                      ? AppTranslation.save
                      : AppTranslation.addProduct,
                  onPressed: () {
                    // Show validation toast if form is invalid
                    productValidationToast(
                      name: bloc.nameController.text.trim(),
                      price: bloc.priceController.text.trim(),
                      categoryId: state.selectedCategoryId,
                      images: state.images,
                    );

                    // Only proceed if form is valid
                    if (!isValid) {
                      return;
                    }

                    if (isEdit) {
                      // Use UpdateProductBloc to call update API
                      context.read<UpdateProductBloc>().add(
                        UpdateProductSubmitted(
                          id: state.productId!,
                          name: bloc.nameController.text.trim(),
                          description:
                              bloc.descriptionController.text.trim().isEmpty
                              ? null
                              : bloc.descriptionController.text.trim(),
                          price:
                              double.tryParse(
                                bloc.priceController.text.trim(),
                              ) ??
                              0.0,
                          categoryId: state.selectedCategoryId ?? '',
                          quantity: bloc.quantityController.text.trim().isEmpty
                              ? null
                              : int.tryParse(
                                  bloc.quantityController.text.trim(),
                                ),
                          servesCount: bloc.servesCountController.text.trim().isEmpty
                              ? null
                              : int.tryParse(
                                  bloc.servesCountController.text.trim(),
                                ),
                          images: state.images,
                        ),
                      );
                    } else {
                      // Use CreateProductBloc to call create API
                      bloc.add(const CreateProductSubmitted());
                    }
                  },
                  isLoading: false, // ModalProgressHUD handles loading overlay
                  color: isValid
                      ? ColorManager.primary
                      : ColorManager.closeDialogColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}