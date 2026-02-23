import 'package:fatoorahapp/core/classes/entities/sale_invoice_entity.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/feature/discount_reason/presentation/bloc/discount_reason_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/add_produt_presentation/add_product_bloc/add_product_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/bloc/offer_to_sale_Invoice_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/widgets/products/add_offet_to_sale_product_sheet.dart';
import 'package:fatoorahapp/feature/products/products/presentation/blocs/all_products/products_bloc.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_create/presentation/widgets/drop_down_product.dart';
import 'package:fatoorahapp/feature/tax_reason/presentation/bloc/tax_reason_bloc.dart';
import 'package:fatoorahapp/feature/taxs/presentation/blocs/tax_bloc.dart';
import 'package:fatoorahapp/injections/dependency_injection/dependency_injection.dart';
import 'package:fatoorahapp/widgets/dialogs/dialogs_and_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferToInvoiceProductWidget extends StatelessWidget {
  final List<CreateProductEntity> products;
  final SaleInvoiceEntity? saleInvoiceDataEntity;
  const OfferToInvoiceProductWidget({
    super.key,
    required this.products,
    required this.saleInvoiceDataEntity,
  });

  @override
  Widget build(BuildContext context) {
    final offerToSaleInvoiceBloc =
        BlocProvider.of<MapOfferToInvoiceBloc>(context);

    return Column(children: [
      // TextButton(onPressed: (){
      //   for (var product in products) {
      //     print(product.taxValue);
      //       print(product.taxValue.runtimeType);
      //   }
      // }, child: Text("submit")),
      ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: AppSize.s8.h),
              child: DropDownProduct(
                isReturn: products[index].quantity == '0',
                isEdited: products[index].isEdited,
                onDelete: () {
                  offerToSaleInvoiceBloc
                      .add(DeleteProductFromOfferInvoice(index: index));
                },
                onEdit: () {
                  initTaxsDIModule();
                  initTaxReasonBlocDIModule();
                  initDiscountReasonBlocDIModule();
                  DialogsAndPopUp.customBottomSheet(
                      context: context,
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: offerToSaleInvoiceBloc,
                          ),
                          BlocProvider(
                            create: (context) => AddProductBloc(
                              offerToSaleInvoiceBloc,
                              null,
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
                                inject<TaxesBloc>()..add(FetchTaxesEvent()),
                          ),
                          BlocProvider(
                            create: (dialogContext) => inject<TaxReasonsBloc>(),
                          ),
                          BlocProvider(
                            create: (dialogContext) =>
                                inject<DiscountReasonsBloc>()
                                  ..add(DiscountReasonsSubmitted()),
                          ),
                        ],
                        child: AddOfferToSaleInvoiceProductSheet(
                          productToEdit: products[index],
                          editIndex: index,
                        ),
                      ));
                },
                tax: products[index].tax.isNotEmpty
                    ? products[index].tax.toString()
                    : null,
                  
                taxVlaue: products[index].taxValue != null
                    ? products[index].taxValue.toString()
                    : null,
                taxReason: products[index].taxReason ,
                discountReason: products[index].disCountReason ,
                name: products[index].name,
                quantity: products[index].quantity,
                price: products[index].price,
                disCountValue: products[index].discountValue.toString(),
                disCountType: products[index].discountType == "1" ||
                        products[index].discountType == "2"
                    ? DisCountType.fromId(products[index].discountType).title
                    : products[index].discountType,
              ),
            );
          }),
  
    ]);
  }
}
