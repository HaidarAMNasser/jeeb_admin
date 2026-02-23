import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/feature/admin/presentation/blocs/admin_bloc.dart';
import 'package:fatoorahapp/feature/clients/clients/presentation/blocs/clients_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/blocs/offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/widgets/filter_offer_prices_widget.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/widgets/offer_price_item_widget.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/widgets/search_filter_offer_price_widget.dart';
import 'package:fatoorahapp/injections/dependency_injection/dependency_injection.dart';
import 'package:fatoorahapp/widgets/circular_progress_indicator_widget.dart';
import 'package:fatoorahapp/widgets/dialogs/dialogs_and_popups.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:fatoorahapp/widgets/ui_states/error_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_data_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_internet_state.dart';
import 'package:fatoorahapp/widgets/ui_states/not_found_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class offerPriceBody extends StatelessWidget {
  const offerPriceBody({super.key, required ScrollController scrollController})
    : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferPriceBloc, OfferPriceState>(
      builder: (context, state) {
        return state is OfferPriceSuccessState
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: searchFilterOfferPrice(
                      onFetchingData: () {
                        BlocProvider.of<OfferPriceBloc>(
                          context,
                        ).searchController.clear();
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                      onFiltering: () {
                        initClientsBlocDIModule();
                        initAdminBlocDIModule();
                        DialogsAndPopUp.customBottomSheet(
                          context: context,
                          child: MultiBlocProvider(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSize.s10.h,
                                horizontal: AppSize.s14.w,
                              ),
                              child: FilterOfferPricesWidget(),
                            ),
                            providers: [
                              BlocProvider.value(
                                value: BlocProvider.of<OfferPriceBloc>(context),
                              ),
                              BlocProvider(
                                create: (dialogContext) =>
                                    inject<ClientsBloc>()
                                      ..add(ClientsSubmitted()),
                              ),
                              BlocProvider(
                                create: (dialogContext) =>
                                    inject<AdminBloc>()..add(AdminSubmitted()),
                              ),
                            ],
                          ),
                        );
                      },
                      onSubmitted: (searchText) {
                        context.read<OfferPriceBloc>().add(
                          OfferPriceSubmitted(
                            searchText: searchText,
                            withLoading: true,
                            isFiltered: true,
                          ),
                        );
                      },
                      currentSearchText: '',
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state.offerPriceDataEntity.isEmpty &&
                            !state.isLoadingMore) {
                          return NoDataState(
                            onPressed: () {
                              context.read<OfferPriceBloc>().add(
                                const OfferPriceSubmitted(withLoading: true),
                              );
                            },
                          );
                        }
                        final currentList = state.offerPriceDataEntity;
                        final isLoadingMore = state.isLoadingMore;
                        return ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.only(
                            left: AppSize.s16.w,
                            right: AppSize.s16.w,
                            bottom: 80.h,
                          ),
                          itemCount:
                              currentList.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= currentList.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSize.s10,
                                ),
                                child: Center(
                                  child: CustomCircularProgressIndicator(),
                                ),
                              );
                            }
                            return OfferPriceItemWidget(
                              offerPriceDataEntity: currentList[index],
                              showIcon: false,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              verticalSpace(height: 16.h),
                        );
                      },
                    ),
                  ),
                ],
              )
            : state is OfferPriceLoadingState
            ? CustomCircularProgressIndicator()
            : state is OfferPriceErrorState
            ? (state.statusCode == 404
                  ? NotFoundState(
                      onPressed: () {
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                    )
                  : state.statusCode == -6
                  ? NoInternetState(
                      onPressed: () {
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                    )
                  : ErrorState(
                      onPressed: () {
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                    ))
            : Container();
      },
    );
  }
}
