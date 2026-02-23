import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/helpful_funcations/price_perecentage_to_value.dart';
import 'package:fatoorahapp/core/helpful_funcations/smart_scrollable_text.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/widgets/custom_drop_down_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/custom_text_field_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisCountWidget extends StatefulWidget {
  final bool isEditMode;
  final TextEditingController discountValueController;
  final String? initOption;
  final Function(DisCountType) onSetDiscountType;
  final ValueChanged<String> onSetValue;
  final String? highestDiscountRate;
  final String? selectedDiscountTypeId;
  final String? saleProductPrice;
  final String? hintText;

  const DisCountWidget({
    Key? key,
    required this.isEditMode,
    required this.discountValueController,
    required this.initOption,
    required this.onSetDiscountType,
    required this.onSetValue,
    required this.highestDiscountRate,
    required this.selectedDiscountTypeId,
    this.saleProductPrice,
    this.hintText,
  }) : super(key: key);

  @override
  State<DisCountWidget> createState() => _DisCountWidgetState();
}

class _DisCountWidgetState extends State<DisCountWidget> {
  late final VoidCallback _discountTextListener;
  @override
  void initState() {
    super.initState();
    _discountTextListener = () {
      setState(() {});
    };
    widget.discountValueController.addListener(_discountTextListener);
  }

  @override
  void dispose() {
    widget.discountValueController.removeListener(_discountTextListener);
    super.dispose();
  }

  String _getHintText() {
    if (widget.highestDiscountRate == null ||
        num.tryParse(widget.highestDiscountRate!) == 0 ||
        widget.selectedDiscountTypeId == null) {
      return '0';
    }
    final highestRate = num.tryParse(widget.highestDiscountRate!) ?? 0;
    final productPrice = num.tryParse(widget.saleProductPrice ?? '0') ?? 0;

    if (widget.selectedDiscountTypeId == "1") {
      // Value discount - calculate the maximum value based on percentage
      if (productPrice > 0) {
        final maxValue = calculateDiscountValue(
          finalPrice: productPrice,
          discountPercent: highestRate,
        );
        return "${TranslationsController.instance.getTranslations().maximumDiscountPercentage} ${maxValue.toStringAsFixed(2)}";
      } else {
        return "${TranslationsController.instance.getTranslations().maximumDiscountPercentage} ${widget.highestDiscountRate}%";
      }
    } else if (widget.selectedDiscountTypeId == "2") {
      // Percentage discount - show the percentage directly
      return "${TranslationsController.instance.getTranslations().maximumDiscountPercentage} ${widget.highestDiscountRate}%";
    }

    return "${TranslationsController.instance.getTranslations().maximumDiscountPercentage} ${widget.highestDiscountRate}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: AppSize.s10),
            child: CustomDropDownWidget(
              fromId: true,
              initOption: widget.initOption,
              height: 47.h,
              border: Border.all(color: ColorManager.borderColor),
              borderRadius: AppRadius.r20.sp,
              title: TranslationsController.instance
                  .getTranslations()
                  .discountType,
              isRequired: false,
              color: ColorManager.white,
              hintText: TranslationsController.instance
                  .getTranslations()
                  .discountType,
              dropDownList: LocalData.instance.disCountTypes,
              onSelectItem: (val) {
                widget.onSetDiscountType(val);
              },
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Stack(
            children: [
              CustomTextFieldWidget(
                isFieldRequired: false,
                // titleFontSize: AppSize.s12,
                onChanged: widget.onSetValue,
                withValidator: false,
                hasBorder: true,
                controller: widget.discountValueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                title: TranslationsController.instance.getTranslations().discount,
                hint: '', // Empty hint since we'll show custom hint
              ),
              if (widget.discountValueController.text.isEmpty)
                Positioned(
                  right: 16.w,
                  top: 35.h, // Adjust based on your text field height
                  child: IgnorePointer(
                    ignoring: true,
                    child: SmartScrollableText(
                      maxWidth: 200.w, // Adjust based on your text field width
                      child: CustomText(
                        text: widget.hintText ?? _getHintText(),
                        textStyle: TextStyle(
                          color: ColorManager.hintColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
