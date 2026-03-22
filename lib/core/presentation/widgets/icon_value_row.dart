import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';

/// Horizontal row: [icon] gap [value text]. Value expands and ellipsizes by default.
class IconValueRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final double iconSize;
  final Color iconColor;
  final TextStyle? valueStyle;
  final bool expandValue;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final CrossAxisAlignment crossAxisAlignment;

  const IconValueRow({
    super.key,
    required this.icon,
    required this.value,
    this.iconSize = AppSize.s16,
    this.iconColor = ColorManager.descriptionColor,
    this.valueStyle,
    this.expandValue = true,
    this.maxLines,
    this.textOverflow,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final text = CustomText(
      text: value,
      textStyle: valueStyle ??
          getRegularStyle(
            fontSize: AppFontSize.s12,
            color: ColorManager.descriptionColor,
          ),
      maxLines: maxLines,
      textOverflow: textOverflow,
    );

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(width: AppWidth.s4),
        if (expandValue) Expanded(child: text) else text,
      ],
    );
  }
}
