import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

class ProfileSendNotificationTile extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileSendNotificationTile({super.key, required this.onTap});

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
              Icons.notifications_active_outlined,
              size: 20,
              color: ColorManager.primary,
            ),
            SizedBox(width: AppWidth.s8),
            CustomText(
              text: AppTranslation.sendNotification,
              textStyle: getMediumStyle(
                color: ColorManager.primary,
                fontSize: AppFontSize.s15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
