import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/merchant/list_merchant/presentation/bloc/list_merchant_bloc.dart';

Future<void> showMerchantActiveFilterSheet(
  BuildContext context,
  ListMerchantLoaded current,
) {
  final bloc = context.read<ListMerchantBloc>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorManager.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return BlocProvider<ListMerchantBloc>.value(
        value: bloc,
        child: _MerchantActiveFilterSheetBody(current: current),
      );
    },
  );
}

class _MerchantActiveFilterSheetBody extends StatefulWidget {
  const _MerchantActiveFilterSheetBody({required this.current});

  final ListMerchantLoaded current;

  @override
  State<_MerchantActiveFilterSheetBody> createState() =>
      _MerchantActiveFilterSheetBodyState();
}

class _MerchantActiveFilterSheetBodyState
    extends State<_MerchantActiveFilterSheetBody> {
  static const _activeKey = 'active';
  static const _inactiveKey = 'inactive';

  late String _selectedKey;

  @override
  void initState() {
    super.initState();
    final filter = widget.current.isActiveFilter;
    if (filter == true) {
      _selectedKey = _activeKey;
    } else if (filter == false) {
      _selectedKey = _inactiveKey;
    } else {
      _selectedKey = _activeKey;
    }
  }

  void _apply(BuildContext sheetContext) {
    final isActiveFilter = _selectedKey == _activeKey;
    final bloc = sheetContext.read<ListMerchantBloc>();
    Navigator.of(sheetContext).pop();
    bloc.add(
      GetMerchantsEvent(
        search: widget.current.search,
        isActiveFilter: isActiveFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              text: AppTranslation.merchantsFilterTitle,
              textStyle: getBoldStyle(
                fontSize: AppFontSize.s18,
                color: ColorManager.titlesColor,
              ),
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              value: _activeKey,
              groupValue: _selectedKey,
              onChanged: (v) => setState(() => _selectedKey = v ?? _activeKey),
              fillColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? ColorManager.primary.withValues(alpha: 0.15)
                    : null,
              ),
              title: CustomText(
                text: AppTranslation.merchantsFilterActive,
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.textColor,
                ),
              ),
            ),
            RadioListTile<String>(
              value: _inactiveKey,
              groupValue: _selectedKey,
              onChanged: (v) =>
                  setState(() => _selectedKey = v ?? _inactiveKey),
              fillColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? ColorManager.primary.withValues(alpha: 0.15)
                    : null,
              ),
              title: CustomText(
                text: AppTranslation.merchantsFilterInactive,
                textStyle: getRegularStyle(
                  fontSize: AppFontSize.s14,
                  color: ColorManager.textColor,
                ),
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
                text: AppTranslation.merchantsFilterApply,
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
