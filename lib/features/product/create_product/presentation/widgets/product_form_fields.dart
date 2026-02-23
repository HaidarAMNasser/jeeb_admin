import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/bloc/create_product_bloc.dart';
import 'package:jeeb_admin/features/category/list_category/domain/entities/category_entity.dart';

class ProductFormFields extends StatelessWidget {
  final CreateProductBloc bloc;
  final List<CategoryEntity>? categories; // Will be loaded from BLoC or API

  const ProductFormFields({
    super.key,
    required this.bloc,
    this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
      builder: (context, state) {
        return _buildFields(bloc: bloc, state: state);
      },
    );
  }

  Widget _buildFields({required CreateProductBloc bloc, required CreateProductState state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Product Name
        CustomTextField(
          title: AppTranslation.productName,
          hintText: AppTranslation.productName,
          controller: bloc.nameController,
          onChanged: (value) {
            bloc.add(UpdateProductName(name: value));
          },
        ),
        SizedBox(height: AppHeight.s16),

        // Product Description
        CustomTextField(
          title: AppTranslation.productDescription,
          hintText: AppTranslation.productDescription,
          controller: bloc.descriptionController,
          onChanged: (value) {
            bloc.add(UpdateProductDescription(description: value));
          },
        ),
        SizedBox(height: AppHeight.s16),

        // Product Price
        CustomTextField(
          title: AppTranslation.productPrice,
          hintText: AppTranslation.productPrice,
          controller: bloc.priceController,
          onChanged: (value) {
            bloc.add(UpdateProductPrice(price: value));
          },
        ),
        SizedBox(height: AppHeight.s16),

        // Product Quantity
        CustomTextField(
          title: AppTranslation.productQuantity,
          hintText: AppTranslation.productQuantity,
          controller: bloc.quantityController,
          onChanged: (value) {
            bloc.add(UpdateProductQuantity(quantity: value));
          },
        ),
        SizedBox(height: AppHeight.s16),

        // Category Dropdown
        CustomText(
          text: AppTranslation.selectCategory,
          textStyle: getSemiBoldStyle(
            fontSize: AppFontSize.s16,
            color: ColorManager.defaultWhite,
          ),
        ),
        SizedBox(height: AppHeight.s8),
        DropdownButtonFormField<String>(
          value: state.selectedCategoryId,
          decoration: InputDecoration(
            hintText: AppTranslation.selectCategory,
            hintStyle: getRegularStyle(
              color: ColorManager.descriptionColor,
              fontSize: AppFontSize.s13,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppPadding.p16,
              vertical: AppHeight.s16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r18),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r18),
              borderSide: BorderSide(color: ColorManager.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r18),
              borderSide: BorderSide(color: ColorManager.borderColor),
            ),
            filled: true,
            fillColor: ColorManager.defaultWhite,
          ),
          dropdownColor: ColorManager.defaultWhite,
          style: getRegularStyle(
            fontSize: AppFontSize.s14,
            color: ColorManager.productNameColor,
          ),
          items: _getMockCategories().map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: CustomText(
                text: category.name,
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.productNameColor,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            bloc.add(UpdateSelectedCategory(categoryId: value));
          },
        ),
      ],
    );
  }

  // Mock categories for UI only
  List<CategoryEntity> _getMockCategories() {
    return [
      const CategoryEntity(id: '1', name: 'Fast Food'),
      const CategoryEntity(id: '2', name: 'Beverages'),
      const CategoryEntity(id: '3', name: 'Desserts'),
      const CategoryEntity(id: '4', name: 'Salads'),
      const CategoryEntity(id: '5', name: 'Main Dishes'),
    ];
  }
}

