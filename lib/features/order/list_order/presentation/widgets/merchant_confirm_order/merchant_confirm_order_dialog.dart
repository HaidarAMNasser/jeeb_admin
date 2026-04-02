import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

/// Meal prep minutes for PATCH /orders/:id/confirm. Null if cancelled.
class MerchantConfirmOrderResult {
  const MerchantConfirmOrderResult({required this.mealPreparationMinutes});

  final int mealPreparationMinutes;
}

int? _parsePositiveMinutes(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  final v = int.tryParse(t);
  if (v == null || v <= 0) return null;
  return v;
}

/// Same shell as [LanguageSelectionDialog].
Future<MerchantConfirmOrderResult?> showMerchantConfirmOrderDialog(
  BuildContext context,
) {
  return showDialog<MerchantConfirmOrderResult>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => const _MerchantConfirmOrderDialog(),
  );
}

class _MerchantConfirmOrderDialog extends StatefulWidget {
  const _MerchantConfirmOrderDialog();

  @override
  State<_MerchantConfirmOrderDialog> createState() =>
      _MerchantConfirmOrderDialogState();
}

class _MerchantConfirmOrderDialogState extends State<_MerchantConfirmOrderDialog> {
  late final TextEditingController _minutesCtrl;

  @override
  void initState() {
    super.initState();
    _minutesCtrl = TextEditingController();
    _minutesCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _minutesCtrl.dispose();
    super.dispose();
  }

  bool get _valid => _parsePositiveMinutes(_minutesCtrl.text) != null;

  void _submit() {
    final m = _parsePositiveMinutes(_minutesCtrl.text);
    if (m == null) return;
    Navigator.of(context).pop(MerchantConfirmOrderResult(mealPreparationMinutes: m));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: Container(
        padding: EdgeInsets.all(AppPadding.p24),
        decoration: BoxDecoration(
          color: ColorManager.background,
          borderRadius: BorderRadius.circular(AppRadius.r20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              text: AppTranslation.confirmOrderAction,
              textStyle: getBoldStyle(
                fontSize: AppFontSize.s18,
                color: ColorManager.titlesColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppHeight.s24),
            Container(
              padding: EdgeInsets.all(AppPadding.p16),
              decoration: BoxDecoration(
                color: ColorManager.background,
                border: Border.all(
                  color: ColorManager.borderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                    text: AppTranslation.mealPreparationMinutes,
                    textStyle: getSemiBoldStyle(
                      fontSize: AppFontSize.s14,
                      color: ColorManager.titlesColor,
                    ),
                  ),
                  SizedBox(height: AppHeight.s8),
                  TextField(
                    controller: _minutesCtrl,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: getRegularStyle(
                      fontSize: AppFontSize.s18,
                      color: ColorManager.titlesColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: AppTranslation.merchantConfirmMealPrepHint,
                      hintStyle: getRegularStyle(
                        fontSize: AppFontSize.s16,
                        color: ColorManager.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) {
                      if (_valid) _submit();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: AppHeight.s8),
            CustomText(
              text: AppTranslation.merchantConfirmMealPrepRequired,
              textStyle: getRegularStyle(
                fontSize: AppFontSize.s11,
                color: ColorManager.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppHeight.s24),
            CustomButton(
              text: AppTranslation.confirmOrderAction,
              onPressed: _valid ? _submit : null,
              color: ColorManager.primary,
            ),
            SizedBox(height: AppHeight.s16),
            CustomButton(
              text: AppTranslation.close,
              onPressed: () => Navigator.of(context).pop(),
              isOutlined: true,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }
}
