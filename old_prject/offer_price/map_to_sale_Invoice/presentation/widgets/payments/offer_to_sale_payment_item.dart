import 'package:fatoorahapp/core/classes/entities/bank_account_entity.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/bloc/offer_to_sale_Invoice_bloc.dart';
import 'package:fatoorahapp/feature/payment_method/domain/entities/payment_methods_entity.dart';
import 'package:fatoorahapp/feature/payment_method/presentation/widgets/payment_methods_widget.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/custom_text_field_widget.dart';
import 'package:fatoorahapp/widgets/payments/show_additional_option.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferToSalePaymentMethodWidget extends StatefulWidget {
  final Function(PaymentMethodsDataEntity) onSelectPayment;
  final PaymentMethodEntryOffer item;
  final VoidCallback onDelete;
  final int index;
  final String? initOption;
  final String? initBank;
  final String? initTreasury;
  final String? initDate;
  final List<BankAccountEntity>? banks;
  final void Function({
    String? value,
    String? percent,
    String? date,
    String? note,
  })?
  onGuaranteeChanged;
  const OfferToSalePaymentMethodWidget({
    required this.onSelectPayment,
    required this.item,
    required this.onDelete,
    required this.index,
    this.initOption,
    this.initBank,
    this.initDate,
    this.initTreasury,
    this.banks,
    super.key,
    this.onGuaranteeChanged,
  });

  @override
  State<OfferToSalePaymentMethodWidget> createState() =>
      _OfferToSalePaymentMethodWidgetState();
}

class _OfferToSalePaymentMethodWidgetState
    extends State<OfferToSalePaymentMethodWidget> {
  TextEditingController _amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.item.amount?.text ?? '',
    );
  }

  @override
  void didUpdateWidget(OfferToSalePaymentMethodWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final blocText = widget.item.amount?.text ?? '';
    if (_amountController.text != blocText) {
      // Defer the controller update until after the current build phase
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted && _amountController.text != blocText) {
          _amountController.text = blocText;
          _amountController.selection = TextSelection.fromPosition(
            TextPosition(offset: _amountController.text.length),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _calculatePercentFromValue(String valueText) {
    final totalAmount = context.read<MapOfferToInvoiceBloc>().state.finalAmount;
    final value = num.tryParse(valueText.trim()) ?? 0;
    if (value > 0 && totalAmount > 0) {
      final percent = (value / totalAmount) * 100;
      return percent.clamp(0, 100).toStringAsFixed(2);
    }
    return '0.00';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PaymentMethodsWidget(
                initOption: widget.initOption,

                // initOption: matchingPaymentMethod?.name ??
                //     (widget.item.paymentType.isNotEmpty
                //         ? widget.item.paymentType
                //         : null),
                isRequired: true,
                onPaymentMethodSelection: (val) {
                  this.widget.onSelectPayment(val);
                },
              ),
              flex: 2,
            ),

            SizedBox(width: 18.w),
            Padding(
              padding: EdgeInsets.only(top: AppSize.s22.h),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(AppRadius.r20.r),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppSize.s5.h),
                  child: IconButton(
                    onPressed: () {
                      widget.onDelete();
                    },
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      size: AppSize.s22.h,
                      color: ColorManager.red.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(height: 8.h),
        CustomTextFieldWidget(
          hasBorder: true,
          borderColor: ColorManager.borderColor,
          controller: _amountController,
          keyboardType: TextInputType.number,
          onChanged: (val) {
            // Calculate percent for guarantee payment (ID 8)
            String? calculatedPercent;
            if (widget.item.effectivePaymentMethodId == '8') {
              final totalAmount = context
                  .read<MapOfferToInvoiceBloc>()
                  .state
                  .finalAmount;
              final amount = num.tryParse(val.trim()) ?? 0;
              if (amount > 0 && totalAmount > 0) {
                final percent = (amount / totalAmount) * 100;
                calculatedPercent = percent.clamp(0, 100).toStringAsFixed(2);
              }
            }

            context.read<MapOfferToInvoiceBloc>().add(
              EditPaymentInOfferInvoice(
                index: widget.index,
                payment: PaymentMethodEntryOffer(
                  id: widget.item.id,
                  paymentType: widget.item.paymentType,
                  type: widget.item.type, // Preserve
                  parentId: widget.item.parentId, // Preserve
                  bankId: widget.item.bankId,
                  bankName: widget.item.bankName,
                  dueDate: widget.item.dueDate,
                  amount: TextEditingController(text: val),
                  note: widget.item.note,
                  guaranteePercent:
                      calculatedPercent ??
                      widget.item.guaranteePercent, // Save percentage
                ),
              ),
            );
          },
          title: TranslationsController.instance.getTranslations().value,
          hint: '0.0',
          isFieldRequired: true,
        ),
        verticalSpace(height: 16.h),
        showAddiotionalOption(
          id: widget.item.effectivePaymentMethodId,
          onBankSelection: (val) {
            context.read<MapOfferToInvoiceBloc>().add(
              EditPaymentInOfferInvoice(
                index: widget.index,
                payment: PaymentMethodEntryOffer(
                  id: widget.item.id,
                  paymentType: widget.item.paymentType,
                  type: widget.item.type, // Preserve
                  parentId: widget.item.parentId, // Preserve
                  amount: widget.item.amount,
                  bankId: val.id.toString(),
                  bankName: val.name,
                  dueDate: widget.item.dueDate, // Preserve
                  note: widget.item.note, // Preserve
                  guaranteePercent: widget.item.guaranteePercent, // Preserve
                ),
              ),
            );
          },
          preventSelection: true,
          onDateSelection: (val) {
            context.read<MapOfferToInvoiceBloc>().add(
              EditPaymentInOfferInvoice(
                index: widget.index,
                payment: PaymentMethodEntryOffer(
                  id: widget.item.id,
                  paymentType: widget.item.paymentType,
                  type: widget.item.type, // Preserve
                  parentId: widget.item.parentId, // Preserve
                  amount: widget.item.amount,
                  dueDate: val,
                  bankId: widget.item.bankId, // Preserve
                  bankName: widget.item.bankName, // Preserve
                  note: widget.item.note, // Preserve
                  guaranteePercent: widget.item.guaranteePercent, // Preserve
                ),
              ),
            );
          },
          initGuaranteeDate: widget.initDate,
          initGuaranteeNote: widget.item.note,
          initBankOption: widget.initBank,
          initDateOption: widget.initDate,
          initTreasuryOption: widget.initTreasury,
          // Business Guarantee (id == '8') support
          totalAmount: context.read<MapOfferToInvoiceBloc>().state.finalAmount,
          onGuaranteeChanged:
              ({String? value, String? percent, String? date, String? note}) {
                // Update amount with value; update dueDate with date if provided
                final updatedAmount = (value ?? widget.item.amount?.text ?? '')
                    .trim();
                final updatedDate = date ?? widget.item.dueDate;
                final updatedNote = note ?? widget.item.note;
                context.read<MapOfferToInvoiceBloc>().add(
                  EditPaymentInOfferInvoice(
                    index: widget.index,
                    payment: PaymentMethodEntryOffer(
                      id: widget.item.id,
                      paymentType: widget.item.paymentType,
                      type: widget.item.type, // Preserve
                      parentId: widget.item.parentId, // Preserve
                      bankId: widget.item.bankId,
                      bankName: widget.item.bankName,
                      dueDate: updatedDate,
                      note: updatedNote,
                      amount: TextEditingController(text: updatedAmount),
                      guaranteePercent: percent, // Save the percentage
                    ),
                  ),
                );
              },
          initGuaranteeValue: widget.item.amount?.text,
          initGuaranteePercent:
              widget.item.guaranteePercent ?? // Use stored percent first
              (widget.item.amount?.text != null &&
                      widget.item.amount!.text.isNotEmpty
                  ? _calculatePercentFromValue(widget.item.amount!.text)
                  : null),
        ),
      ],
    );
  }
}
