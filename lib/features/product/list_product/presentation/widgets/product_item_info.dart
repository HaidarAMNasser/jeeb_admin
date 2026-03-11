import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

class ProductItemInfo extends StatelessWidget {
  final String name;
  final String? description;

  const ProductItemInfo({
    super.key,
    required this.name,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: name,
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s18,
            color: ColorManager.productNameColor,
          ),
          maxLines: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        if (description != null) ...[
          SizedBox(height: AppHeight.s4),
          CustomText(
            text: description!,
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s12,
              color: ColorManager.descriptionColor,
            ),
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
