import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        title: CustomText(
          text: 'Delivery',
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s24,
            color: ColorManager.titlesColor,
          ),
        ),
      ),
      body: Center(
        child: CustomText(
          text: 'Delivery Screen\nComing Soon',
          textStyle: getRegularStyle(
            fontSize: AppFontSize.s16,
            color: ColorManager.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

