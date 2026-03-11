import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  /// When set, a "Retry" button is shown; on press re-fetches the list.
  final VoidCallback? onPress;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSize.s60,
              color: ColorManager.descriptionColor,
            ),
            SizedBox(height: AppHeight.s16),
            CustomText(
              text: message,
              textStyle: getRegularStyle(
                fontSize: AppFontSize.s16,
                color: ColorManager.descriptionColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onPress != null) ...[
              SizedBox(height: AppHeight.s24),
              CustomButton(
                text: AppTranslation.retry,
                onPressed: onPress!,
                isLoading: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

