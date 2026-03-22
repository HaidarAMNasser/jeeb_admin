import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_cached_network_image.dart';

class DeliveryListItemAvatar extends StatelessWidget {
  final String? imageUrl;

  const DeliveryListItemAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final size = AppWidth.s50;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomCachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          width: size,
          height: size,
          borderRadius: BorderRadius.circular(size / 2),
          errorWidget: _placeholder(size),
        ),
      );
    }
    return _placeholder(size);
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ColorManager.background,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.delivery_dining,
        color: ColorManager.primary,
        size: AppSize.s28,
      ),
    );
  }
}
