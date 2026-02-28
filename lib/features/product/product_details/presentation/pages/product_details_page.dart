import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/widgets.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/product/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:jeeb_admin/features/product/create_product/presentation/pages/create_product_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

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
      appBar: CustomAppBar(title: AppTranslation.productDetails),
      body: BlocStateHandler<ProductDetailsBloc, ProductDetailsState>(
        bloc: context.read<ProductDetailsBloc>(),
        isLoading: (state) => state is ProductDetailsLoading,
        isError: (state) => state is ProductDetailsError,
        getErrorMessage: (state) => (state as ProductDetailsError).message,
        isSuccess: (state) => state is ProductDetailsLoaded,
        getRetryCallback: (state) => () {
          context.read<ProductDetailsBloc>().add(
            GetProductDetailsEvent(id: widget.productId),
          );
        },
        successBuilder: (context, productState) {
          final loadedState = productState as ProductDetailsLoaded;

          // Navigate to create product page in edit mode
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateProductPage(product: loadedState.product),
                ),
              );
            }
          });
          // Show loading while navigating
          return const CustomCircleIndicator();
        },
      ),
    );
  }
}
