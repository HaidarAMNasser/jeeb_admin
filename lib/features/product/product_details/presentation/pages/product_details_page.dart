import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/widgets.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/product/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/pages/create_product_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch product details when page loads
    context.read<ProductDetailsBloc>().add(
          GetProductDetailsEvent(id: widget.productId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        title: CustomText(
          text: AppTranslation.productDetails,
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s24,
            color: ColorManager.titlesColor,
          ),
        ),
      ),
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const CustomCircleIndicator();
          } else if (state is ProductDetailsError) {
            // Check if it's a network error
            final isNetworkError = state.message.toLowerCase().contains('network') ||
                state.message.toLowerCase().contains('internet') ||
                state.message.toLowerCase().contains('connection');
            
            return ErrorStateWidget(
              message: isNetworkError
                  ? AppTranslation.noInternetConnection
                  : state.message,
              icon: isNetworkError ? Icons.wifi_off : Icons.error_outline,
              onRetry: () {
                context.read<ProductDetailsBloc>().add(
                      GetProductDetailsEvent(id: widget.productId),
                    );
              },
            );
          } else if (state is ProductDetailsLoaded) {
            // Navigate to create product page in edit mode
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProductPage(
                      product: state.product,
                    ),
                  ),
                );
              }
            });
            // Show loading while navigating
            return const CustomCircleIndicator();
          } else {
            // Initial state - show loading
            return const CustomCircleIndicator();
          }
        },
      ),
    );
  }
}

