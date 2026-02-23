// import 'package:fatoorahapp/core/constances/colors_manager.dart';

import 'package:fatoorahapp/core/classes/entities/sale_invoice_entity.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/bloc/offer_to_sale_Invoice_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/widgets/offer_to_invoice_body_content.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/widgets/offer_to_sale_subbmission_buttons.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/products/products/presentation/blocs/all_products/products_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/create_sale_invoice/presentation/bloc/create_sale_invoice_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:fatoorahapp/feature/stocks/stocks/presentation/blocs/stock_bloc.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferPriceToInvoiceBody extends StatefulWidget {
  final OfferPriceDataEntity offerPriceDataEntity;
  final SaleInvoiceEntity saleInvoiceEntity;

  const OfferPriceToInvoiceBody({
    super.key,
    required this.offerPriceDataEntity,
    required this.saleInvoiceEntity,
  });

  @override
  State<OfferPriceToInvoiceBody> createState() =>
      _OfferPriceToInvoiceBodyState();
}

class _OfferPriceToInvoiceBodyState extends State<OfferPriceToInvoiceBody> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController referenceNumber = TextEditingController();
  bool _hasAutoSelectedStock = false; // Track if we've already auto-selected

  void _tryAutoSelectFirstStock(StockState stockState) {
    // If stock from entity is null/0, auto-select first stock when StockBloc succeeds
    if (_hasAutoSelectedStock) return;
    if (!(widget.saleInvoiceEntity.stock == null ||
        widget.saleInvoiceEntity.stock?.id == 0)) {
      return;
    }
    if (stockState is! StockSuccessState) return;
    if (stockState.stockEntity.stockEntity.isEmpty) return;

    _hasAutoSelectedStock = true;
    final firstStock = stockState.stockEntity.stockEntity.first;

    context.read<MapOfferToInvoiceBloc>().add(
      UpdateOfferInvoiceFields(stockId: firstStock.id.toString()),
    );
    context.read<ProductsBloc>().add(
      ProductsSubmitted(isSelect: 1, stockId: firstStock.id, withLoading: true),
    );
    context.read<MapOfferToInvoiceBloc>().add(const RecalculateOfferInvoice());
  }

  @override
  void initState() {
    super.initState();

    List<CreateProductEntity> initialProducts = widget
        .saleInvoiceEntity
        .products
        .map(
          (e) => CreateProductEntity(
            salePrice: e.product!.salePrice,
            highestDiscountRate: e.product!.highestDiscountRate,
            name: e.product!.name,
            id: e.product!.id.toString(),
            discountValue: e.discountValue.toString(),
            discountType: e.discountType.toString(),
            discountTypeId: e.discountType.toString(),
            taxValue: e.taxes != null
                ? e.taxes!.map((e) => e.taxRate.toString()).join(',')
                : "",
            tax: e.taxes != null
                ? e.taxes!.map((e) => e.taxName.toString()).join(',')
                : "",
            price: e.price,
            quantity: e.quantity,
            taxId: e.taxes != null ? e.taxes!.map((e) => e.id).join(',') : "",
            taxKey: "",
            disCountReason: e.reason.descriptionAr,
            disCountReasonId: e.reason.id.toString(),
            taxReason: e.taxes != null
                ? e.taxes!
                      .map(
                        (e) => e.taxReasonEntity.arabicText == ""
                            ? e.taxReasonEntity.descriptionAr
                            : e.taxReasonEntity.arabicText,
                      )
                      .join(',')
                : "",
            taxReasonId: "",
          ),
        )
        .toList();
    List<PaymentMethodEntryOffer> initialPayments = widget
        .saleInvoiceEntity
        .payments
        .map((e) {
          // Use effectivePaymentMethodId to determine behavior
          final effectiveId = e.effectivePaymentMethodId;

          return PaymentMethodEntryOffer(
            id: e.methodId.toString(),
            paymentType: e.methodName ?? Payment(e.methodId.toString()).title,
            type: e.type, // Preserve type
            parentId: e.parentId, // Preserve parentId
            amount: TextEditingController(text: e.value.toString()),
            bankId: effectiveId == 1 || effectiveId == 3 || effectiveId == 5
                ? e.bankId.toString()
                : null,
            bankName: effectiveId == 1 || effectiveId == 3 || effectiveId == 5
                ? e.bankName
                : null,
            dueDate: effectiveId == 2 || effectiveId == 8 ? e.date : null,
            note: e.notes, // Preserve notes for Business Guarantee
            guaranteePercent: e.guaranteePercent, // Preserve guarantee percent
          );
        })
        .toList();

    context.read<MapOfferToInvoiceBloc>().add(
      LoadOfferToInvoiceInitData(
        payments: initialPayments,
        details: initialProducts,
        stockId: widget.saleInvoiceEntity.stock?.id.toString(),
        employeeId: widget.saleInvoiceEntity.employee.id != null &&
                widget.saleInvoiceEntity.employee.id != 0
            ? widget.saleInvoiceEntity.employee.id.toString()
            : null,
      ),
    );

    // In release mode, StockBloc may have already emitted StockSuccessState
    // before this widget builds and attaches its BlocListener.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tryAutoSelectFirstStock(context.read<StockBloc>().state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateSaleInvoiceBloc, CreateSaleInvoiceState>(
      listener: (context, state) {
        if (state is CreateSaleInvoiceSuccess) {
          customToast(
            msg: TranslationsController.instance
                .getTranslations()
                .operationSuccessful,
          );

          context.pushNamed(
            Routes.SalesReturnsScreen,
            arguments: {"isReturn": false, "fromHome": false},
          );
        } else if (state is CreateSaleInvoiceError) {
          customToast(msg: state.message);
        }
      },
      builder: (context, state) {
        return BlocListener<StockBloc, StockState>(
          listener: (context, stockState) {
            _tryAutoSelectFirstStock(stockState);
          },
          child: BlocBuilder<MapOfferToInvoiceBloc, MapOfferToInvoiceState>(
            builder: (context, mapState) {
              return Scaffold(
                body: OfferToInvoiceBodyContent(
                  scrollController: _scrollController,
                  offerPriceDataEntity: widget.offerPriceDataEntity,
                  saleInvoiceEntity: widget.saleInvoiceEntity,
                  stockId: mapState.stockId,
                  employeeId: mapState.employeeId,
                  referenceNumber: referenceNumber,
                ),

                bottomNavigationBar: offerToSaleSubmissionButton(
                  referenceNumber: mapState.referenceNumber,
                  userId: widget.saleInvoiceEntity.user.id,
                  zatcaInvoiceType: widget.saleInvoiceEntity.zatcaInvoiceType,
                  employeeId: mapState.employeeId,
                  stockId:mapState.stockId,
                  workPlaceId: widget.saleInvoiceEntity.workplace.id,
                  dueDate: mapState.dueDate,
                  supplyDate: mapState.supplyDate,
                  serviceEndDate: mapState.serviceEndDate,
                  status: '1',
                  products: mapState.details,
                  payments: mapState.payments,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
