import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import '../../../login/domain/entities/user_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;
  final VoidCallback? onPickImage;

  const ProfileHeader({super.key, required this.user, this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.defaultYellow, ColorManager.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(AppRadius.r18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: ColorManager.defaultWhite,
              child: user.firstName.isNotEmpty
                  ? CustomText(
                      textAlign: TextAlign.center,
                      text: user.firstName[0].toUpperCase(),
                      textStyle: getBoldStyle(
                        fontSize: AppFontSize.s24,
                        color: ColorManager.titlesColor,
                      ),
                    )
                  : Icon(Icons.add_a_photo, size: 32, color: ColorManager.titlesColor),
            ),
          ),
          SizedBox(height: AppHeight.s16),
          CustomText(
            text: user.fullName,
            textStyle: getMediumStyle (
              fontSize: AppFontSize.s20,
              color: ColorManager.titlesColor,
            ),
          ),
          SizedBox(height: AppHeight.s8),
          CustomText(
            text: user.email,
            textStyle: getRegularStyle(
              fontSize: AppFontSize.s14,
              color: ColorManager.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
