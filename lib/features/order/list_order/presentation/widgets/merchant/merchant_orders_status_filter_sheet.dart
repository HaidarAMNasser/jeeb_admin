import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/order/list_order/presentation/bloc/list_order_bloc.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_status.dart';

String _statusFilterLabel(OrderStatus s) {
  switch (s) {
    case OrderStatus.pending:
      return AppTranslation.merchantOrdersTabPending;
    case OrderStatus.confirmed:
      return AppTranslation.merchantOrdersTabConfirmed;
    case OrderStatus.searching:
      return AppTranslation.orderStepSearching;
    case OrderStatus.preparing:
      return AppTranslation.orderStatusPreparing;
    case OrderStatus.readyForPickup:
      return AppTranslation.orderStatusReadyForPickup;
    case OrderStatus.assigned:
      return AppTranslation.orderStatusAssigned;
    case OrderStatus.pickedUp:
      return AppTranslation.orderStatusPickedUp;
    case OrderStatus.onTheWay:
      return AppTranslation.orderStepOnTheWay;
    case OrderStatus.delivered:
      return AppTranslation.orderStepDelivered;
    case OrderStatus.cancelled:
      return AppTranslation.orderStatusCancelled;
    case OrderStatus.rejected:
      return AppTranslation.orderStatusRejected;
    case OrderStatus.unknown:
      return s.displayLabel;
  }
}

/// Bottom sheet: pick API status or "match current tab". Applies via [GetOrdersEvent].
Future<void> showMerchantOrdersStatusFilterSheet(
  BuildContext context,
  ListOrderLoaded current,
) {
  final bloc = context.read<ListOrderBloc>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorManager.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return BlocProvider<ListOrderBloc>.value(
        value: bloc,
        child: _MerchantOrdersFilterSheetBody(current: current),
      );
    },
  );
}

class _MerchantOrdersFilterSheetBody extends StatefulWidget {
  const _MerchantOrdersFilterSheetBody({required this.current});

  final ListOrderLoaded current;

  @override
  State<_MerchantOrdersFilterSheetBody> createState() =>
      _MerchantOrdersFilterSheetBodyState();
}

class _MerchantOrdersFilterSheetBodyState
    extends State<_MerchantOrdersFilterSheetBody> {
  /// Empty string = follow tab (no API status override).
  late String _selectedKey;

  static const _followTabKey = '';

  @override
  void initState() {
    super.initState();
    _selectedKey = widget.current.statusFilter ?? _followTabKey;
  }

  void _apply(BuildContext sheetContext) {
    final trimmed = _selectedKey.trim();
    final statusFilter =
        trimmed.isEmpty || trimmed == _followTabKey ? null : trimmed;
    final bloc = sheetContext.read<ListOrderBloc>();
    Navigator.of(sheetContext).pop();
    bloc.add(
      GetOrdersEvent(
        merchantTab: widget.current.merchantTab,
        search: widget.current.search,
        merchantId: widget.current.merchantId,
        statusFilter: statusFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statuses =
        OrderStatus.values.where((s) => s != OrderStatus.unknown).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.paddingOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: ColorManager.textSecondary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            CustomText(
              text: AppTranslation.ordersFilterTitle,
              textStyle: getBoldStyle(
                fontSize: AppFontSize.s18,
                color: ColorManager.titlesColor,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.45,
              child: ListView(
                children: [
                  RadioListTile<String>(
                    value: _followTabKey,
                    groupValue: _selectedKey,
                    onChanged: (v) => setState(() => _selectedKey = v ?? ''),
                    fillColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? ColorManager.primary.withValues(alpha: 0.15)
                          : null,
                    ),
                    title: CustomText(
                      text: widget.current.merchantTab == null
                          ? AppTranslation.ordersFilterNoStatusOverride
                          : AppTranslation.ordersFilterFollowTab,
                      textStyle: getRegularStyle(
                        fontSize: AppFontSize.s14,
                        color: ColorManager.textColor,
                      ),
                    ),
                  ),
                  ...statuses.map(
                    (s) => RadioListTile<String>(
                      value: s.apiWireValue,
                      groupValue: _selectedKey,
                      onChanged: (v) =>
                          setState(() => _selectedKey = v ?? _followTabKey),
                      fillColor: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.selected)
                            ? ColorManager.primary.withValues(alpha: 0.15)
                            : null,
                      ),
                      title: CustomText(
                        text: _statusFilterLabel(s),
                        textStyle: getRegularStyle(
                          fontSize: AppFontSize.s14,
                          color: ColorManager.textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _apply(context),
              style: FilledButton.styleFrom(
                backgroundColor: ColorManager.primary,
                foregroundColor: ColorManager.surface,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: CustomText(
                text: AppTranslation.ordersFilterApply,
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s16,
                  color: ColorManager.surface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
