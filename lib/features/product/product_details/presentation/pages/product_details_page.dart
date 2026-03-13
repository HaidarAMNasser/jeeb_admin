import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:jeeb_admin/core/common/classes/user_roles.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart'
    as di;
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/navigation_extensions.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_input_dialog.dart';

import 'package:jeeb_admin/features/product/confirm_product/presentation/bloc/confirm_product_bloc.dart';
import 'package:jeeb_admin/features/product/delete_product/presentation/bloc/delete_product_bloc.dart';
import 'package:jeeb_admin/features/product/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:jeeb_admin/features/product/product_details/presentation/widgets/product_details_content.dart';
import 'package:jeeb_admin/features/product/product_details/presentation/widgets/product_details_options_dialog.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  final int tabIndexOnBack;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    this.tabIndexOnBack = 0,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    context.read<ProductDetailsBloc>().add(
      GetProductDetailsEvent(id: widget.productId),
    );
  }

  Future<void> _loadUserRole() async {
    final role = await di.sl<StorageService>().getUserRole();
    if (!mounted) return;
    setState(() => _isAdmin = role == UserRoles.admin.name);
  }

  Future<void> _showConfirmDialog(
    BuildContext context,
    ProductDetailsLoaded state,
  ) async {
    final product = state.product;
    final currentPrice = (product.price / 100).toStringAsFixed(2);
    final result = await CustomInputDialog.show(
      context: context,
      title: AppTranslation.confirmProduct,
      label: AppTranslation.newPrice,
      hintText: AppTranslation.enterNewPrice,
      initialValue: currentPrice,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.trim().isEmpty)
          return AppTranslation.pleaseEnterProductPrice;
        final parsed = double.tryParse(value.replaceAll(',', ''));
        if (parsed == null || parsed <= 0)
          return AppTranslation.invalidProductPrice;
        return null;
      },
    );
    if (result == null || result.isEmpty) return;
    context.read<ConfirmProductBloc>().add(
      ConfirmProductSubmitted(
        productId: product.id,
        newPrice: double.parse(result.replaceAll(',', '')),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductDetailsLoaded state) {
    ConfirmationDialog.show(
      context: context,
      title: AppTranslation.areYouSureWantToDeleteThisProduct,
      confirmText: AppTranslation.delete,
      confirmColor: ColorManager.primary,
      onConfirm: () => context.read<DeleteProductBloc>().add(
        DeleteProductSubmitted(productId: state.product.id),
      ),
    );
  }

  void _goToMainWithTab(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.mainNavigation,
      (_) => false,
      arguments: {'tabIndex': widget.tabIndexOnBack},
    );
  }

  void _onEditProduct(BuildContext context, ProductDetailsLoaded state) {
    context.pushReplacementNamed(
      Routes.addProduct,
      arguments: {'product': state.product},
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConfirmProductBloc, ConfirmProductState>(
          listener: (context, state) {
            if (state is ConfirmProductSuccess) {
              customToast(msg: AppTranslation.productConfirmedSuccessfully);
              context.read<ProductDetailsBloc>().add(
                GetProductDetailsEvent(id: widget.productId),
              );
            } else if (state is ConfirmProductError) {
              customToast(msg: state.message);
            }
          },
        ),
        BlocListener<DeleteProductBloc, DeleteProductState>(
          listener: (context, state) {
            if (state is DeleteProductSuccess) {
              customToast(msg: AppTranslation.productDeletedSuccessfully);
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.mainNavigation,
                (_) => false,
                arguments: {'tabIndex': widget.tabIndexOnBack},
              );
            } else if (state is DeleteProductError)
              customToast(msg: state.message);
          },
        ),
      ],
      child: BlocBuilder<DeleteProductBloc, DeleteProductState>(
        builder: (context, deleteState) {
          return BlocBuilder<ConfirmProductBloc, ConfirmProductState>(
            builder: (context, confirmState) {
              return ModalProgressHUD(
                progressIndicator: const CustomCircleIndicator(),
                inAsyncCall:
                    confirmState is ConfirmProductLoading ||
                    deleteState is DeleteProductLoading,
                child: PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) {
                    if (didPop) return;
                    _goToMainWithTab(context);
                  },
                  child: Scaffold(
                    backgroundColor: ColorManager.background,
                    appBar: CustomAppBar(
                      onBackPressed: () => _goToMainWithTab(context),
                      title: AppTranslation.productDetails,
                      actions: [_buildOptionsButton(context)],
                    ),
                    body:
                        BlocStateHandler<
                          ProductDetailsBloc,
                          ProductDetailsState
                        >(
                          bloc: context.read<ProductDetailsBloc>(),
                          isLoading: (state) => state is ProductDetailsLoading,
                          isError: (state) => state is ProductDetailsError,
                          getErrorMessage: (state) =>
                              (state as ProductDetailsError).message,
                          isSuccess: (state) => state is ProductDetailsLoaded,
                          getRetryCallback: (state) =>
                              () => context.read<ProductDetailsBloc>().add(
                                GetProductDetailsEvent(id: widget.productId),
                              ),
                          successBuilder: (context, productState) {
                            final loadedState =
                                productState as ProductDetailsLoaded;
                            return ProductDetailsContent(
                              product: loadedState.product,
                              isAdmin: _isAdmin,
                              onEdit: () =>
                                  _onEditProduct(context, loadedState),
                            );
                          },
                        ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOptionsButton(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        if (state is! ProductDetailsLoaded) return const SizedBox.shrink();
        return IconButton(
          icon: Icon(Icons.more_vert, color: ColorManager.titlesColor),
          onPressed: () => ProductDetailsOptionsDialog.show(
            context: context,
            isAdmin: _isAdmin,
            onEdit: () => _onEditProduct(context, state),
            onConfirm: () => _showConfirmDialog(context, state),
            onDelete: () => _showDeleteDialog(context, state),
          ),
        );
      },
    );
  }
}
