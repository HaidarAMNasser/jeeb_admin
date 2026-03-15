import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/bloc/list_order_bloc.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/list_order_content.dart';

class ListOrderPage extends StatefulWidget {
  const ListOrderPage({super.key});

  @override
  State<ListOrderPage> createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<ListOrderBloc>().state;
    // Prevent loading more if already loading
    if (state is ListOrderLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (state is ListOrderLoaded && state.hasMore) {
        // Use the search query and merchantId from state when loading more
        context.read<ListOrderBloc>().add(
          GetOrdersEvent(
            loadMore: true,
            search: state.search,
            merchantId: state.merchantId,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.orders),

      body: BlocBuilder<ListOrderBloc, ListOrderState>(
        builder: (context, state) {
          // Get current search query from state for refresh
          String? currentSearch;
          if (state is ListOrderLoaded) {
            currentSearch = state.search;
          } else if (state is ListOrderLoadingMore) {
            currentSearch = state.search;
          }

          return BlocStateHandler<ListOrderBloc, ListOrderState>(
            bloc: context.read<ListOrderBloc>(),
            isLoading: (state) => state is ListOrderLoading,
            isError: (state) => state is ListOrderError,
            getErrorMessage: (state) => (state as ListOrderError).message,
            isSuccess: (state) =>
                state is ListOrderLoaded || state is ListOrderLoadingMore,
            isEmpty: (state) {
              if (state is ListOrderLoaded) return state.orders.isEmpty;
              if (state is ListOrderLoadingMore) return state.orders.isEmpty;
              return false;
            },
            emptyMessage: AppTranslation.noOrdersFound,
            getRetryCallback: (state) => () {
              final merchantId = state is ListOrderLoaded
                  ? state.merchantId
                  : (state is ListOrderLoadingMore ? state.merchantId : null);
              context.read<ListOrderBloc>().add(
                    GetOrdersEvent(search: currentSearch, merchantId: merchantId),
                  );
            },
            getEmptyRetryCallback: (state) => () {
              final merchantId = state is ListOrderLoaded
                  ? state.merchantId
                  : (state is ListOrderLoadingMore ? state.merchantId : null);
              context.read<ListOrderBloc>().add(
                    GetOrdersEvent( merchantId: merchantId),
                  );
            },
            successBuilder: (context, orderState) {
              final orders = orderState is ListOrderLoaded
                  ? orderState.orders
                  : (orderState as ListOrderLoadingMore).orders;
              final hasMore = orderState is ListOrderLoaded
                  ? orderState.hasMore
                  : false;
              final merchantId = orderState is ListOrderLoaded
                  ? orderState.merchantId
                  : (orderState as ListOrderLoadingMore).merchantId;

              return ListOrderContent(
                orders: orders,
                hasMore: hasMore,
                scrollController: _scrollController,
                onRefresh: () {
                  context.read<ListOrderBloc>().add(
                        GetOrdersEvent(
                          search: currentSearch,
                          merchantId: merchantId,
                        ),
                      );
                },
                currentSearch: currentSearch,
                merchantId: merchantId,
              );
            },
          );
        },
      ),
    );
  }
}
