import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/common/utils/asset_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';

/// Hero card: step image fills the rounded card.
class OrderStatusHeroImage extends StatelessWidget {
  const OrderStatusHeroImage({super.key, required this.timelineStepIndex});

  final int timelineStepIndex;

  @override
  Widget build(BuildContext context) {
    final idx = timelineStepIndex.clamp(0, 6);
    final path = ImageAsset.timelineStepImagePath(idx);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(AppRadius.r60),
        bottomRight: Radius.circular(AppRadius.r60),
      ),
      child: AspectRatio(
        aspectRatio: 1.15,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              path,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF3A3836),
                alignment: Alignment.center,
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.1),
                  radius: 1.05,
                  colors: [Color(0x00000000), Color(0x332E2C2A)],
                  stops: [0.55, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
