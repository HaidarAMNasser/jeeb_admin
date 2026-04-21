import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/infrastructure/di/dependency_injection.dart'
    as di;
import 'package:jeeb_admin/core/infrastructure/services/storage_service.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/confirmation_dialog.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_cached_network_image.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/auth/login/domain/entities/user_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_payment_receipt_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/order/confirm_paid_order/presentation/bloc/confirm_paid_order_bloc.dart';

/// Payment receipt thumbnails and admin-only action to mark a PAID order as COMPLETE.
class OrderPaidReceiptsAdminSection extends StatelessWidget {
  final OrderEntity order;

  const OrderPaidReceiptsAdminSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: di.sl<StorageService>().getUserRole(),
      builder: (context, snapshot) {
        final role = snapshot.data?.toLowerCase();
        final isAdmin = role == UserRole.admin.name;
        if (!isAdmin || !order.statusEnum.canAdminConfirmPaidComplete) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (order.receipts.isNotEmpty) ...[
              CustomText(
                text: AppTranslation.paymentReceipts,
                textStyle: getSemiBoldStyle(
                  fontSize: AppFontSize.s16,
                  color: ColorManager.textColor,
                ),
              ),
              SizedBox(height: AppHeight.s12),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: order.receipts.length,
                  separatorBuilder: (context, _) =>
                      SizedBox(width: AppWidth.s12),
                  itemBuilder: (context, index) {
                    final r = order.receipts[index];
                    return _ReceiptTile(receipt: r);
                  },
                ),
              ),
              SizedBox(height: AppHeight.s20),
            ],
            CustomButton(
              text: AppTranslation.confirmOrderPaidComplete,
              color: ColorManager.primary,
              onPressed: () => _confirm(context),
            ),
            SizedBox(height: AppHeight.s8),
          ],
        );
      },
    );
  }

  void _confirm(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: AppTranslation.areYouSureConfirmPaidComplete,
        onConfirm: () {
          Navigator.of(ctx).pop();
          context.read<ConfirmPaidOrderBloc>().add(
            ConfirmPaidOrderSubmitted(
              orderId: order.id,
              imagePayFromDelivery: order.imagePayFromDelivery,
            ),
          );
        },
      ),
    );
  }
}

class _ReceiptTile extends StatelessWidget {
  final OrderPaymentReceiptEntity receipt;

  const _ReceiptTile({required this.receipt});

  @override
  Widget build(BuildContext context) {
    final url = receipt.fullImageUrl;
    if (url.isEmpty) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openFullScreen(context, url),
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          child: CustomCachedNetworkImage(
            imageUrl: url,
            width: 110,
            height: 140,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final size = MediaQuery.sizeOf(ctx);
        return Dialog(
          insetPadding: EdgeInsets.all(AppPadding.p16),
          backgroundColor: Colors.black87,
          child: SizedBox(
            width: size.width * 0.95,
            height: size.height * 0.85,
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4,
                    child: CustomCachedNetworkImage(
                      imageUrl: url,
                      width: size.width * 0.9,
                      height: size.height * 0.75,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
