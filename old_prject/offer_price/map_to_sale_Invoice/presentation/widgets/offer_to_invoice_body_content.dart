import 'package:flutter/material.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/bloc/offer_to_sale_Invoice_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatoorahapp/core/classes/entities/sale_invoice_entity.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/feature/admin/presentation/widgets/admin_widget.dart';
import 'package:fatoorahapp/feature/bonds/create_bonds/presentation/widgets/select_date_widget.dart';
import 'package:fatoorahapp/feature/clients/clients/presentation/widgets/clients_widget.dart';
import 'package:fatoorahapp/feature/discount_reason/presentation/bloc/discount_reason_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/add_produt_presentation/add_product_bloc/add_product_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/widgets/payments/offer_to_invoice_paytment_section.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/widgets/products/add_offet_to_sale_product_sheet.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/widgets/products/offer_to_invoice_product_widget.dart';
import 'package:fatoorahapp/feature/products/products/presentation/blocs/all_products/products_bloc.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_invoice_return/presentation/widgets/products/add_product_widget.dart';
import 'package:fatoorahapp/feature/sales_invoices/create_sale_invoice/presentation/widgets/invoice_type_selector.dart';
import 'package:fatoorahapp/feature/sales_invoices/create_sale_invoice/presentation/widgets/summery_selection.dart';
import 'package:fatoorahapp/feature/stocks/stocks/presentation/widgets/stock_selection_widget.dart';
import 'package:fatoorahapp/feature/tax_reason/presentation/bloc/tax_reason_bloc.dart';
import 'package:fatoorahapp/feature/taxs/presentation/blocs/tax_bloc.dart';
import 'package:fatoorahapp/feature/work_place_section/work_place/presentation/widgets/workplace_widget.dart';
import 'package:fatoorahapp/injections/dependency_injection/dependency_injection.dart';
import 'package:fatoorahapp/widgets/dialogs/dialogs_and_popups.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/custom_text_field_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferToInvoiceBodyContent extends StatefulWidget {
  final ScrollController scrollController;
  final OfferPriceDataEntity offerPriceDataEntity;
  final SaleInvoiceEntity saleInvoiceEntity;
  final int stockId;
  final int employeeId;
  final TextEditingController referenceNumber;
  OfferToInvoiceBodyContent({
    super.key,
    required this.scrollController,
    required this.offerPriceDataEntity,
    required this.saleInvoiceEntity,
    required this.stockId,
    required this.employeeId,
    required this.referenceNumber,
  });

  @override
  State<OfferToInvoiceBodyContent> createState() =>
      _OfferToInvoiceBodyContentState();
}

class _OfferToInvoiceBodyContentState extends State<OfferToInvoiceBodyContent> {
  int stockId = 0;
  int employeeId = 0;

  @override
  void initState() {
    super.initState();
    stockId = widget.stockId;
    employeeId = widget.employeeId;
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: AppPadding.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppHeight.s10),
          CustomText(
            text: TranslationsController.instance.getTranslations().invoiceType,
          ),
          SizedBox(height: AppHeight.s10),
          InvoiceTypeSelector(
            currentInvoiceType: widget.saleInvoiceEntity.zatcaInvoiceType,
            onChanged: (value) {},
          ),
          SizedBox(height: AppHeight.s15),
          SelectDateWidget(
            isRequired: true,
            withInit: true,
            isReadOnly: false,
            initValue: widget.saleInvoiceEntity.date,
            title: TranslationsController.instance.getTranslations().date,
            onDateSelected: (selectedDate) {
              context.read<MapOfferToInvoiceBloc>().add(
                UpdateOfferInvoiceFields(dueDate: selectedDate),
              );
            },
          ),
          SizedBox(height: 15.h),
          CustomTextFieldWidget(
            hasBorder: true,
            borderColor: ColorManager.borderColor,
            onChanged: (val) {
              context.read<MapOfferToInvoiceBloc>().add(
                UpdateOfferInvoiceFields(referenceNumber: val),
              );
            },
            controller: widget.referenceNumber,
            title: TranslationsController.instance
                .getTranslations()
                .referenceNumber,
            isFieldRequired: false,
            // keyboardType: TextInputType.number,
            hint: TranslationsController.instance
                .getTranslations()
                .referenceNumber,
          ),
          SizedBox(height: 15.h),
          SelectDateWidget(
            withInit: false,
            onDateSelected: (date) {
              context.read<MapOfferToInvoiceBloc>().add(
                UpdateOfferInvoiceFields(serviceEndDate: date),
              );
            },
            title: TranslationsController.instance
                .getTranslations()
                .quotationExpiryDate,
          ),
          SizedBox(height: 15.h),
          SelectDateWidget(
            onDateSelected: (val) {
              context.read<MapOfferToInvoiceBloc>().add(
                UpdateOfferInvoiceFields(supplyDate: val),
              );
            },
            title: TranslationsController.instance
                .getTranslations()
                .quotationDate,
            // likeTextField: true,
          ),
          SizedBox(height: 15.h),
          if (widget.saleInvoiceEntity.user.name != "")
            ClientsWidget(
              isReadOnly: true,
              initOption: widget.saleInvoiceEntity.user.name.toString(),
              onClientSelection: (val) {},
            ),
          SizedBox(height: AppHeight.s10),
          WorkPlaceWidget(
            isReadOnly: true,
            onWorkPlaceSelection: (val) {},
            initOption: widget.saleInvoiceEntity.workplace.name != ""
                ? widget.saleInvoiceEntity.workplace.name
                : null,
          ),
          SizedBox(height: AppHeight.s10),
          StockSelectionWidget(
            withAutoInit: true,
            onListen: (val) {
              print("here we start");
              setState(() {
                stockId = val.id;
              });
              print("aaaa1${val.id}");
              context.read<MapOfferToInvoiceBloc>().add(
                UpdateOfferInvoiceFields(stockId: val.id.toString()),
              );
              context.read<ProductsBloc>().add(
                ProductsSubmitted(
                  isSelect: 1,
                  stockId: val.id,
                  withLoading: true,
                ),
              );
              // Trigger validation after auto-selection
              context.read<MapOfferToInvoiceBloc>().add(
                const RecalculateOfferInvoice(),
              );
            },
            initOption:
                widget.saleInvoiceEntity.stock != null &&
                    widget.saleInvoiceEntity.stock!.name != ""
                ? widget.saleInvoiceEntity.stock!.name
                : null,
            onStockSelection: (val) {
              setState(() {
                stockId = val.id;
              });
              context.read<MapOfferToInvoiceBloc>().add(
                UpdateOfferInvoiceFields(stockId: val.id.toString()),
              );
              context.read<ProductsBloc>().add(
                ProductsSubmitted(
                  isSelect: 1,
                  stockId: val.id,
                  withLoading: true,
                ),
              );
              // Trigger validation after stock selection
              context.read<MapOfferToInvoiceBloc>().add(
                const RecalculateOfferInvoice(),
              );
            },
          ),
          SizedBox(height: AppHeight.s10),
          if (widget.saleInvoiceEntity.employee.name != "")
            AdminWidget(
              type: 1,
              onCancel: () {
                setState(() {
                  employeeId = 0;
                });
                context.read<MapOfferToInvoiceBloc>().add(
                  UpdateOfferInvoiceFields(employeeId: "0"),
                );
              },
              initOption: widget.saleInvoiceEntity.employee.name.toString(),
              onAdminSelection: (val) {
                setState(() {
                  employeeId = val.id;
                });
                context.read<MapOfferToInvoiceBloc>().add(
                  UpdateOfferInvoiceFields(employeeId: val.id.toString()),
                );
              },
            ),

          Padding(
            padding: EdgeInsets.only(top: AppSize.s20.h, bottom: AppSize.s5.h),
            child: CustomText(
              text: TranslationsController.instance.getTranslations().products,
              textStyle: getExtraBoldStyle(
                fontSize: AppFontSize.s14,
                color: ColorManager.labelColor,
              ),
            ),
          ),
          SizedBox(height: AppHeight.s10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r20),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppPadding.p8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OfferToInvoiceProductWidget(
                    saleInvoiceDataEntity: widget.saleInvoiceEntity,
                    products: context
                        .read<MapOfferToInvoiceBloc>()
                        .state
                        .details,
                  ),
                  SizedBox(height: AppHeight.s20),
                  BlocBuilder<MapOfferToInvoiceBloc, MapOfferToInvoiceState>(
                    builder: (context, state) {
                      // Calculate remaining amount from current state
                      final totalPaid = state.payments.fold<double>(0.0, (
                        sum,
                        p,
                      ) {
                        final value =
                            double.tryParse(p.amount?.text.trim() ?? '0') ??
                            0.0;
                        return sum + value;
                      });
                      final remaining = state.finalAmount - totalPaid;

                      return SummarySection(
                        productLength: state.details.length,
                        taxableAmount: state.taxableAmount.toStringAsFixed(2),
                        vatAmount: state.totalDiscount.toStringAsFixed(2),
                        finalAmount: state.finalAmount.toStringAsFixed(2),
                        taxAmount: state.taxAmount.toStringAsFixed(2),
                        total: state.totalAmount.toStringAsFixed(2),
                        remainingAmount: remaining.toStringAsFixed(2),
                        payments: state.payments,
                        totalFinalAmountForGuarantee: state.finalAmount,
                      );
                    },
                  ),
                  AddProductWidget(
                    onPressed: () {
                      if (stockId != 0) {
                        initTaxsDIModule();
                        initTaxReasonBlocDIModule();
                        initDiscountReasonBlocDIModule();
                        DialogsAndPopUp.customBottomSheet(
                          context: context,
                          child: MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<MapOfferToInvoiceBloc>(),
                              ),
                              BlocProvider(
                                create: (context) => AddProductBloc(
                                  context.read<MapOfferToInvoiceBloc>(),
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                ),
                              ),
                              BlocProvider.value(
                                value: context.read<ProductsBloc>(),
                              ),
                              BlocProvider(
                                create: (dialogContext) =>
                                    inject<TaxesBloc>()..add(FetchTaxesEvent()),
                              ),
                              BlocProvider(
                                create: (dialogContext) =>
                                    inject<TaxReasonsBloc>(),
                              ),
                              BlocProvider(
                                create: (dialogContext) =>
                                    inject<DiscountReasonsBloc>()
                                      ..add(DiscountReasonsSubmitted()),
                              ),
                            ],
                            child: AddOfferToSaleInvoiceProductSheet(),
                          ),
                        );
                      } else {
                        customToast(
                          msg: TranslationsController.instance
                              .getTranslations()
                              .pleaseChooseWarehouse,
                        );
                      }
                    },
                  ),
                  SizedBox(height: AppHeight.s10),
                ],
              ),
            ),
          ),
          SizedBox(height: AppHeight.s25),
          OfferToSalePaymentSection(),
        ],
      ),
    );
  }
}
