import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

Widget titleValueWidget({required String title, required String value}) {
  return Row(
    children: [
      CustomText(
        text: title,
        textStyle: getMediumStyle(
          fontSize: AppFontSize.s12,
          color: ColorManager.backgroundDark,
        ),
      ),
      CustomText(
        text: value,
        textStyle: getRegularStyle(
          fontSize: AppFontSize.s14,
          color: ColorManager.descriptionColor,
        ),
      ),
    ],
  );
}
