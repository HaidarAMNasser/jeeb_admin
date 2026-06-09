import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';

class AreaItemInfo extends StatelessWidget {
  final AreaEntity area;

  const AreaItemInfo({
    super.key,
    required this.area,
  });

  bool get _hasDescription =>
      area.description != null && area.description!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomText(
                text: area.name,
                textStyle: getBoldStyle(
                  fontSize: AppFontSize.s18,
                  color: ColorManager.productNameColor,
                ),
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: AppMargin.m8),
            CustomText(
              text: 'SYP ${(area.price / 100).toStringAsFixed(2)}',
              textStyle: getBoldStyle(
                fontSize: AppFontSize.s20,
                color: ColorManager.primary,
              ),
            ),
          ],
        ),
        if (_hasDescription) ...[
          SizedBox(height: AppHeight.s4),
          CustomText(
            text: area.description!,
            textStyle: getRegularStyle(),
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
