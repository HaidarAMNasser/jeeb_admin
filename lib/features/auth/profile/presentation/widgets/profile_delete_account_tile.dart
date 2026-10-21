import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

class ProfileDeleteAccountTile extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileDeleteAccountTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppPadding.p8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_outline,
              size: 20,
              color: ColorManager.errorColor,
            ),
            SizedBox(width: AppWidth.s8),
            CustomText(
              text: AppTranslation.deleteAccount,
              textStyle: getMediumStyle(
                color: ColorManager.errorColor,
                fontSize: AppFontSize.s15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
