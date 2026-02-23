import 'package:fatoorahapp/core/constances/assets_manager.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/blocs/offer_price_bloc.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/custom_images_widget.dart';
import 'package:fatoorahapp/widgets/search_with_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget searchFilterOfferPrice(
    {required String currentSearchText,
    required Function(String) onSubmitted,
    required void Function()? onFiltering,
    required VoidCallback onFetchingData}) {
  return BlocBuilder<OfferPriceBloc, OfferPriceState>(
      builder: (context, state) {
    return SearchFilterWidget(
        controller: BlocProvider.of<OfferPriceBloc>(context).searchController,
        filterWidget: !(state as OfferPriceSuccessState).isFiltered!
            ? CustomSvgAssetImage(
                image: IconAssets.filter,
                height: AppHeight.s20,
                colorFilter: const ColorFilter.mode(
                  ColorManager.white,
                  BlendMode.srcIn,
                ),
              )
            : Icon(
                Icons.restart_alt,
                color: ColorManager.white,
              ),
        onSubmmit: (value) {
          onSubmitted(value);
        },
        onFiltering: state.isFiltered!
            ? () {
                onFetchingData();
              }
            : onFiltering);
  });
}
