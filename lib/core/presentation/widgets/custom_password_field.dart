import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:easy_localization/easy_localization.dart' as ea;

/// Password field matching [CustomTextField] look with show/hide toggle.
class CustomPasswordField extends StatefulWidget {
  final String? title;
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomPasswordField({
    super.key,
    this.title,
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isRTL = context.locale.languageCode == 'ar';
    final textDirection = isRTL ? TextDirection.rtl : TextDirection.ltr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null)
          CustomText(
            text: widget.title!,
            textStyle: getMediumStyle(
              fontSize: AppFontSize.s15,
              color: ColorManager.defaultWhite,
            ),
          ),
        if (widget.title != null) SizedBox(height: AppHeight.s8),
        TextField(
          textDirection: textDirection,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: _obscure,
          decoration: InputDecoration(
            hintText: widget.hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r18),
              borderSide: BorderSide(color: ColorManager.primary),
            ),
            hintStyle: getRegularStyle(
              color: ColorManager.descriptionColor,
              fontSize: AppFontSize.s13,
            ),
            hintTextDirection: textDirection,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppPadding.p16,
              vertical: AppHeight.s16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r18),
              borderSide: BorderSide(color: ColorManager.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r18),
              borderSide: BorderSide(color: ColorManager.primary),
            ),
            filled: true,
            fillColor: ColorManager.transparent,
            suffixIcon: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: ColorManager.descriptionColor,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          style: getRegularStyle(
            fontSize: AppFontSize.s14,
            color: ColorManager.defaultWhite,
          ),
        ),
      ],
    );
  }
}
