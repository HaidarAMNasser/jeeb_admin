import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/widgets/create_offer_price_body_widget.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/presentation/blocs/offer_price_details_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/update_offer_price/presentation/bloc/update_offer_price_bloc.dart';
import 'package:fatoorahapp/widgets/circular_progress_indicator_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/app_bar_widget.dart';
import 'package:fatoorahapp/widgets/ui_states/error_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_data_state.dart';
import 'package:fatoorahapp/widgets/ui_states/no_internet_state.dart';
import 'package:fatoorahapp/widgets/ui_states/not_found_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateOfferPriceScreen extends StatefulWidget {
  final bool fromEdit;
  final OfferPriceDataEntity? offerPriceEntity;
  const CreateOfferPriceScreen({
    super.key,
    required this.fromEdit,
    this.offerPriceEntity,
  });

  @override
  State<CreateOfferPriceScreen> createState() => _CreateOfferPriceScreenState();
}

class _CreateOfferPriceScreenState extends State<CreateOfferPriceScreen> {
  @override
  void initState() {
    if (widget.fromEdit) {
      BlocProvider.of<OfferPriceDetailsBloc>(context).add(
        GetOfferPriceDetailsEvent(offerPriceId: widget.offerPriceEntity!.uuid),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferPriceDetailsBloc, OfferPriceDetailsState>(
      builder: (context, state) {
        return BlocBuilder<OfferPriceUpdateBloc, OfferPriceUpdateState>(
          builder: (context, updateState) {
            return BlocBuilder<OfferPriceCreateBloc, CreateOfferPriceState>(
              builder: (context, createState) {
                return ModalProgressHUD(
                  progressIndicator: CustomCircularProgressIndicator(
                    color: ColorManager.primaryColor,
                  ),
                  inAsyncCall:
                      createState is CreateOfferPriceLoading ||
                      updateState is OfferPriceUpdateLoading,
                  child: Scaffold(
                    appBar: CustomAppBar(
                      backgroundColor:
                          ColorManager.secondaryScaffoldBackgroundColor,
                      title: widget.fromEdit
                          ? TranslationsController.instance
                                .getTranslations()
                                .editOfferPrice
                          : TranslationsController.instance
                                .getTranslations()
                                .createOfferPrice,
                    ),
                    backgroundColor:
                        ColorManager.secondaryScaffoldBackgroundColor,
                    body: widget.fromEdit
                        ? state is OfferPriceDetailsLoading
                              ? CustomCircularProgressIndicator()
                              : state is OfferPriceDetailsError
                              ? ErrorState(
                                  onPressed: () {
                                    BlocProvider.of<OfferPriceDetailsBloc>(
                                      context,
                                    ).add(
                                      GetOfferPriceDetailsEvent(
                                        offerPriceId:
                                            widget.offerPriceEntity!.uuid,
                                      ),
                                    );
                                  },
                                )
                              : state is OfferPriceDetailsSuccess
                              ? CreateOfferPriceBodyScreen(
                                  fromEdit: true,
                                  offerPriceDataEntity: state.offerPriceDetails,
                                  adminId: widget.offerPriceEntity != null
                                      ? widget
                                            .offerPriceEntity!
                                            .employeeDataEntity
                                            .id
                                            .toString()
                                      : null,
                                )
                              : state is OfferPriceDetailsNoInternetState
                              ? NoInternetState(
                                  onPressed: () {
                                    BlocProvider.of<OfferPriceDetailsBloc>(
                                      context,
                                    ).add(
                                      GetOfferPriceDetailsEvent(
                                        offerPriceId:
                                            widget.offerPriceEntity!.uuid,
                                      ),
                                    );
                                  },
                                )
                              : state is OfferPriceDetailsNotFoundState
                              ? NotFoundState(
                                  onPressed: () {
                                    BlocProvider.of<OfferPriceDetailsBloc>(
                                      context,
                                    ).add(
                                      GetOfferPriceDetailsEvent(
                                        offerPriceId:
                                            widget.offerPriceEntity!.uuid,
                                      ),
                                    );
                                  },
                                )
                              : state is OfferPriceDetailsNoDataState
                              ? NoDataState(
                                  onPressed: () {
                                    BlocProvider.of<OfferPriceDetailsBloc>(
                                      context,
                                    ).add(
                                      GetOfferPriceDetailsEvent(
                                        offerPriceId:
                                            widget.offerPriceEntity!.uuid,
                                      ),
                                    );
                                  },
                                )
                              : ErrorState(
                                  onPressed: () {
                                    BlocProvider.of<OfferPriceDetailsBloc>(
                                      context,
                                    ).add(
                                      GetOfferPriceDetailsEvent(
                                        offerPriceId:
                                            widget.offerPriceEntity!.uuid,
                                      ),
                                    );
                                  },
                                )
                        : CreateOfferPriceBodyScreen(
                            fromEdit: false,
                            adminId: widget.offerPriceEntity != null
                                ? widget.offerPriceEntity!.employeeDataEntity.id
                                      .toString()
                                : null,

                            offerPriceDataEntity: null,
                            // adminId:
                          ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
