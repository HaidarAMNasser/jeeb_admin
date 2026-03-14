import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/bloc/create_product_bloc.dart';
import 'package:jeeb_admin/features/category/list_category/presentation/widgets/category_widget.dart';

class ProductFormFields extends StatelessWidget {
  final CreateProductBloc bloc;

  const ProductFormFields({
    super.key,
    required this.bloc,
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

        // Category (real API)
        CategoryWidget(
          selectedCategoryId: state.selectedCategoryId,
          onSelectCategory: (category) {
            bloc.add(UpdateSelectedCategory(categoryId: category?.id));
          },
          isRequired: true,
        ),
      ],
    );
  }
}

