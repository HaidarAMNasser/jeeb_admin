import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/search_merchant_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';

class ListMerchantPage extends StatefulWidget {
  const ListMerchantPage({super.key});

  @override
  State<ListMerchantPage> createState() => _ListMerchantPageState();
}

class _ListMerchantPageState extends State<ListMerchantPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ListMerchantBloc>().add(const GetMerchantsEvent());
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
    final state = context.read<ListMerchantBloc>().state;
    if (state is ListMerchantLoaded &&
        state.hasMore &&
        !state.isLoadingMore) {
      context.read<ListMerchantBloc>().add(
            GetMerchantsEvent(loadMore: true, search: state.search),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.merchants),
      body: BlocBuilder<ListMerchantBloc, ListMerchantState>(
        builder: (context, state) {
          String? currentSearch;
          if (state is ListMerchantLoaded) {
            currentSearch = state.search;
          }

          return BlocStateHandler<ListMerchantBloc, ListMerchantState>(
            bloc: context.read<ListMerchantBloc>(),
            isLoading: (state) => state is ListMerchantLoading,
            isError: (state) => state is ListMerchantError,
            getErrorMessage: (state) => (state as ListMerchantError).message,
            isSuccess: (state) => state is ListMerchantLoaded,
            isEmpty: (state) {
              if (state is ListMerchantLoaded) {
                return state.merchants.isEmpty && !state.isLoadingMore;
              }
              return false;
            },
            emptyMessage: AppTranslation.noMerchantsFound,
            getRetryCallback: (state) => () {
              context.read<ListMerchantBloc>().add(const GetMerchantsEvent());
            },
            getEmptyRetryCallback: (state) => () {
              context.read<ListMerchantBloc>().add(const GetMerchantsEvent());
            },
            successBuilder: (context, merchantState) {
              final s = merchantState as ListMerchantLoaded;
              final merchants = s.merchants;
              final isLoadingMore = s.isLoadingMore;

              return Column(
                children: [
                  const SearchMerchantWidget(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<ListMerchantBloc>().add(
                              GetMerchantsEvent(search: currentSearch),
                            );
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          left: AppPadding.p16,
                          right: AppPadding.p16,
                          bottom: 24,
                        ),
                        itemCount:
                            merchants.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == merchants.length) {
                            return Padding(
                              padding: EdgeInsets.all(AppPadding.p16),
                              child: const CustomCircleIndicator(),
                            );
                          }
                          final merchant = merchants[index];
                          return MerchantListItem(merchant: merchant);
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
    );
  }
}
