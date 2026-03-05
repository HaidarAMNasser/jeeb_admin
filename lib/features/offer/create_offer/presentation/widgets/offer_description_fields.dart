import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

class OfferDescriptionFields extends StatelessWidget {
  final TextEditingController shortDescController;
  final TextEditingController longDescController;
  final void Function(String) onShortDescChanged;
  final void Function(String) onLongDescChanged;

  const OfferDescriptionFields({
    super.key,
    required this.shortDescController,
    required this.longDescController,
    required this.onShortDescChanged,
    required this.onLongDescChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          title: AppTranslation.offerShortDescription,
          hintText: AppTranslation.offerShortDescription,
          controller: shortDescController,
          onChanged: onShortDescChanged,
        ),
        SizedBox(height: AppHeight.s16),
        CustomTextField(
          title: AppTranslation.offerLongDescription,
          hintText: AppTranslation.offerLongDescription,
          controller: longDescController,
          onChanged: onLongDescChanged,
        ),
        SizedBox(height: AppHeight.s16),
      ],
    );
  }
}
