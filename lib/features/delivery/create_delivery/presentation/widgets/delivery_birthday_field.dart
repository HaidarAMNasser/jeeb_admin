import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

/// Birthday input split into year, month, and day fields.
/// Syncs the combined value into [birthdayController] for existing submit logic.
class DeliveryBirthdayField extends StatefulWidget {
  final TextEditingController birthdayController;

  const DeliveryBirthdayField({super.key, required this.birthdayController});

  @override
  State<DeliveryBirthdayField> createState() => _DeliveryBirthdayFieldState();
}

class _DeliveryBirthdayFieldState extends State<DeliveryBirthdayField> {
  late final TextEditingController _yearController;
  late final TextEditingController _monthController;
  late final TextEditingController _dayController;

  @override
  void initState() {
    super.initState();
    _yearController = TextEditingController();
    _monthController = TextEditingController();
    _dayController = TextEditingController();
    _splitInitialValue(widget.birthdayController.text);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  void _splitInitialValue(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 8) {
      _yearController.text = digits.substring(0, 4);
      _monthController.text = digits.substring(4, 6);
      _dayController.text = digits.substring(6, 8);
    }
  }

  void _syncToBirthdayController() {
    final year = _yearController.text.trim();
    final month = _monthController.text.trim();
    final day = _dayController.text.trim();

    if (year.isEmpty && month.isEmpty && day.isEmpty) {
      widget.birthdayController.text = '';
      return;
    }

    if (year.length == 4 && month.isNotEmpty && day.isNotEmpty) {
      widget.birthdayController.text =
          '$year${month.padLeft(2, '0')}${day.padLeft(2, '0')}';
    } else {
      widget.birthdayController.text = '$year$month$day';
    }
  }

  void _onYearChanged(String _) => _syncToBirthdayController();

  void _onMonthChanged(String _) => _syncToBirthdayController();

  void _onDayChanged(String _) => _syncToBirthdayController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomText(
          text: AppTranslation.deliveryBirthday,
          textStyle: getMediumStyle(
            fontSize: AppFontSize.s15,
            color: ColorManager.defaultWhite,
          ),
        ),
        SizedBox(height: AppHeight.s8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: CustomTextField(
                title: AppTranslation.deliveryBirthdayYear,
                controller: _yearController,
                hintText: '2003',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                onChanged: _onYearChanged,
              ),
            ),
            SizedBox(width: AppWidth.s12),
            Expanded(
              flex: 2,
              child: CustomTextField(
                title: AppTranslation.deliveryBirthdayMonth,
                controller: _monthController,
                hintText: '03',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                onChanged: _onMonthChanged,
              ),
            ),
            SizedBox(width: AppWidth.s12),
            Expanded(
              flex: 2,
              child: CustomTextField(
                title: AppTranslation.deliveryBirthdayDay,
                controller: _dayController,
                hintText: '03',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                onChanged: _onDayChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
