import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/common/utils/bloc_listen_when.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/routes/route_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';
import 'package:jeeb_admin/core/presentation/widgets/bloc_state_handler.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/search_merchant_widget.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_circle_indicator.dart';
import 'package:jeeb_admin/core/presentation/widgets/empty_state_widget.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/bloc/update_merchant_bloc.dart';

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
    if (state is ListMerchantLoaded && state.hasMore && !state.isLoadingMore) {
      context.read<ListMerchantBloc>().add(
        GetMerchantsEvent(loadMore: true, search: state.search),
      );
    }
  }

  void _confirmMerchant(BuildContext context, String merchantId) {
    context.read<UpdateMerchantBloc>().add(
          UpdateMerchantSubmitted(
            id: merchantId,
            isActive: true,
            isConfirmAction: true,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateMerchantBloc, UpdateMerchantState>(
      listenWhen: (previous, current) => listenWhenEnteringTerminal(
        previous,
        current,
        (s) => s is UpdateMerchantSuccess || s is UpdateMerchantError,
      ),
      listener: (context, state) {
        if (state is UpdateMerchantSuccess) {
          customToast(
            msg: state.isConfirmAction
                ? AppTranslation.merchantConfirmedSuccessfully
                : AppTranslation.merchantUpdatedSuccessfully,
          );
          final listState = context.read<ListMerchantBloc>().state;
          final search = listState is ListMerchantLoaded ? listState.search : null;
          context.read<ListMerchantBloc>().add(GetMerchantsEvent(search: search));
        } else if (state is UpdateMerchantError) {
          customToast(msg: state.message);
        }
      },
      child: Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(title: AppTranslation.merchants),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.navigateTo(context, Routes.addMerchant);
        },
        backgroundColor: ColorManager.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const SearchMerchantWidget(),
          Expanded(
            child: BlocStateHandler<ListMerchantBloc, ListMerchantState>(
              bloc: context.read<ListMerchantBloc>(),
              isLoading: (state) => state is ListMerchantLoading,
              isError: (state) => state is ListMerchantError,
              getErrorMessage: (state) => (state as ListMerchantError).message,
              isSuccess: (state) => state is ListMerchantLoaded,
              getRetryCallback: (state) => () {
                context.read<ListMerchantBloc>().add(const GetMerchantsEvent());
              },
              successBuilder: (context, merchantState) {
                final s = merchantState as ListMerchantLoaded;
                final merchants = s.merchants;
                final isLoadingMore = s.isLoadingMore;
                final currentSearch = s.search;

                if (merchants.isEmpty && !isLoadingMore) {
                  return EmptyStateWidget(
                    message: AppTranslation.noMerchantsFound,
                    onPress: () {
                      context.read<ListMerchantBloc>().add(
                            GetMerchantsEvent(search: currentSearch),
                          );
                    },
                  );
                }

                return RefreshIndicator(
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
                    itemCount: merchants.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == merchants.length) {
                        return Padding(
                          padding: EdgeInsets.all(AppPadding.p16),
                          child: const CustomCircleIndicator(),
                        );
                      }
                      final merchant = merchants[index];
                      return MerchantListItem(
                        merchant: merchant,
                        onConfirmMerchant: merchant.isActive == false
                            ? () => _confirmMerchant(context, merchant.id)
                            : null,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}
