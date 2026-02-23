import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/product_indicators/domain/entities/product_entity.dart';
import 'package:fatoorahapp/feature/products/products/presentation/blocs/all_products/products_bloc.dart';
import 'package:fatoorahapp/widgets/custom_paginated_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.isEditMode, required this.name, required this.onEditProduct,  this.selectedProduct});

  final bool isEditMode;
  final String? name;
  final Function(ProductEntity) onEditProduct;
  final ProductEntity? selectedProduct;

  @override
  Widget build(BuildContext context) {
return BlocBuilder<ProductsBloc, ProductsState>(
    builder: (context, state) {
      if (state is ProductsInitialState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ProductsBloc>().add(ProductsSubmitted(isSelect: 1, withLoading: true));
        });
      }

      final List<ProductEntity> productsList =
          state is ProductsSuccessState ? state.productsEntity : [];
      final bool isLoadingMore =
          state is ProductsSuccessState ? state.isLoadingMore : false;
      final bool hasMoreData =
          state is ProductsSuccessState ? !state.hasReachedMax : true;
      final bool isFiltered =
          state is ProductsSuccessState ? state.isFiltered : false;

      return CustomPaginatedDropDown(
        showFtechButton: true,
          fromProduct: true,
          withSearch: true,
          isSuccess: state is ProductsSuccessState,
          isLoading: state is ProductsLoadingState || state is ProductsInitialState,
          isError: state is ProductsErrorState,
          onFetchingData: () {
            context.read<ProductsBloc>().add(ProductsSubmitted(isSelect: 1, withLoading: true));
          } ,
          initOption: isEditMode ? name : null,
          title: TranslationsController.instance.getTranslations().productName,
          isRequired: true,
          hintText:
              TranslationsController.instance.getTranslations().productName,
          dropDownList: productsList,
          withApiPagination: true,
          isLoadingMore: isLoadingMore,
          hasMoreData: hasMoreData,
          isFiltered: isFiltered,

          onLoadMoreApi: () async {
            if (!isLoadingMore && hasMoreData) {
              context.read<ProductsBloc>().add(ProductsOnChangedSubmitted());
            }
          },
          onSearchChangedApi: (query) {
            if (query.isEmpty) {
              // When search is cleared, fetch all products
              context
                  .read<ProductsBloc>()
                  .add(ProductsSubmitted(isSelect: 1, withLoading: false));
            } else {
              // When searching, use the search query
              context 
                  .read<ProductsBloc>()
                  .add(ProductsSubmitted(searchText: query, isSelect: 1));
            }
          },
          onSelectItem: (val) {
            onEditProduct(val);
            if (state is ProductsSuccessState && state.isFiltered)
              context.read<ProductsBloc>().add(ProductsSubmitted(isSelect: 1,));
          });
    },
  );
  }
}
Widget productWidget(
  bool isEditMode,
  String? name,
  Function(ProductEntity) onEditProduct, {
  ProductEntity? selectedProduct,
}) {
  return BlocBuilder<ProductsBloc, ProductsState>(
    builder: (context, state) {
      if (state is ProductsInitialState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ProductsBloc>().add(ProductsSubmitted(isSelect: 1, withLoading: true));
        });
      }

      final List<ProductEntity> productsList =
          state is ProductsSuccessState ? state.productsEntity : [];
      final bool isLoadingMore =
          state is ProductsSuccessState ? state.isLoadingMore : false;
      final bool hasMoreData =
          state is ProductsSuccessState ? !state.hasReachedMax : true;
      final bool isFiltered =
          state is ProductsSuccessState ? state.isFiltered : false;

      return CustomPaginatedDropDown(
        showFtechButton: true,
          fromProduct: true,
          withSearch: true,
          isSuccess: state is ProductsSuccessState,
          isLoading: state is ProductsLoadingState || state is ProductsInitialState,
          isError: state is ProductsErrorState,
          onFetchingData: () {
            context.read<ProductsBloc>().add(ProductsSubmitted(isSelect: 1, withLoading: true));
          } ,
          initOption: isEditMode ? name : null,
          title: TranslationsController.instance.getTranslations().productName,
          isRequired: true,
          hintText:
              TranslationsController.instance.getTranslations().productName,
          dropDownList: productsList,
          withApiPagination: true,
          isLoadingMore: isLoadingMore,
          hasMoreData: hasMoreData,
          isFiltered: isFiltered,

          onLoadMoreApi: () async {
            if (!isLoadingMore && hasMoreData) {
              context.read<ProductsBloc>().add(ProductsOnChangedSubmitted());
            }
          },
          onSearchChangedApi: (query) {
            if (query.isEmpty) {
              // When search is cleared, fetch all products
              context
                  .read<ProductsBloc>()
                  .add(ProductsSubmitted(isSelect: 1, withLoading: false));
            } else {
              // When searching, use the search query
              context
                  .read<ProductsBloc>()
                  .add(ProductsSubmitted(searchText: query, isSelect: 1));
            }
          },
          onSelectItem: (val) {
            onEditProduct(val);
            if (state is ProductsSuccessState && state.isFiltered)
              context.read<ProductsBloc>().add(ProductsSubmitted(isSelect: 1,));
          });
    },
  );
}
