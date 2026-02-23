import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/bloc/create_product_bloc.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/widgets/create_product_form.dart';
import 'package:jeeb_admin/features/product/update_product/presentation/bloc/update_product_bloc.dart';
import 'package:jeeb_admin/features/product/delete_product/presentation/bloc/delete_product_bloc.dart';
import 'package:jeeb_admin/features/product/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateProductPage extends StatefulWidget {
  final ProductEntity? product; // null for create, ProductEntity for edit

  const CreateProductPage({super.key, this.product});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  @override
  void initState() {
    super.initState();
    // In edit mode, fetch product details from API
    if (widget.product != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ProductDetailsBloc>().add(
            GetProductDetailsEvent(id: widget.product!.id),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return BlocConsumer<DeleteProductBloc, DeleteProductState>(
      listener: (context, deleteState) {
        if (deleteState is DeleteProductSuccess) {
          customToast(msg: AppTranslation.productDeletedSuccessfully);
          context.pushNamed(Routes.products);
        } else if (deleteState is DeleteProductError) {
          customToast(msg: deleteState.message);
        }
      },
      builder: (context, deleteState) {
        return BlocConsumer<UpdateProductBloc, UpdateProductState>(
          listener: (context, updateState) {
            if (updateState is UpdateProductSuccess) {
              customToast(msg: AppTranslation.productUpdatedSuccessfully);
              context.pushNamed(Routes.products);
            } else if (updateState is UpdateProductError) {
              customToast(msg: updateState.message);
            }
          },
          builder: (context, updateState) {
            return BlocConsumer<CreateProductBloc, CreateProductState>(
              listener: (context, createState) {
                if (createState is CreateProductSuccess) {
                  customToast(msg: AppTranslation.productCreatedSuccessfully);
                  context.pushNamed(Routes.products);
                } else if (createState is CreateProductError) {
                  customToast(msg: createState.message);
                }
              },
              builder: (context, createState) {
                return BlocBuilder<DeleteProductBloc, DeleteProductState>(
                  builder: (context, deleteStateBuilder) {
                    return ModalProgressHUD(
                      progressIndicator: const CustomCircleIndicator(),
                      inAsyncCall:
                          createState is CreateProductLoading ||
                          updateState is UpdateProductLoading ||
                          deleteStateBuilder is DeleteProductLoading,
                      child: Scaffold(
                        backgroundColor: ColorManager.background,
                        appBar: CustomAppBar(
                          title: isEdit
                              ? AppTranslation.editProduct
                              : AppTranslation.addProduct,
                          actions: isEdit
                              ? [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: ColorManager.primary,
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                        context,
                                        title: AppTranslation
                                            .areYouSureWantToDeleteThisProduct,
                                      );
                                    },
                                  ),
                                ]
                              : null,
                        ),
                        body: isEdit
                            ? BlocStateHandler<
                                ProductDetailsBloc,
                                ProductDetailsState
                              >(
                                bloc: context.read<ProductDetailsBloc>(),
                                isLoading: (state) =>
                                    state is ProductDetailsLoading,
                                isError: (state) =>
                                    state is ProductDetailsError,
                                getErrorMessage: (state) =>
                                    (state as ProductDetailsError).message,
                                isSuccess: (state) =>
                                    state is ProductDetailsLoaded,
                                getRetryCallback: (state) => () {
                                  context.read<ProductDetailsBloc>().add(
                                    GetProductDetailsEvent(
                                      id: widget.product!.id,
                                    ),
                                  );
                                },
                                successBuilder: (context, productDetailsState) {
                                  final loadedState =
                                      productDetailsState
                                          as ProductDetailsLoaded;
                                  // Initialize form with fetched product data
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (mounted) {
                                      context.read<CreateProductBloc>().add(
                                        InitializeProductForm(
                                          product: loadedState.product,
                                        ),
                                      );
                                    }
                                  });
                                  return CreateProductForm(
                                    bloc: context.read<CreateProductBloc>(),
                                    state: createState,
                                    isEdit: true,
                                  );
                                },
                              )
                            : _buildCreateView(),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context, {
    required String title,
  }) {
    ConfirmationDialog.show(
      context: context,
      title: title,
      onConfirm: () {
        if (widget.product != null) {
          context.read<DeleteProductBloc>().add(
            DeleteProductSubmitted(productId: widget.product!.id),
          );
        }
      },
      confirmText: AppTranslation.delete,
      confirmColor: ColorManager.primary,
    );
  }

  Widget _buildCreateView() {
    return BlocBuilder<CreateProductBloc, CreateProductState>(
      builder: (context, state) {
        final bloc = context.read<CreateProductBloc>();
        return CreateProductForm(bloc: bloc, state: state, isEdit: false);
      },
    );
  }
}
