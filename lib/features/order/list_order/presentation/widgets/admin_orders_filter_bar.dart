import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/bloc/list_order_bloc.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/widgets/merchant/merchant_orders_status_filter_sheet.dart';

/// Admin only: same size/shape as merchant search restart — filter when `!isFiltered`, reset when filtered (bloc state).
class AdminOrdersFilterSlot extends StatelessWidget {
  const AdminOrdersFilterSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListOrderBloc, ListOrderState>(
      buildWhen: (prev, curr) =>
          prev is ListOrderLoaded != curr is ListOrderLoaded ||
          (prev is ListOrderLoaded &&
              curr is ListOrderLoaded &&
              (prev.isFiltered != curr.isFiltered ||
                  prev.statusFilter != curr.statusFilter ||
                  prev.search != curr.search)),
      builder: (context, state) {
        final loaded = state is ListOrderLoaded ? state : null;
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
                ? AppTranslation.ordersResetFilters
                : AppTranslation.ordersFilterTooltip,
            onPressed: loaded == null
                ? null
                : () {
                    if (isFiltered) {
                      context.read<ListOrderBloc>().add(
                            const GetOrdersEvent(
                              search: null,
                              statusFilter: null,
                            ),
                          );
                    } else {
                      showMerchantOrdersStatusFilterSheet(
                        context,
                        loaded,
                      );
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
