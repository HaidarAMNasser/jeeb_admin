import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/helpful_funcations/file_picker.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/main/presentation/screens/main_screen.dart';
import 'package:fatoorahapp/feature/offer_price/delete_offer_price/presentation/blocs/delete_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/blocs/offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/widgets/offer_price_body.dart';
import 'package:fatoorahapp/widgets/circular_progress_indicator_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/app_bar_widget.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:fatoorahapp/widgets/ui_states/error_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_data_state.dart';
import 'package:fatoorahapp/widgets/ui_states/not_found_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_internet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OfferPriceScreen extends StatefulWidget {
  final bool? fromHome;
  const OfferPriceScreen({this.fromHome = false, super.key});

  @override
  State<OfferPriceScreen> createState() => _OfferPriceScreenState();
}

class _OfferPriceScreenState extends State<OfferPriceScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<OfferPriceBloc>().add(
      const OfferPriceSubmitted(withLoading: true),
    );

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final offerPriceBloc = context.read<OfferPriceBloc>();
      offerPriceBloc.add(const OfferPriceOnChangedSubmitted());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteOfferPriceBloc, DeleteOfferPriceState>(
      listener: (context, deleteOfferPriceSatate) {
        if (deleteOfferPriceSatate is DeleteOfferPriceSuccessState) {
          customToast(
            msg: TranslationsController.instance
                .getTranslations()
                .operationSuccessful,
          );
          context.read<OfferPriceBloc>().add(
            const OfferPriceSubmitted(withLoading: true),
          );
        } else if (deleteOfferPriceSatate is DeleteOfferPriceErrorState) {
          customToast(msg: deleteOfferPriceSatate.message);
        }
      },
      builder: (context, deleteOfferPriceSatate) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.popUntil(context, (route) => route.isFirst);
            MainScreen.globalKey.currentState?.changeTab(
              (widget.fromHome != null && widget.fromHome!) ? 0 : 3,
            );
            return false;

            // Navigator.of(
            //   context,
            // ).pushNamedAndRemoveUntil(Routes.mainRoute, (route) => false);

            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   MainScreen.globalKey.currentState?.changeTab(
            //     (widget.fromHome != null && widget.fromHome!) ? 0 : 3,
            //   );
            // });
            // return false;
          },
          child: ModalProgressHUD(
            progressIndicator: CustomCircularProgressIndicator(
              color: ColorManager.primaryColor,
            ),
            inAsyncCall: deleteOfferPriceSatate is DeleteOfferPriceLoadingState,
            child: Scaffold(
              backgroundColor: ColorManager.scaffoldColor,
              appBar: CustomAppBar(
          
                backgroundColor: ColorManager.scaffoldColor,
                title: TranslationsController.instance
                    .getTranslations()
                    .quotations,
                onBackPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  MainScreen.globalKey.currentState?.changeTab(
                    (widget.fromHome != null && widget.fromHome!) ? 0 : 3,
                  );
                  // Clear the entire navigation stack and go to MainScreen
                  // Navigator.of(
                  //   context,
                  // ).pushNamedAndRemoveUntil(Routes.mainRoute, (route) => false);
                  // // Set the appropriate tab after navigation
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   MainScreen.globalKey.currentState?.changeTab(
                  //     (widget.fromHome != null && widget.fromHome!) ? 0 : 3,
                  //   );
                  // });
                },
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: ColorManager.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: const Icon(Icons.add, color: ColorManager.white),
                onPressed: () {
                  context.pushNamed(
                    Routes.createOfferPriceRoute,
                    arguments: {"fromEdit": false},
                  );
                },
              ),
              body: BlocBuilder<OfferPriceBloc, OfferPriceState>(
                builder: (context, offerPriceState) {
                  if (offerPriceState is OfferPriceSuccessState &&
                      offerPriceState.offerPriceDataEntity.isNotEmpty) {
                    return offerPriceBody(scrollController: _scrollController);
                  } else if (offerPriceState is OfferPriceSuccessState &&
                      offerPriceState.offerPriceDataEntity.isEmpty &&
                      (offerPriceState.isFiltered ?? false)) {
                    return NoDataState(
                      onPressed: () {
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                    );
                  } else if (offerPriceState is OfferPriceSuccessState &&
                      offerPriceState.offerPriceDataEntity.isEmpty) {
                    return NoDataState(
                      onPressed: () {
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                    );
                  } else if (offerPriceState is OfferPriceNoDataState) {
                    return NoDataState(
                      onPressed: () {
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                    );
                  } else if (offerPriceState is OfferPriceLoadingState) {
                    return const Center(
                      child: CustomCircularProgressIndicator(),
                    );
                  } else if (offerPriceState is OfferPriceNotFoundState) {
                    return NotFoundState(
                      onPressed: () {
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                    );
                  } else if (offerPriceState is OfferPriceNoInternetState) {
                    return NoInternetState(
                      onPressed: () {
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                    );
                  } else if (offerPriceState is OfferPriceErrorState) {
                    return ErrorState(
                      onPressed: () {
                        context.read<OfferPriceBloc>().add(
                          const OfferPriceSubmitted(withLoading: true),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
