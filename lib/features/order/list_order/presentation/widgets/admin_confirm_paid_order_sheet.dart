import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/features/order/confirm_paid_order/presentation/bloc/confirm_paid_order_bloc.dart';
import 'package:jeeb_admin/features/order/order_details/domain/entities/order_entity.dart';

/// Bottom sheet: payment screenshot + confirm (admin, [OrderStatus.paid] only).
Future<void> showAdminConfirmPaidOrderSheet(
  BuildContext context,
  OrderEntity order,
) {
  final confirmBloc = context.read<ConfirmPaidOrderBloc>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorManager.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return BlocProvider.value(
        value: confirmBloc,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: AppPadding.p16,
              right: AppPadding.p16,
              top: AppPadding.p12,
              bottom:
                  MediaQuery.paddingOf(sheetContext).bottom + AppPadding.p16,
            ),
            child: BlocListener<ConfirmPaidOrderBloc, ConfirmPaidOrderState>(
              listenWhen: (prev, curr) =>
                  curr is ConfirmPaidOrderSuccess ||
                  (curr is ConfirmPaidOrderError &&
                      prev is ConfirmPaidOrderLoading),
              listener: (context, state) {
                if (state is ConfirmPaidOrderSuccess) {
                  Navigator.of(sheetContext).pop();
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: AppMargin.m12),
                      decoration: BoxDecoration(
                        color: ColorManager.textSecondary.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  CustomText(
                    text: 'تأكيد استلام دفعة المندوب',
                    textStyle: getBoldStyle(
                      fontSize: AppFontSize.s18,
                      color: ColorManager.titlesColor,
                    ),
                  ),
                  SizedBox(height: AppHeight.s12),
                  CustomText(
                    text:
                        'مراجعة صورة الإيصال أدناه، ثم اضغط تأكيد لإتمام الطلب.',
                    textStyle: getRegularStyle(
                      fontSize: AppFontSize.s14,
                      color: ColorManager.textColor,
                    ),
                  ),
                  SizedBox(height: AppHeight.s16),
                  _PaymentScreenshotPreview(url: order.imagePayFromDelivery),
                  SizedBox(height: AppHeight.s20),
                  FilledButton(
                    onPressed: () {
                      sheetContext.read<ConfirmPaidOrderBloc>().add(
                            ConfirmPaidOrderSubmitted(
                              orderId: order.id,
                              imagePayFromDelivery: order.imagePayFromDelivery,
                            ),
                          );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      foregroundColor: ColorManager.surface,
                      padding: EdgeInsets.symmetric(vertical: AppPadding.p14),
                    ),
                    child: CustomText(
                      text: 'تأكيد',
                      textStyle: getSemiBoldStyle(
                        fontSize: AppFontSize.s16,
                        color: ColorManager.surface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _PaymentScreenshotPreview extends StatelessWidget {
  const _PaymentScreenshotPreview({this.url});

  final String? url;

  void _openLarge(BuildContext context, String imageUrl) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black87,
        insetPadding: EdgeInsets.all(AppPadding.p16),
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.broken_image_outlined, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = url?.trim();
    if (u == null || u.isEmpty) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorManager.textSecondary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(
            color: ColorManager.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: CustomText(
          text: 'لا توجد صورة بعد',
          textStyle: getMediumStyle(
            fontSize: AppFontSize.s14,
            color: ColorManager.textSecondary,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openLarge(context, u),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: Image.network(
          u,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 180,
            alignment: Alignment.center,
            color: ColorManager.textSecondary.withValues(alpha: 0.08),
            child: Icon(
              Icons.broken_image_outlined,
              color: ColorManager.textSecondary,
              size: AppSize.s50,
            ),
          ),
        ),
      ),
    );
  }
}
