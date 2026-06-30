import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/widgets/merchant_active_filter_sheet.dart';

class MerchantsFilterButton extends StatelessWidget {
  const MerchantsFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListMerchantBloc, ListMerchantState>(
      buildWhen: (prev, curr) =>
          prev is ListMerchantLoaded != curr is ListMerchantLoaded ||
          (prev is ListMerchantLoaded &&
              curr is ListMerchantLoaded &&
              (prev.isFiltered != curr.isFiltered ||
                  prev.isActiveFilter != curr.isActiveFilter ||
                  prev.search != curr.search)),
      builder: (context, state) {
        final loaded = state is ListMerchantLoaded ? state : null;
        final isFiltered = loaded?.isFiltered ?? false;

        return Container(
          width: AppWidth.s50,
          height: AppHeight.s50,
          decoration: BoxDecoration(
            color: loaded == null
                ? ColorManager.primary.withValues(alpha: 0.35)
                : ColorManager.primary,
            borderRadius: BorderRadius.circular(AppRadius.r18),
          ),
          child: IconButton(
            tooltip: isFiltered
                ? AppTranslation.merchantsResetFilters
                : AppTranslation.merchantsFilterTooltip,
            onPressed: loaded == null
                ? null
                : () {
                    if (isFiltered) {
                      context.read<ListMerchantBloc>().add(
                            const GetMerchantsEvent(
                              search: null,
                              isActiveFilter: null,
                            ),
                          );
                    } else {
                      showMerchantActiveFilterSheet(context, loaded);
                    }
                  },
            icon: Icon(
              isFiltered ? Icons.restart_alt : Icons.filter_alt_outlined,
              color: ColorManager.defaultWhite,
            ),
          ),
        );
      },
    );
  }
}
