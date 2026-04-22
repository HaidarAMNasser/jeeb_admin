import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/common/utils/clipboard_util.dart';

class MerchantListItemPhoneBadge extends StatelessWidget {
  final String phoneNumber;

  const MerchantListItemPhoneBadge({super.key, required this.phoneNumber});

  static double get width => 110.w;

  /// End padding for the header row so text does not run under the badge.
  static double reserveEndPadding(bool hasPhone) => hasPhone ? width + 8.w : 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          copyTextToClipboard(phoneNumber);
        },
        borderRadius: BorderRadius.circular(AppRadius.r12),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: SizedBox(
          width: width,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p8,
              vertical: AppHeight.s5,
            ),
            decoration: BoxDecoration(
              color: ColorManager.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.r12),
              border: Border.all(color: ColorManager.primary, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.phone,
                  size: AppSize.s14,
                  color: ColorManager.primary,
                ),
                SizedBox(width: AppWidth.s5),
                Expanded(
                  child: CustomText(
                    text: phoneNumber,
                    textStyle: getRegularStyle(
                      fontSize: AppFontSize.s10,
                      color: ColorManager.primary,
                    ),
                    maxLines: 1,
                    softWrap: false,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
