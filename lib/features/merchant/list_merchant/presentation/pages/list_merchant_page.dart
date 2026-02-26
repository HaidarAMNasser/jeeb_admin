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
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_list_item.dart';

class ListMerchantPage extends StatefulWidget {
  const ListMerchantPage({super.key});

  @override
  State<ListMerchantPage> createState() => _ListMerchantPageState();
}

class _ListMerchantPageState extends State<ListMerchantPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial merchants
    context.read<ListMerchantBloc>().add(const GetMerchantsEvent());
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
      final state = context.read<ListMerchantBloc>().state;
      if (state is ListMerchantLoaded && state.hasMore) {
        setState(() {
          _isLoadingMore = true;
        });
        context.read<ListMerchantBloc>().add(
              const GetMerchantsEvent(loadMore: true),
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
          text: AppTranslation.merchants,
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s24,
            color: ColorManager.titlesColor,
          ),
        ),
      ),
      body: BlocConsumer<ListMerchantBloc, ListMerchantState>(
        listener: (context, state) {
          if (state is ListMerchantLoaded) {
            setState(() {
              _isLoadingMore = false;
            });
          }
          if (state is ListMerchantError) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        },
        builder: (context, state) {
          return BlocStateHandler<ListMerchantBloc, ListMerchantState>(
            bloc: context.read<ListMerchantBloc>(),
            isLoading: (state) => state is ListMerchantLoading,
            isError: (state) => state is ListMerchantError,
            getErrorMessage: (state) => (state as ListMerchantError).message,
            isSuccess: (state) => state is ListMerchantLoaded || state is ListMerchantLoadingMore,
            isEmpty: (state) {
              if (state is ListMerchantLoaded) {
                return state.merchants.isEmpty;
              }
              if (state is ListMerchantLoadingMore) {
                return state.merchants.isEmpty;
              }
              return false;
            },
            emptyMessage: AppTranslation.noMerchantsFound,
            getRetryCallback: (state) => () {
              context.read<ListMerchantBloc>().add(const GetMerchantsEvent());
            },
            successBuilder: (context, merchantState) {
              final merchants = merchantState is ListMerchantLoaded
                  ? merchantState.merchants
                  : (merchantState as ListMerchantLoadingMore).merchants;
              final hasMore = merchantState is ListMerchantLoaded ? merchantState.hasMore : false;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ListMerchantBloc>().add(
                        const GetMerchantsEvent(),
                      );
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(AppPadding.p16),
                  itemCount: merchants.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == merchants.length) {
                      // Loading more indicator
                      return Padding(
                        padding: EdgeInsets.all(AppPadding.p16),
                        child: const CustomCircleIndicator(),
                      );
                    }

                    final merchant = merchants[index];
                    return MerchantListItem(merchant: merchant);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

