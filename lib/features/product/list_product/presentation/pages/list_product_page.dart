import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/bloc/list_product_bloc.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/product_list_item.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({super.key});

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial products
    context.read<ListProductBloc>().add(const GetProductsEvent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = context.read<ListProductBloc>().state;
      if (state is ListProductLoaded && state.hasMore) {
        setState(() {
          _isLoadingMore = true;
        });
        context.read<ListProductBloc>().add(
              const GetProductsEvent(loadMore: true),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        title: CustomText(
          text: AppTranslation.products,
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s24,
            color: ColorManager.titlesColor,
          ),
        ),
      ),
      body: BlocConsumer<ListProductBloc, ListProductState>(
        listener: (context, state) {
          if (state is ListProductLoaded) {
            setState(() {
              _isLoadingMore = false;
            });
          }
          if (state is ListProductError) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        },
        builder: (context, state) {
          return BlocStateHandler<ListProductBloc, ListProductState>(
            bloc: context.read<ListProductBloc>(),
            isLoading: (state) => state is ListProductLoading,
            isError: (state) => state is ListProductError,
            getErrorMessage: (state) => (state as ListProductError).message,
            isSuccess: (state) => state is ListProductLoaded || state is ListProductLoadingMore,
            isEmpty: (state) {
              if (state is ListProductLoaded) {
                return state.products.isEmpty;
              }
              if (state is ListProductLoadingMore) {
                return state.products.isEmpty;
              }
              return false;
            },
            emptyMessage: AppTranslation.noProductsFound,
            getRetryCallback: (state) => () {
              context.read<ListProductBloc>().add(const GetProductsEvent());
            },
            successBuilder: (context, productState) {
              final products = productState is ListProductLoaded
                  ? productState.products
                  : (productState as ListProductLoadingMore).products;
              final hasMore = productState is ListProductLoaded ? productState.hasMore : false;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ListProductBloc>().add(
                        const GetProductsEvent(),
                      );
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(AppPadding.p16),
                  itemCount: products.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == products.length) {
                      // Loading more indicator
                      return Padding(
                        padding: EdgeInsets.all(AppPadding.p16),
                        child: const CustomCircleIndicator(),
                      );
                    }

                    final product = products[index];
                    return ProductListItem(product: product);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primary,
        onPressed: () {
          Navigator.pushNamed(context, Routes.addProduct);
        },
        child: Icon(Icons.add, color: ColorManager.surface),
      ),
    );
  }
}

