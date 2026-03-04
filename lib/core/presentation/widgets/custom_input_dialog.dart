import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

/// A reusable input dialog with a single text field.
class CustomInputDialog extends StatefulWidget {
  final String title;
  final String? label;
  final String? hintText;
  final String? initialValue;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomInputDialog({
    super.key,
    required this.title,
    this.label,
    this.hintText,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  /// Shows the dialog and returns the entered text if confirmed, otherwise null.
  static Future<String?> show({
    required BuildContext context,
    required String title,
    String? label,
    String? hintText,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => CustomInputDialog(
        title: title,
        label: label,
        hintText: hintText,
        initialValue: initialValue,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  @override
  State<CustomInputDialog> createState() => _CustomInputDialogState();
}

class _CustomInputDialogState extends State<CustomInputDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorManager.surface,
      title: Text(
        widget.title,
        style: getMediumStyle(
          fontSize: AppFontSize.s20,
          color: ColorManager.textDarkColor,
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hintText,
          ),
          validator: widget.validator,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppTranslation.cancel,
            style: TextStyle(color: ColorManager.textSecondary),
          ),
        ),
        TextButton(
          onPressed: _onConfirm,
          child: Text(
            AppTranslation.confirm,
            style: TextStyle(color: ColorManager.primary),
          ),
        ),
      ],
    );
  }
}

