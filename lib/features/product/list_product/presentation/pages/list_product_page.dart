import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart' as di;
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/bloc/list_product_bloc.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/product_list_item.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/search_product_widget.dart';

class ListProductPage extends StatefulWidget {
  final String  ? merchantId;
  const ListProductPage({super.key,  this.merchantId});

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial load is triggered by route when bloc is created
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (!_isBottom) return;
    final state = context.read<ListProductBloc>().state;
    if (state is! ListProductLoaded) return;
    if (!state.hasMore || state.isLoadingMore) return;
    context.read<ListProductBloc>().add(
          GetProductsEvent(
            loadMore: true,
            merchantId: state.merchantId,
            search: state.search,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.products),
      body: BlocBuilder<ListProductBloc, ListProductState>(
        builder: (context, state) {
          return BlocStateHandler<ListProductBloc, ListProductState>(
            bloc: context.read<ListProductBloc>(),
            isLoading: (state) => state is ListProductLoading,
            isError: (state) => state is ListProductError,
            getErrorMessage: (state) => (state as ListProductError).message,
            isSuccess: (state) => state is ListProductLoaded,
            isEmpty: (state) {
              if (state is ListProductLoaded) {
                return state.products.isEmpty && !state.isLoadingMore;
              }
              return false;
            },
            emptyMessage: AppTranslation.noProductsFound,
            getRetryCallback: (state) => () {
              context.read<ListProductBloc>().add(GetProductsEvent(merchantId: widget.merchantId ?? '0'));
            },
            getEmptyRetryCallback: (state) => () {
              context.read<ListProductBloc>().add(GetProductsEvent(merchantId: widget.merchantId ?? '0'));
            },
            successBuilder: (context, productState) {
              final s = productState as ListProductLoaded;
              final products = s.products;
              final isLoadingMore = s.isLoadingMore;
              final currentSearch = s.search;
              final currentMerchantId = s.merchantId;

              return Column(
                children: [
                  SearchProductWidget(merchantId: widget.merchantId ?? currentMerchantId),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<ListProductBloc>().add(
                              GetProductsEvent(
                                merchantId: widget.merchantId ?? currentMerchantId ?? '0',
                                search: currentSearch,
                              ),
                            );
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(AppPadding.p16),
                        itemCount:
                            products.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == products.length) {
                            return Padding(
                              padding: EdgeInsets.all(AppPadding.p16),
                              child: const CustomCircleIndicator(),
                            );
                          }
                          final product = products[index];
                          return ProductListItem(product: product,enableSmallDesign: true,);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<String?>(
        future: di.sl<StorageService>().getUserRole(),
        builder: (context, snapshot) {
          final isAdmin = snapshot.data?.toLowerCase() == UserRole.admin.name;
          if (isAdmin) return const SizedBox.shrink();
          return FloatingActionButton(
            backgroundColor: ColorManager.primary,
            onPressed: () {
              Navigator.pushNamed(context, Routes.addProduct);
            },
            child: Icon(Icons.add, color: ColorManager.surface),
          );
        },
      ),
    );
  }
}