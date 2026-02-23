import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/accounting_list/presentation/blocs/accounts_list_bloc.dart';
import 'package:fatoorahapp/feature/cash_in_treasury/presentation/bloc/cash_in_treasury_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/bloc/offer_to_sale_Invoice_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/widgets/offer_to_invoice_body.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/sales_invoices/create_sale_invoice/presentation/bloc/create_sale_invoice_bloc.dart';
import 'package:fatoorahapp/feature/stocks/stocks/presentation/blocs/stock_bloc.dart';
import 'package:fatoorahapp/widgets/circular_progress_indicator_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/app_bar_widget.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:fatoorahapp/widgets/ui_states/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OfferPriceToInvoiceScreen extends StatefulWidget {
  final OfferPriceDataEntity offerPriceDataEntity;
  OfferPriceToInvoiceScreen({super.key, required this.offerPriceDataEntity});

  @override
  State<OfferPriceToInvoiceScreen> createState() => _OfferPriceToInvoiceState();
}

class _OfferPriceToInvoiceState extends State<OfferPriceToInvoiceScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MapOfferToInvoiceBloc>(context).add(
      MapOfferToInvoiceSubmitted(
        uuid: widget.offerPriceDataEntity.uuid,
        withLoading: true,
      ),
    );
    BlocProvider.of<CashInTreasuryBloc>(
      context,
    ).add(CashInTreasuryBankAccountsSubmitted());

    BlocProvider.of<AccountsBloc>(context).add(FetchAccounts());
    BlocProvider.of<StockBloc>(context).add(StockSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateSaleInvoiceBloc, CreateSaleInvoiceState>(
      listener: (context, saleState) {
        if (saleState is CreateSaleInvoiceSuccess) {
          context.pushNamed(
            Routes.SalesReturnsScreen,
            arguments: {"isReturn": false},
          );
        } else if (saleState is CreateSaleInvoiceError) {
          customToast(msg: saleState.message);
        }
      },
      builder: (context, saleState) {
        return BlocBuilder<MapOfferToInvoiceBloc, MapOfferToInvoiceState>(
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: saleState is CreateInvoiceLoading,
              progressIndicator: CustomCircularProgressIndicator(
                color: ColorManager.primaryColor,
              ),
              child: Scaffold(
                backgroundColor: ColorManager.secondaryScaffoldBackgroundColor,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(AppHeight.s45),
                  child: CustomAppBar(
                    title: TranslationsController.instance
                        .getTranslations()
                        .salesInvoices
                        .replaceAll(RegExp('-'), ''),
                    toolbarHeight: AppHeight.s45,
                    titleSize: AppSize.s16,
                    centerTitle: false,
                    leadingWidth: 50,
                    backgroundColor:
                        ColorManager.secondaryScaffoldBackgroundColor,
                    withBack: true,
                  ),
                ),
                body: state is MapOfferToInvoiceLoadingState
                    ? CustomCircularProgressIndicator()
                    : state is MapOfferToInvoiceErrorState
                    ? ErrorState(
                        onPressed: () {
                          BlocProvider.of<MapOfferToInvoiceBloc>(context).add(
                            MapOfferToInvoiceSubmitted(
                              uuid: widget.offerPriceDataEntity.uuid,
                              withLoading: true,
                            ),
                          );
                        },
                      )
                    : state is MapOfferToInvoiceSuccessState
                    ? OfferPriceToInvoiceBody(
                        offerPriceDataEntity: widget.offerPriceDataEntity,
                        saleInvoiceEntity: state.saleInvoiceEntity,
                      )
                    : Container(),
              ),
            );
          },
        );
      },
    );
  }
}
