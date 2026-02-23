import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/bloc/create_product_bloc.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/widgets/product_images_section.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/widgets/product_form_fields.dart';
import 'package:jeeb_admin/features/product/update_product/presentation/bloc/update_product_bloc.dart';
import 'package:jeeb_admin/features/product/create_product/helpful_functions/product_validation.dart';

class CreateProductPage extends StatefulWidget {
  final ProductEntity? product; // null for create, ProductEntity for edit

  const CreateProductPage({
    super.key,
    this.product,
  });

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  @override
  void initState() {
    super.initState();
    // Only initialize in edit mode (when product is provided)
    if (widget.product != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<CreateProductBloc>().add(
                InitializeProductForm(product: widget.product),
              );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        title: CustomText(
          text: isEdit ? AppTranslation.editProduct : AppTranslation.addProduct,
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s24,
            color: ColorManager.titlesColor,
          ),
        ),
      ),
      body: isEdit
          ? _buildEditView()
          : _buildCreateView(),
    );
  }

  Widget _buildCreateView() {
    return BlocListener<CreateProductBloc, CreateProductState>(
      listener: (context, state) {
        if (state is CreateProductSuccess) {
          Navigator.pop(context, true);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(text: state.errorMessage!),
              backgroundColor: ColorManager.error,
            ),
          );
        }
      },
      child: BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (context, state) {
          final bloc = context.read<CreateProductBloc>();
          return _buildForm(bloc: bloc, state: state, isEdit: false);
        },
      ),
    );
  }

  Widget _buildEditView() {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateProductBloc, CreateProductState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: CustomText(text: state.errorMessage!),
                  backgroundColor: ColorManager.error,
                ),
              );
            }
          },
        ),
        BlocListener<UpdateProductBloc, UpdateProductState>(
          listener: (context, state) {
            if (state is UpdateProductSuccess) {
              Navigator.pop(context, true);
            } else if (state is UpdateProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: CustomText(text: state.message),
                  backgroundColor: ColorManager.error,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<CreateProductBloc, CreateProductState>(
        builder: (context, state) {
          final createBloc = context.read<CreateProductBloc>();
          final updateBloc = context.read<UpdateProductBloc>();
          return _buildForm(
            bloc: createBloc,
            updateBloc: updateBloc,
            state: state,
            isEdit: true,
          );
        },
      ),
    );
  }

  Widget _buildForm({
    required CreateProductBloc bloc,
    required CreateProductState state,
    required bool isEdit,
    UpdateProductBloc? updateBloc,
  }) {
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
                final isLoading = isEdit
                    ? updateState is UpdateProductLoading
                    : state.isLoading;
                final isValid = state.isValid;
                return CustomButton(
                  text: isEdit ? AppTranslation.save : AppTranslation.addProduct,
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
                    
                    if (isEdit && updateBloc != null) {
                      // Use UpdateProductBloc to call update API
                      updateBloc.add(UpdateProductSubmitted(
                        id: state.productId!,
                        name: bloc.nameController.text.trim(),
                        description: bloc.descriptionController.text.trim().isEmpty
                            ? null
                            : bloc.descriptionController.text.trim(),
                        price: double.tryParse(bloc.priceController.text.trim()) ?? 0.0,
                        categoryId: state.selectedCategoryId ?? '',
                        quantity: bloc.quantityController.text.trim().isEmpty
                            ? null
                            : int.tryParse(bloc.quantityController.text.trim()),
                        images: state.images,
                      ));
                    } else {
                      // Use CreateProductBloc to call create API
                      bloc.add(const CreateProductSubmitted());
                    }
                  },
                  isLoading: isLoading,
                  color: isValid ? ColorManager.primary : ColorManager.closeDialogColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

