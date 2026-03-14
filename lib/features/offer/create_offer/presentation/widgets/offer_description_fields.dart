import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

class OfferDescriptionFields extends StatelessWidget {
  final TextEditingController descriptionController;
  final void Function(String) onDescriptionChanged;

  const OfferDescriptionFields({
    super.key,
    required this.descriptionController,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      title: AppTranslation.offerDescription,
      hintText: AppTranslation.offerDescription,
      controller: descriptionController,
      onChanged: onDescriptionChanged,
    );
  }
}
