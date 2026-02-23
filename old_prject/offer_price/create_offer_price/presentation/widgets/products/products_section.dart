import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/feature/discount_reason/presentation/bloc/discount_reason_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/add_produt_presentation/add_product_bloc/add_product_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/add_produt_presentation/widgets/add_new_product_widgert.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/add_produt_presentation/widgets/add_product_sheet.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/products/products/presentation/blocs/all_products/products_bloc.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_invoice_return/presentation/widgets/products/add_product_widget.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_create/presentation/widgets/drop_down_product.dart';
import 'package:fatoorahapp/feature/tax_reason/presentation/bloc/tax_reason_bloc.dart';
import 'package:fatoorahapp/feature/taxs/presentation/blocs/tax_bloc.dart';
import 'package:fatoorahapp/injections/dependency_injection/dependency_injection.dart';
import 'package:fatoorahapp/widgets/dialogs/dialogs_and_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class productsSection extends StatefulWidget {
  final bool fromEdit;
  final OfferPriceSingleEntity? offerPriceSingleEntity;
  const productsSection({
    this.offerPriceSingleEntity,
    required this.fromEdit,
    super.key,
  });

  @override
  State<productsSection> createState() => _productsSectionState();
}

class _productsSectionState extends State<productsSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool isFromEdit = widget.fromEdit && widget.offerPriceSingleEntity != null;
    final offerPriceCreateBloc = BlocProvider.of<OfferPriceCreateBloc>(context);
    return BlocBuilder<OfferPriceCreateBloc, CreateOfferPriceState>(
      builder: (context, state) {
        return Column(
          children: [
            if (context.read<OfferPriceCreateBloc>().getProducts().isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: ColorManager.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        CreateProductEntity item = context
                            .read<OfferPriceCreateBloc>()
                            .getProducts()[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppSize.s10.h),
                          child: DropDownProduct(
                            onEdit: () {
                              initTaxsDIModule();
                              initTaxReasonBlocDIModule();
                              initDiscountReasonBlocDIModule();
                              DialogsAndPopUp.customBottomSheet(
                                context: context,
                                child: MultiBlocProvider(
                                  child: AddProductSheet(
                                    productToEdit: item,
                                    editIndex: index,
                                  ),
                                  providers: [
                                    BlocProvider.value(
                                      value: offerPriceCreateBloc,
                                    ),
                                    BlocProvider(
                                      create: (dialogContext) => AddProductBloc(
                                        null,
                                        dialogContext
                                            .read<OfferPriceCreateBloc>(),
                                        null,
                                        null,
                                        null,
                                        null,
                                      ),
                                    ),
                                    // Use global ProductsBloc instead of creating new one
                                    BlocProvider.value(
                                      value: context.read<ProductsBloc>(),
                                    ),
                                    BlocProvider(
                                      create: (dialogContext) =>
                                          inject<TaxesBloc>()
                                            ..add(FetchTaxesEvent()),
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
                                ),
                              );
                            },
                            onDelete: () {
                              BlocProvider.of<OfferPriceCreateBloc>(
                                context,
                              ).add(DeleteProductFromOffer(index: index));
                            },
                            tax: item.tax,
                            taxVlaue: item.taxValue,
                            name: item.name,
                            taxReason: item.taxReason,
                            discountReason: item.disCountReason,
                            disCountValue: item.discountValue == null
                                ? '0'
                                : item.discountValue == ''
                                ? '0'
                                : item.discountValue ?? '0',
                            disCountType: item.discountType,
                            price: item.price,
                            quantity: item.quantity,
                          ),
                        );
                      },
                      itemCount: state.details.length,
                    ),
                    AddProductWidget(
                      onPressed: () {
                        initTaxsDIModule();
                        initTaxReasonBlocDIModule();
                        initDiscountReasonBlocDIModule();
                        DialogsAndPopUp.customBottomSheet(
                          context: context,
                          child: MultiBlocProvider(
                            child: AddProductSheet(),
                            providers: [
                              BlocProvider.value(value: offerPriceCreateBloc),
                              // Use global ProductsBloc instead of creating new one
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
                                    inject<DiscountReasonsBloc>(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            if ((context.read<OfferPriceCreateBloc>().getProducts().isEmpty))
              addNewProductWidget(context),
          ],
        );
      },
    );
  }
}
