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

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (!_isBottom) return;
    final state = context.read<ListOrderBloc>().state;
    if (state is! ListOrderLoaded) return;
    if (!state.hasMore || state.isLoadingMore) return;
    context.read<ListOrderBloc>().add(
          GetOrdersEvent(
            loadMore: true,
            search: state.search,
            merchantId: state.merchantId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.orders),

      body: BlocBuilder<ListOrderBloc, ListOrderState>(
        builder: (context, state) {
          String? currentSearch;
          if (state is ListOrderLoaded) {
            currentSearch = state.search;
          }

          return BlocStateHandler<ListOrderBloc, ListOrderState>(
            bloc: context.read<ListOrderBloc>(),
            isLoading: (state) => state is ListOrderLoading,
            isError: (state) => state is ListOrderError,
            getErrorMessage: (state) => (state as ListOrderError).message,
            isSuccess: (state) => state is ListOrderLoaded,
            isEmpty: (state) {
              if (state is ListOrderLoaded) {
                return state.orders.isEmpty && !state.isLoadingMore;
              }
              return false;
            },
            emptyMessage: AppTranslation.noOrdersFound,
            getRetryCallback: (state) => () {
              final merchantId =
                  state is ListOrderLoaded ? state.merchantId : null;
              context.read<ListOrderBloc>().add(
                    GetOrdersEvent(search: currentSearch, merchantId: merchantId),
                  );
            },
            getEmptyRetryCallback: (state) => () {
              final merchantId =
                  state is ListOrderLoaded ? state.merchantId : null;
              context.read<ListOrderBloc>().add(
                    GetOrdersEvent(merchantId: merchantId),
                  );
            },
            successBuilder: (context, orderState) {
              final s = orderState as ListOrderLoaded;

              return ListOrderContent(
                orders: s.orders,
                isLoadingMore: s.isLoadingMore,
                scrollController: _scrollController,
                onRefresh: () {
                  context.read<ListOrderBloc>().add(
                        GetOrdersEvent(
                          search: currentSearch,
                          merchantId: s.merchantId,
                        ),
                      );
                },
                currentSearch: currentSearch,
                merchantId: s.merchantId,
              );
            },
          );
        },
      ),
    );
  }
}
