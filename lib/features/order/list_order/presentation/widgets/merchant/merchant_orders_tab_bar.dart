import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/order/list_order/domain/merchant_orders_tab.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/bloc/list_order_bloc.dart';

/// Merchant only: segmented tabs (pending / confirmed / in progress).
class MerchantOrdersTabBar extends StatelessWidget {
  const MerchantOrdersTabBar({super.key, required this.controller});

  final TabController controller;

  List<({String label, IconData icon})> _tabs() => [
        (
          label: AppTranslation.merchantOrdersTabPending,
          icon: Icons.schedule_rounded,
        ),
        (
          label: AppTranslation.merchantOrdersTabConfirmed,
          icon: Icons.verified_rounded,
        ),
        (
          label: AppTranslation.merchantOrdersTabOthers,
          icon: Icons.delivery_dining_rounded,
        ),
      ];

  void _onSelect(BuildContext context, int index) {
    if (controller.index != index) {
      controller.animateTo(index);
    }
    final state = context.read<ListOrderBloc>().state;
    final loaded = state is ListOrderLoaded ? state : null;
    context.read<ListOrderBloc>().add(
          GetOrdersEvent(
            merchantTab: MerchantOrdersTab.values[index],
            search: loaded?.search,
            merchantId: loaded?.merchantId,
            statusFilter: null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final selected = controller.index;
        final tabs = _tabs();
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppPadding.p16,
            AppPadding.p10,
            AppPadding.p16,
            AppPadding.p12,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppRadius.r14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppPadding.p4),
              child: Row(
                children: List.generate(3, (index) {
                  final isSelected = selected == index;
                  final tab = tabs[index];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppPadding.p2),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _onSelect(context, index),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                          splashColor: ColorManager.primary.withValues(alpha: 0.12),
                          highlightColor: ColorManager.primary.withValues(alpha: 0.06),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            padding: EdgeInsets.symmetric(
                              vertical: AppPadding.p10,
                              horizontal: AppPadding.p6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? ColorManager.primary.withValues(alpha: 0.22)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(AppRadius.r10),
                              border: Border.all(
                                color: isSelected
                                    ? ColorManager.primary.withValues(alpha: 0.55)
                                    : Colors.transparent,
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: ColorManager.primary
                                            .withValues(alpha: 0.18),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  tab.icon,
                                  size: AppSize.s20,
                                  color: isSelected
                                      ? ColorManager.primary
                                      : ColorManager.textSecondary,
                                ),
                                SizedBox(height: AppHeight.s4),
                                CustomText(
                                  text: tab.label,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                  textStyle: isSelected
                                      ? getSemiBoldStyle(
                                          fontSize: AppFontSize.s11,
                                          color: ColorManager.titlesColor,
                                        )
                                      : getRegularStyle(
                                          fontSize: AppFontSize.s11,
                                          color: ColorManager.textSecondary,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
