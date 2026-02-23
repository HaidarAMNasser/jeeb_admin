import 'package:fatoorahapp/widgets/helpful_widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:flutter/services.dart';

Widget quantityPriceWidget(
  TextEditingController quantityController,
  TextEditingController priceController, {
  required ValueChanged<String> onQuantityChanged,
  required ValueChanged<String> onPriceChanged,
  String? priceHintText,
}) {
  return Row(
    children: [
      Expanded(
        child: CustomTextFieldWidget(
          erroStyle: const TextStyle(height: 0),
          hasBorder: true,
          controller: quantityController,
          onChanged: onQuantityChanged,
          title: TranslationsController.instance.getTranslations().quantity,
          keyboardType: TextInputType.numberWithOptions(decimal: false),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          hint: '0',
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: CustomTextFieldWidget(
          hasBorder: true,
          controller: priceController,
          onChanged: onPriceChanged,
          title: TranslationsController.instance.getTranslations().unitPrice,
          keyboardType: TextInputType.number,
          hint: priceHintText ?? '0',
        ),
      ),
    ],
  );
}
