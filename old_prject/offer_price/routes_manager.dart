import 'package:fatoorahapp/core/classes/entities/sale_invoice_entity.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/feature/accounting_list/presentation/blocs/accounts_list_bloc.dart';
import 'package:fatoorahapp/feature/admin/delete_admin/presentation/blocs/delete_admin_bloc.dart';
import 'package:fatoorahapp/feature/admin/presentation/blocs/admin_bloc.dart';
import 'package:fatoorahapp/feature/admins/add_admin/presentation/bloc/add_admin_bloc.dart';
import 'package:fatoorahapp/feature/admins/add_admin/presentation/screens/add_admin_screen.dart';
// Using AdminBloc from feature/admin for Admins UI
import 'package:fatoorahapp/feature/admins/admins/presentation/screens/admins_screen.dart';
import 'package:fatoorahapp/feature/admins/admins_details/presentation/blocs/admin_details_bloc.dart';
import 'package:fatoorahapp/feature/admins/admins_details/presentation/screens/admin_details_screen.dart';
import 'package:fatoorahapp/feature/admins/update_admin_status/presentation/blocs/update_admin_status_bloc.dart';
import 'package:fatoorahapp/feature/ai_chat/presentation/blocs/ai_chat_bloc/chat_bloc.dart';
import 'package:fatoorahapp/feature/ai_chat/presentation/blocs/chat_initialize_bloc/chat_initialize_bloc.dart';
import 'package:fatoorahapp/feature/ai_chat/presentation/blocs/chat_stop/chat_stop_bloc.dart';
import 'package:fatoorahapp/feature/ai_chat/presentation/screens/chat_screen.dart';
import 'package:fatoorahapp/feature/authentication/change_password/presentation/blocs/change_password_bloc.dart';
import 'package:fatoorahapp/feature/authentication/change_password/presentation/screens/change_password_screen.dart';
import 'package:fatoorahapp/feature/authentication/edit_profile/presentation/blocs/edit_profile_bloc.dart';
import 'package:fatoorahapp/feature/authentication/edit_profile/presentation/screens/edit_profile_screen.dart';
import 'package:fatoorahapp/feature/authentication/forgot_password/presentation/blocs/forgot_password_bloc.dart';
import 'package:fatoorahapp/feature/authentication/forgot_password/presentation/screens/forgot_password_screen.dart';
import 'package:fatoorahapp/feature/authentication/login/presentation/blocs/login_bloc.dart';
import 'package:fatoorahapp/feature/authentication/login/presentation/screens/login_screen.dart';
import 'package:fatoorahapp/feature/authentication/profile/domain/entities/profile_entity.dart';
import 'package:fatoorahapp/feature/authentication/profile/presentation/blocs/profile_bloc.dart';
import 'package:fatoorahapp/feature/authentication/profile/presentation/screens/profile_screen.dart';
import 'package:fatoorahapp/feature/authentication/send_otp/presentation/blocs/send_otp_bloc.dart';
import 'package:fatoorahapp/feature/authentication/validate_otp/presentation/blocs/validate_otp_bloc.dart';
import 'package:fatoorahapp/feature/authentication/validate_otp/presentation/screens/validate_otp_screen.dart';
import 'package:fatoorahapp/feature/bank_indicators/presentation/blocs/bank_indicators_bloc.dart';
import 'package:fatoorahapp/feature/bank_indicators/presentation/screens/bank_indicators_screen.dart';
import 'package:fatoorahapp/feature/bonds/bond_details/presentation/blocs/bond_details_bloc.dart';
import 'package:fatoorahapp/feature/bonds/bond_details/presentation/screens/bond_details_screen.dart';
import 'package:fatoorahapp/feature/stocks/stocks/presentation/screens/stocks_screen.dart';
import 'package:fatoorahapp/feature/stocks/add_stock/presentation/screens/add_stock_screen.dart';
import 'package:fatoorahapp/feature/stocks/add_stock/presentation/bloc/add_stock_bloc.dart';
import 'package:fatoorahapp/feature/stocks/print_stock/presenation/screens/stock_print_screen.dart';
import 'package:fatoorahapp/feature/stocks/stock_details/presentation/bloc/stock_details_bloc.dart';
import 'package:fatoorahapp/feature/stocks/stock_details/presentation/screen/stock_details_screen.dart';
import 'package:fatoorahapp/feature/stocks/update_stock_status/presentation/blocs/update_stock_status_bloc.dart';
import 'package:fatoorahapp/feature/stocks/delete_stock/presentation/bloc/delete_stock_bloc.dart'
    as delete_stock;
import 'package:fatoorahapp/core/classes/entities/stock_entity.dart';
import 'package:fatoorahapp/feature/client_payment_methods/client_payment_methods/presentation/screens/client_payment_methods_screen.dart';
import 'package:fatoorahapp/feature/client_payment_methods/add_client_payment_method/presentation/screens/add_client_payment_method_screen.dart';
import 'package:fatoorahapp/feature/client_payment_methods/client_payment_method_details/presentation/screen/client_payment_method_details_screen.dart';
import 'package:fatoorahapp/feature/client_payment_methods/client_payment_methods/presentation/blocs/client_payment_methods_bloc.dart';
import 'package:fatoorahapp/feature/client_payment_methods/add_client_payment_method/presentation/bloc/add_client_payment_method_bloc.dart';
import 'package:fatoorahapp/feature/client_payment_methods/delete_client_payment_method/presentation/bloc/delete_client_payment_method_bloc.dart';
import 'package:fatoorahapp/feature/client_payment_methods/client_payment_method_details/presentation/bloc/client_payment_method_details_bloc.dart';
import 'package:fatoorahapp/feature/payment_method/presentation/blocs/payment_methods_bloc.dart';
import 'package:fatoorahapp/feature/bonds/bonds/domain/entites/bonds_entity.dart';
import 'package:fatoorahapp/feature/bonds/bonds/presentation/blocs/bonds_bloc.dart';
import 'package:fatoorahapp/feature/bonds/bonds/presentation/screens/bonds_screen.dart';
import 'package:fatoorahapp/feature/bonds/bonds/presentation/screens/print_bond_screen.dart';
import 'package:fatoorahapp/feature/bonds/create_bonds/presentation/blocs/bonds_create_bloc.dart';
import 'package:fatoorahapp/feature/bonds/create_bonds/presentation/screens/create_bond_screen.dart';
import 'package:fatoorahapp/feature/bonds/update_bonds/presentation/update_blocs/update_bond_bloc.dart';
import 'package:fatoorahapp/feature/buy_indicators/domain/entities/buy_indicators_entitiy.dart';
import 'package:fatoorahapp/feature/buy_indicators/presentation/blocs/buy_indicators_bloc.dart';
import 'package:fatoorahapp/feature/buy_indicators/presentation/screens/buy_indicator_screen.dart';
import 'package:fatoorahapp/feature/cash_in_treasury/presentation/bloc/cash_in_treasury_bloc.dart';
import 'package:fatoorahapp/feature/city/presentation/blocs/city_bloc.dart';
import 'package:fatoorahapp/feature/classifications/presentation/blocs/classifications_bloc.dart';
import 'package:fatoorahapp/feature/clients/add_client/presentation/bloc/add_client_bloc.dart';
import 'package:fatoorahapp/feature/clients/add_client/presentation/screens/add_clients_screen.dart';
import 'package:fatoorahapp/feature/clients/client_details/presentation/blocs/client_details_bloc.dart';
import 'package:fatoorahapp/feature/clients/client_details/presentation/screens/client_details_screen.dart';
import 'package:fatoorahapp/feature/clients/clients/presentation/blocs/clients_bloc.dart';
import 'package:fatoorahapp/feature/clients/clients/presentation/screens/clients_screen.dart';
import 'package:fatoorahapp/feature/clients/delete_client/presentation/blocs/delete_client_bloc.dart';
import 'package:fatoorahapp/feature/clients/print_client/screen/print_client_screen.dart';
import 'package:fatoorahapp/feature/clients/update_client_status/presentation/blocs/update_client_status_bloc.dart';
import 'package:fatoorahapp/feature/clients/user_adress/presentation/blocs/user_adress_block.dart';
import 'package:fatoorahapp/feature/clients_indicators/presentation/blocs/clients_indicators_bloc.dart';
import 'package:fatoorahapp/feature/clients_indicators/presentation/screens/clients_indicator_screen.dart';
import 'package:fatoorahapp/feature/cost_center/presentation/screens/cost_center_screen.dart';
import 'package:fatoorahapp/feature/country/presentation/blocs/country_bloc.dart';
import 'package:fatoorahapp/feature/currencies/presentation/blocs/currencies_bloc.dart';
import 'package:fatoorahapp/feature/discount_reason/presentation/bloc/discount_reason_bloc.dart';
import 'package:fatoorahapp/feature/help_and_support/presentation/blocs/help_and_support_bloc.dart';
import 'package:fatoorahapp/feature/help_and_support/presentation/screens/help_and_support_screen.dart';
import 'package:fatoorahapp/feature/indicators/indicator_detail/presentation/screens/indicator_product_detail.dart';
import 'package:fatoorahapp/feature/indicators/indicator_detail/presentation/screens/producer_indicator.dart';
import 'package:fatoorahapp/feature/indicators/indicators/domain/entities/dasboard_statistics_entity.dart';
import 'package:fatoorahapp/feature/indicators/indicators/presentation/bloc/indicators_bloc.dart';
import 'package:fatoorahapp/feature/indicators/indicators/presentation/screens/indicators_screen.dart';
import 'package:fatoorahapp/feature/invoice_setting/presentation/blocs/invoice_setting_bloc.dart';
import 'package:fatoorahapp/feature/invoice_setting/presentation/screen/invoice_setting_screen.dart';
import 'package:fatoorahapp/feature/main/presentation/blocs/app_bloc.dart';
import 'package:fatoorahapp/feature/main/presentation/screens/main_screen.dart';
import 'package:fatoorahapp/feature/notification_settings/presentation/blocs/notification_settings_bloc.dart';
import 'package:fatoorahapp/feature/notification_settings/presentation/screens/notification_settings_screen.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/screen/create_offer_price_screen.dart';
import 'package:fatoorahapp/feature/offer_price/delete_offer_price/presentation/blocs/delete_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/screens/offer_price_to_invoice_screen.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/blocs/offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/screens/offer_price_screen.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/presentation/blocs/offer_price_details_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/presentation/screens/offer_price_details_screen.dart';
import 'package:fatoorahapp/feature/offer_price/print_offer_price/screens/print_offer_price_screen.dart';
import 'package:fatoorahapp/feature/offer_price/update_offer_price/presentation/bloc/update_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/on_boarding/presentation/blocs/on_boarding_bloc.dart';
import 'package:fatoorahapp/feature/on_boarding/presentation/screens/on_boarding_screen.dart';
import 'package:fatoorahapp/feature/payment/presentation/blocs/payment_bloc.dart';
import 'package:fatoorahapp/feature/payment_gateway/presentation/screens/payment_gateway_screen.dart';
import 'package:fatoorahapp/feature/pos/create_pos/presentation/blocs/create_pos_bloc.dart';
import 'package:fatoorahapp/feature/pos/create_pos/presentation/screens/add_pos_screen.dart';
import 'package:fatoorahapp/feature/pos/delete_pos/presentation/blocs/delete_pos_bloc.dart';
import 'package:fatoorahapp/feature/pos/pos/presentation/blocs/pos_bloc.dart';
import 'package:fatoorahapp/feature/pos/pos/presentation/screens/pos_listing_screen.dart';
import 'package:fatoorahapp/feature/pos/pos_details/presentation/blocs/pos_details_bloc.dart';
import 'package:fatoorahapp/feature/pos/pos_details/presentation/screens/pos_details_screen.dart';
import 'package:fatoorahapp/feature/pos/pos_setting/presentation/blocs/pos_setting_bloc.dart';
import 'package:fatoorahapp/feature/pos/pos_setting/presentation/presentation/screens/pos_settings_screen.dart';
import 'package:fatoorahapp/feature/pos/update_pos/presentation/blocs/update_pos_bloc.dart';
import 'package:fatoorahapp/feature/pos/update_pos_status/presentation/blocs/update_pos_status_bloc.dart';
import 'package:fatoorahapp/feature/previous_invoice/domain/entities/previous_invoice_entity.dart';
import 'package:fatoorahapp/feature/previous_invoice/presentation/blocs/previous_invoice_bloc.dart';
import 'package:fatoorahapp/feature/previous_invoice/presentation/screens/previous_invoice_screen.dart';
import 'package:fatoorahapp/feature/print_invoice_screen/model/print_invoice_model.dart';
import 'package:fatoorahapp/feature/print_invoice_screen/screen/print_invoice_screen.dart';
import 'package:fatoorahapp/feature/print_invoice_screen/screen/product/print_product_screen.dart';
import 'package:fatoorahapp/feature/products/product_details/domain/entities/product_details_entity.dart';
import 'package:fatoorahapp/feature/products/product_details/presentation/blocs/product_details_bloc.dart';
import 'package:fatoorahapp/feature/products/product_details/presentation/screens/product_details_screen.dart';
import 'package:fatoorahapp/feature/product_indicators/domain/entities/product_entity.dart';
import 'package:fatoorahapp/feature/product_indicators/presentation/screens/products_indicators_screen.dart';
import 'package:fatoorahapp/feature/products/category_section/add_category/presentation/bloc/create_category_bloc.dart';
import 'package:fatoorahapp/feature/products/category_section/category/presentation/bloc/category_bloc.dart';
import 'package:fatoorahapp/feature/products/create_product/presentation/bloc/create_product_bloc.dart';
import 'package:fatoorahapp/feature/products/create_product/presentation/screens/create_product_screen.dart';
import 'package:fatoorahapp/feature/products/products/presentation/blocs/all_products/products_bloc.dart';
import 'package:fatoorahapp/feature/products/products/presentation/screens/products_screen.dart';
import 'package:fatoorahapp/feature/products/delete_product/presentation/bloc/delete_product_bloc.dart';
import 'package:fatoorahapp/feature/products/update_product_status/presentation/bloc/update_product_status_bloc.dart';
import 'package:fatoorahapp/feature/products/units_section/add_major_unit/presentation/bloc/create_major_unit_bloc.dart';
import 'package:fatoorahapp/feature/products/units_section/major_unit/presentation/bloc/major_unit_bloc.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_invoice_after_return/presentation/bloc/purchase_invoice_after_return_bloc.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_invoice_details/presentation/blocs/purchase_invoice_details_bloc.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_invoice_details/presentation/screens/purchase_invoice_details_screen.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_invoice_return/presentation/bloc/purchase_invoice_return_bloc.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_invoice_return/presentation/screens/purchase_invoice_return_screen.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_pay/presentation/blocs/purchase_pay_bloc.dart';
import 'package:fatoorahapp/feature/purchase_invoices/purchase_pay/presentation/screen/purchase_pay_screen.dart';
import 'package:fatoorahapp/feature/purchase_return_invoices/purchase_return_invoices/presentation/screens/purchase_return_invoices_screen.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request/presentation/blocs/purchase_request_bloc.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request/presentation/screens/purchase_request_screen.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_create/presentation/blocs/purchase_request_create_bloc.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_create/presentation/screens/purchase_request_create_screen.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_details/presentation/blocs/purchase_request_details_bloc.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_details/presentation/screens/purchase_request_details_screen.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_print/screen/purchase_request_print._screen.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchases_to_invoice/presentation/bloc/purchases_to_invoice_bloc.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchases_to_invoice/presentation/screens/purchases_to_invoice_screen.dart';
import 'package:fatoorahapp/feature/region/presentation/blocs/region_bloc.dart';
import 'package:fatoorahapp/feature/return_invoice_section/create_return_invoice/presentation/bloc/create_return_invoice_bloc.dart';
import 'package:fatoorahapp/feature/return_invoice_section/create_return_invoice/presentation/screens/create_return_invoice_screen.dart';
import 'package:fatoorahapp/feature/roles/presentation/blocs/role_bloc.dart';
import 'package:fatoorahapp/feature/sale_invoice_after_return/presentation/bloc/sale_invoice_after_return_bloc.dart';
import 'package:fatoorahapp/feature/sales_indicators/presentation/blocs/sales_indicators_bloc.dart';
import 'package:fatoorahapp/feature/sales_indicators/presentation/screens/sales_indicator_screen.dart';
import 'package:fatoorahapp/feature/sales_invoices/create_sale_invoice/presentation/bloc/create_sale_invoice_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/create_sale_invoice/presentation/screens/create_sale_invoice_screen.dart';
import 'package:fatoorahapp/feature/sales_invoices/details_sale_invoice/pesentation/bloc/sale_invoice_details_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/details_sale_invoice/pesentation/screens/sales_invoice_details_screen.dart';
import 'package:fatoorahapp/feature/sales_invoices/extract_pdf/presentation/bloc/extract_pdf_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/pay_deferred_sale_invoice/screens/bloc/pay_invoice_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/pay_deferred_sale_invoice/screens/pay_invoice_screen.dart';
import 'package:fatoorahapp/feature/sales_invoices/print_invoice_screen.dart/screens/print_sale_invoice_screen.dart';
import 'package:fatoorahapp/feature/sales_invoices/sales_invoices/presentation/bloc/sales_invoice_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/sales_invoices/presentation/screens/sales_invoices_screen.dart';
import 'package:fatoorahapp/feature/settings/presentation/blocs/settings_bloc.dart';
import 'package:fatoorahapp/feature/settings/presentation/screens/settings_screen.dart';
import 'package:fatoorahapp/feature/settings/presentation/screens/terms_and_policy_screen.dart';
import 'package:fatoorahapp/feature/shif-planning/add_shift_plan/presentation/screens/add_shift_plan_screen.dart';
import 'package:fatoorahapp/feature/shif-planning/shift_plan_details/presentation/bloc/shift_plan_details_bloc.dart';
import 'package:fatoorahapp/feature/shif-planning/shift_plan_details/presentation/screens/shift_plan_details_screen.dart';
import 'package:fatoorahapp/feature/shif-planning/shift_plans/presentation/bloc/shift_plans_bloc.dart';
import 'package:fatoorahapp/feature/shif-planning/shift_plans/presentation/screens/shift_plans_screen.dart';
import 'package:fatoorahapp/feature/shif-planning/update_shift_plan_status/presentation/bloc/update_shift_plan_status_bloc.dart';
import 'package:fatoorahapp/feature/shift_report/presentation/blocs/shift_report_bloc.dart';
import 'package:fatoorahapp/feature/shift_report/presentation/screens/shift_report_screen.dart';
import 'package:fatoorahapp/feature/shifts_section/delete_shifts/presentation/bloc/delete_shift_bloc.dart';
import 'package:fatoorahapp/feature/shifts_section/end_shift/presentation/bloc/end_shift_bloc.dart';
import 'package:fatoorahapp/feature/shifts_section/export_shifts/presentation/screens/export_shifts_screen.dart';
import 'package:fatoorahapp/feature/shifts_section/print_shift_operation/presentation/bloc/print_shift_operation_bloc.dart';
import 'package:fatoorahapp/feature/shifts_section/print_shift_operation/presentation/screens/print_shift_operation_screen.dart';
import 'package:fatoorahapp/feature/shifts_section/shift_details/presentation/bloc/shift_details_bloc.dart';
import 'package:fatoorahapp/feature/shifts_section/shifts/presentation/bloc/shifts_bloc.dart';
import 'package:fatoorahapp/feature/shifts_section/shifts/presentation/screens/shifts_screen.dart';
import 'package:fatoorahapp/feature/side_menu/presentation/screens/side_menu_screen.dart';
import 'package:fatoorahapp/feature/splash/presentation/screens/splash_screen.dart';
import 'package:fatoorahapp/feature/stocks/stocks/presentation/blocs/stock_bloc.dart';
import 'package:fatoorahapp/feature/suppliers_indicators/presentation/blocs/suppliers_indicators_bloc.dart';
import 'package:fatoorahapp/feature/suppliers_indicators/presentation/screens/supplier_indicator_screen.dart';
import 'package:fatoorahapp/feature/suppliers_section/add_supplier/presentation/bloc/add_supplier_bloc.dart';
import 'package:fatoorahapp/feature/suppliers_section/add_supplier/presentation/screens/add_supplier_screen.dart';
import 'package:fatoorahapp/feature/suppliers_section/delete_supplier/presentation/blocs/delete_supplier_bloc.dart';
import 'package:fatoorahapp/feature/suppliers_section/print_supplier/screen/print_supplier_screen.dart';
import 'package:fatoorahapp/feature/suppliers_section/supplier_details/presentation/blocs/supplier_details_bloc.dart';
import 'package:fatoorahapp/feature/suppliers_section/supplier_details/presentation/screens/supplier_details_screen.dart';
import 'package:fatoorahapp/feature/suppliers_section/suppliers/presentation/blocs/suppliers_list_bloc.dart';
import 'package:fatoorahapp/feature/suppliers_section/suppliers/presentation/screens/suppliers_screen.dart';
import 'package:fatoorahapp/feature/suppliers_section/suppliers_accounts/presentation/blocs/suppliers_accounts_bloc.dart';
import 'package:fatoorahapp/feature/suppliers_section/update_supplier_status/presentation/blocs/update_supplier_status_bloc.dart';
import 'package:fatoorahapp/feature/tax_reason/presentation/bloc/tax_reason_bloc.dart';
import 'package:fatoorahapp/feature/taxs/presentation/blocs/tax_bloc.dart';
import 'package:fatoorahapp/feature/upgrade_and_subscriptions/domain/entities/upgrade_and_subscriptions_entitiy.dart';
import 'package:fatoorahapp/feature/upgrade_and_subscriptions/presentation/blocs/upgrade_and_subscriptions_bloc.dart';
import 'package:fatoorahapp/feature/work_place_section/create_workplace/presentation/bloc/create_workplace_bloc.dart';
import 'package:fatoorahapp/feature/work_place_section/create_workplace/presentation/screens/create_workplace_screen.dart';
import 'package:fatoorahapp/feature/work_place_section/print_workplace/presentation/screens/print_workplace_screen.dart';
import 'package:fatoorahapp/feature/work_place_section/update_workplace_status/presentation/bloc/update_workplace_status_bloc.dart';
import 'package:fatoorahapp/feature/work_place_section/work_place/presentation/bloc/workplace_bolc.dart';
import 'package:fatoorahapp/feature/work_place_section/work_place/presentation/screen/workplaces_screen.dart';
import 'package:fatoorahapp/feature/work_place_section/workplace_details/presentation/bloc/workplace_details_bloc.dart';
import 'package:fatoorahapp/feature/work_place_section/workplace_details/presentation/screens/workplace_details_screen.dart';
import 'package:fatoorahapp/feature/work_place_section/buyer_scheme/presentation/bloc/buyer_scheme_bloc.dart';
import 'package:fatoorahapp/injections/dependency_injection/dependency_injection.dart';
import 'package:fatoorahapp/widgets/unknown_route_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/offer_price/map_to_sale_Invoice/presentation/bloc/offer_to_sale_Invoice_bloc.dart';
import '../../feature/payment/presentation/screens/payment_screen.dart';
import '../../feature/purchase_invoices/add_purchase_invoice/presentation/blocs/add_purchase_invoice_bloc.dart';
import '../../feature/purchase_invoices/add_purchase_invoice/presentation/screens/add_purchase_invoice_screen.dart';
import '../../feature/purchase_invoices/purchase_invoices/presentation/screens/purchase_invoices_screen.dart';
import '../../feature/shif-planning/print_shift_plan/screen/print_shift_plan_screen.dart';
import '../../feature/upgrade_and_subscriptions/presentation/screens/upgrades_and_subsriptions_screen.dart';
import '../../widgets/ui_states/error_state.dart';
import '../../widgets/ui_states/no_internet_state.dart';
import '../../widgets/ui_states/not_found_state.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings setting) {
    switch (setting.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                OnBoardingBloc()..add(const OnBoardingClick(index: 0)),
            child: const OnBoardingScreen(),
          ),
        );
      case Routes.loginRoute:
        initLoginDIModule();
        return MaterialPageRoute(
          builder: (_) {
            // Use value to avoid disposing the shared login bloc (needed by root listeners)
            final loginBloc = inject<LoginBloc>();
            return BlocProvider.value(
              value: loginBloc,
              child: const LoginScreen(),
            );
          },
        );
      case Routes.createSaleInvoice:
        initAdminBlocDIModule();
        initWorkplaceDIModule();
        initAccountsDIModule();
        initDiscountReasonBlocDIModule();
        initCreateSaleInvoiceDIModule();
        initClientsBlocDIModule();
        initStockBlocDIModule();
        initPaymentsMethodseDIModule();
        initBankAccountsDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    inject<WorkplaceBloc>()..add(FetchWorkplaces()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<AdminBloc>()..add(AdminSubmitted(type: 1)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<ClientsBloc>()..add(ClientsSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<PaymentMethodsBloc>()
                      ..add(PaymentMethodsSubmitted(isGuaranteeAllowed: true)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
              BlocProvider(create: (context) => inject<DiscountReasonsBloc>()),
              BlocProvider(
                create: (context) => inject<StockBloc>()..add(StockSubmitted()),
              ),
              BlocProvider(create: (context) => inject<CashInTreasuryBloc>()),
              BlocProvider(
                create: (context) => inject<CreateSaleInvoiceBloc>(),
              ),
              BlocProvider(
                create: (context) =>
                    inject<AccountsBloc>()..add(FetchAccounts()),
              ),
            ],
            child: CreateSaleInvoiceScreen(),
          ),
        );
      case Routes.saleInvoiceDetailsSceen:
        initSaleInvoiceDetailsDIModule();
        initBankAccountsDIModule();
        initExtractPdfDIModule();
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => inject<SaleInvoiceDetailsBloc>(),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
              BlocProvider(create: (context) => inject<ExtractPdfBloc>()),
            ],
            child: SaleInvoiceDetailsScreen(
              identificationNumber: args['identificationNumber'] as String,
              canReturn: args['canReturn'] as bool,
              saleInvoiceId: args['id'] as String,
              isReturn: args['isReturn'] as bool,
              invoiceNumber: args['invoiceNumber'] as String,
            ),
          ),
        );
      case Routes.printOfferPriceRoute:
        initOfferPriceDetailsBlocDIModule();
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inject<OfferPriceDetailsBloc>(),
            child: PrintOfferPriceScreen(uuid: args['uuid'] as String),
          ),
        );

      // case Routes.saleInvoiceDetailsSceen:
      //   initSaleInvoiceDetailsDIModule();
      //   final args = setting.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (context) => inject<SaleInvoiceDetailsBloc>(),
      //       child: SaleInvoiceDetailsScreen(
      //         saleInvoiceId: args['saleInvoiceId'],
      //       ),
      //     ),
      //   );
      case Routes.payDeferredSaleInvoiceScreen:
        initPayInvoiceFeatureDI();
        initPaymentsMethodseDIModule();
        initBankAccountsDIModule();
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<PayInvoiceBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<PaymentMethodsBloc>()
                      ..add(PaymentMethodsSubmitted(isGuaranteeAllowed: false)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
            ],
            child: PayInvoiceScreen(
              isPurchase: args['isPurchase'] as bool,
              userId: args['userId'] as String,
              invoiceId: args['invoiceId'] as String,
              name: args['name'] as String,
              invoiceType: args['invoiceType'] as String,
              invoiceIdentificationNumber:
                  args['invoiceIdentificationNumber'] as String,
            ),
          ),
        );

      case Routes.validateOtpRoute:
        initValidateOtpDIModule();
        initSendOtpDIModule();
        initEditAccountDIModule();
        final ValidateOtpParams validateOtpParams =
            setting.arguments as ValidateOtpParams;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ValidateOtpBloc>()),
              BlocProvider(create: (context) => inject<SendOtpBloc>()),
              BlocProvider(create: (context) => inject<EditAccountBloc>()),
            ],
            child: ValidateOtpScreen(validateOtpParams: validateOtpParams),
          ),
        );
      case Routes.forgotPasswordRoute:
        initForgotPasswordDIModule();
        final ForgotPasswordParams forgotPasswordParams =
            setting.arguments as ForgotPasswordParams;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inject<ForgotPasswordBloc>(),
            child: ForgotPasswordScreen(
              forgotPasswordParams: forgotPasswordParams,
            ),
          ),
        );
      case Routes.offerPriceRoute:
        final args = setting.arguments as Map<String, dynamic>?;
        initOfferPriceBlocDIModule();
        initDeleteOfferPriceBlocDIModule();
        initMapOfferToInvoiceBlocDIModule();
        initExtractPdfDIModule();
        initOfferPriceDetailsBlocDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<OfferPriceBloc>()),
              BlocProvider(
                create: (context) => inject<OfferPriceDetailsBloc>(),
              ),
              BlocProvider(create: (context) => inject<DeleteOfferPriceBloc>()),
              BlocProvider(create: (context) => inject<ExtractPdfBloc>()),
              BlocProvider(
                create: (context) => inject<MapOfferToInvoiceBloc>(),
              ),
            ],
            child: OfferPriceScreen(fromHome: args?["fromHome"] as bool?),
          ),
        );
      case Routes.purchaseInvoiceDetailsScreen:
        initPurchaseInvoiceDetailsDIModule();
        initExtractPdfDIModule();
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => inject<PurchaseInvoiceDetailsBloc>()
                  ..add(
                    PurchaseInvoiceDetailsSubmitted(
                      id: (args['invoice'] as BuyInvoiceIndicatorEntity).uuid,
                      isReturn: args['isReturn'] as bool,
                    ),
                  ),
              ),
              BlocProvider(create: (context) => inject<ExtractPdfBloc>()),
             
            ],
            child: PurchaseInvoiceDetailsScreen(
              invoice: args['invoice'],
              isReturn: args['isReturn'] as bool,
            ),
          ),
        );
      case Routes.purchasePayScreen:
        initPurchasePayDIModule();
        initPaymentsMethodseDIModule();
        initBankAccountsDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<PurchasePayBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<PaymentMethodsBloc>()
                      ..add(PaymentMethodsSubmitted(isGuaranteeAllowed: true)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
            ],
            child: PurchasePayScreen(),
          ),
        );

      case Routes.createOfferPriceRoute:
        final args = setting.arguments as Map<String, dynamic>;
        initCreateOfferPriceBlocDIModule();
        initAdminBlocDIModule();
        initClientsBlocDIModule();
        initAccountsDIModule();
        initDiscountReasonBlocDIModule();
        initPaymentsMethodseDIModule();
        initBankAccountsDIModule();
        initOfferPriceDetailsBlocDIModule();
        initUpdateOfferPriceBlocDIModule();
        initWorkplaceDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<OfferPriceCreateBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<AdminBloc>()..add(AdminSubmitted(type: 1)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<PaymentMethodsBloc>()
                      ..add(PaymentMethodsSubmitted(isGuaranteeAllowed: true)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
              BlocProvider(create: (context) => inject<DiscountReasonsBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<ClientsBloc>()..add(ClientsSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<AccountsBloc>()..add(FetchAccounts()),
              ),
              BlocProvider(
                create: (context) => inject<OfferPriceDetailsBloc>(),
              ),
              BlocProvider(create: (context) => inject<OfferPriceUpdateBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<WorkplaceBloc>()..add(FetchWorkplaces()),
              ),
            ],
            child: CreateOfferPriceScreen(
              offerPriceEntity: args["offerPriceEntity"],
              fromEdit: args["fromEdit"],
            ),
          ),
        );
      case Routes.changePasswordRoute:
        initChangePasswordDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inject<ChangePasswordBloc>(),
            child: const ChangePasswordScreen(),
          ),
        );
      case Routes.mainRoute:
        initIndicatorsDIModule();
        initShiftReportDIModule();
        initReturnBlocDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AppBloc()),
              BlocProvider(
                create: (context) =>
                    IndicatorsBloc(inject())
                      ..add(GetDashboardStatisticsEvent()),
              ),
              BlocProvider(create: (context) => inject<ShiftReportBloc>()),
              BlocProvider(create: (context) => inject<ReturnsBloc>()),
              BlocProvider(create: (context) => AppBloc()),
            ],
            child: MainScreen(),
          ),
        );

      case Routes.indicatrocreen:
        initIndicatorsDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    IndicatorsBloc(inject())
                      ..add(GetDashboardStatisticsEvent()),
              ),
            ],
            child: const IndicatorsScreen(),
          ),
        );

      case Routes.addClientRoute:
        final args = setting.arguments as Map<String, dynamic>;

        initAddClientsDIModule();
        initClassificationsDIModule();
        initAddClientDetailsDIModule();
        initCountriesDIModule();
        initAddClientDetailsDIModule(); 
        initBuyerSchemeDIModule();
                  return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<AddClientBloc>()),
              BlocProvider(create: (context) => inject<ClassificationBloc>()),
              BlocProvider(create: (context) => inject<ClientDetailsBloc>()),
              BlocProvider(create: (context) => inject<CountriesBloc>()),
              BlocProvider(create: (context) => inject<ClientDetailsBloc>()),
              BlocProvider(
                create: (context) => BuyerSchemeBloc(inject())
                  ..add(const BuyerSchemeSubmitted(withLoading: true)),
              ),
            ],
            child: AddClientsScreen(
              fromEdit: args["fromEdit"],
              clientDataEntity: args["clientDataEntity"],
            ),
          ),
        );

      case Routes.addAdminRoute:
        final args = setting.arguments as Map<String, dynamic>?;
        initAddAdminDIModule();
        initCountriesDIModule();
        initRegionsDIModule();
        initCitiesDIModule();
        initRolesDIModule();
        initWorkplaceDIModule();
        initAdminDetailsDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<AddAdminBloc>()),
              BlocProvider(create: (context) => inject<CountriesBloc>()),
              BlocProvider(create: (context) => inject<RegionsBloc>()),
              BlocProvider(create: (context) => inject<CitiesBloc>()),
              BlocProvider(create: (context) => inject<RolesBloc>()),
              BlocProvider(create: (context) => inject<WorkplaceBloc>()),
              BlocProvider(create: (context) => inject<AdminDetailsBloc>()),
            ],
            child: AddAdminScreen(
              fromEdit: args?["fromEdit"] ?? false,
              adminDataEntity: args?["adminDataEntity"],
            ),
          ),
        );

      case Routes.printClientRoute:
        final args = setting.arguments as Map<String, dynamic>;
        initAddClientDetailsDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ClientDetailsBloc>()),
            ],
            child: PrintClientScreen(
              clientDataEntity: args['clientDataEntity'],
            ),
          ),
        );

      case Routes.printSupplierRoute:
        final args = setting.arguments as Map<String, dynamic>;
        initSupplierDetailsDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<SupplierDetailsBloc>()),
            ],
            child: PrintSupplierScreen(
              supplierDataEntity: args['supplierDataEntity'],
            ),
          ),
        );

      case Routes.sideMenuScreen:
        return MaterialPageRoute(builder: (_) => const SideMenuScreen());
      case Routes.clientsRoute:
        final args = setting.arguments as Map<String, dynamic>?;
        initClientsBlocDIModule();
        initClassificationsDIModule();
        initUpdateClientStatusDIModule();
        initDeleteClientDIModule();
        initCountriesDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ClientsBloc>()),
              BlocProvider(create: (context) => inject<ClassificationBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateClientStatusBloc>(),
              ),
              BlocProvider(create: (context) => inject<DeleteClientBloc>()),
              BlocProvider(create: (context) => inject<CountriesBloc>()),
            ],
            child: ClientsScreen(fromHome: args?["fromHome"] ?? false),
          ),
        );
      case Routes.supplierDetailsRoute:
        final args = setting.arguments as Map<String, dynamic>;
        initSupplierDetailsDIModule();
        initDeleteSupplierDIModule();
        initUpdateSupplierStatusDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<SupplierDetailsBloc>()),
              BlocProvider(create: (context) => inject<DeleteSupplierBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateSupplierStatusBloc>(),
              ),
            ],
            child: SupplierDetailsScreen(id: args["id"], name: args["name"]),
          ),
        );
      case Routes.suppliersRoute:
        initSuppliersDIModule();
        initClassificationsDIModule();
        initCountriesDIModule();
        initDeleteSupplierDIModule();
        initUpdateSupplierStatusDIModule();
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<SuppliersListBloc>()),
              BlocProvider(create: (context) => inject<DeleteSupplierBloc>()),
              BlocProvider(create: (context) => inject<ClassificationBloc>()),
              BlocProvider(create: (context) => inject<CountriesBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateSupplierStatusBloc>(),
              ),
            ],
            child: SuppliersScreen(fromHome: args?["fromHome"] ?? false),
          ),
        );
      case Routes.addSupplierRoute:
        initAddSuppliersDIModule();
        initCountriesDIModule();
        initRegionsDIModule();
        initCitiesDIModule();
        initCurrenciesDIModule();
        initSupplierDetailsDIModule();
        initSuppliersAccountsDIModule();
        initBuyerSchemeDIModule();
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<CountriesBloc>()),
              BlocProvider(create: (context) => inject<AddSupplierBloc>()),
              BlocProvider(create: (context) => inject<RegionsBloc>()),
              BlocProvider(create: (context) => inject<CitiesBloc>()),
              BlocProvider(create: (context) => inject<CurrenciesBloc>()),
              BlocProvider(create: (context) => inject<SupplierDetailsBloc>()),
              BlocProvider(
                create: (context) => inject<SuppliersAccountsBloc>(),
              ),
              BlocProvider(
                create: (context) => BuyerSchemeBloc(inject())
                  ..add(const BuyerSchemeSubmitted(withLoading: true)),
              ),
            ],
            child: AddSupplierScreen(
              fromEdit: args?["fromEdit"] ?? false,
              supplierId: args?["supplierId"] ?? null,
            ),
          ),
        );
      case Routes.clientDetailsRoute:
        final args = setting.arguments as Map<String, dynamic>;

        initAddClientDetailsDIModule();
        initUpdateClientStatusDIModule();
        initUserAdressDIModule();
        initDeleteClientDIModule();

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => inject<UpdateClientStatusBloc>(),
              ),
              BlocProvider(create: (context) => inject<ClientDetailsBloc>()),
              BlocProvider(create: (context) => inject<UserAddressBloc>()),
              BlocProvider(create: (context) => inject<DeleteClientBloc>()),
            ],
            child: ClientDetailsScreen(id: args["id"], name: args["name"]),
          ),
        );

      case Routes.adminDetailsRoute:
        final args = setting.arguments as Map<String, dynamic>;

        initAdminDetailsDIModule();
        initUpdateAdminStatusDIModule();
        initDeleteAdminDIModule();

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<AdminDetailsBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateAdminStatusBloc>(),
              ),
              BlocProvider(create: (context) => inject<DeleteAdminBloc>()),
            ],
            child: AdminDetailsScreen(id: args["id"]),
          ),
        );

      case Routes.salesIndicator:
        initSalesIndicatorsDIModule();
        var args = setting.arguments as DashboardStatisticsEntity;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SalesIndicatorsBloc(inject()),
            child: SalesIndicatorScreen(dashboardStatisticsEntity: args),
          ),
        );
      case Routes.buyIndicator:
        initBuyIndicatorsDIModule();
        var args = setting.arguments as DashboardStatisticsEntity;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => BuyIndicatorsBloc(inject())
              ..add(
                GetBuyInvoicesEvent(
                  withLoading: false,
                  page: 1,
                  clearInvoices: true,
                  searchText: null,
                ),
              )
              ..add(
                GetBuyReturnInvoicesEvent(
                  withLoading: false,
                  page: 1,
                  clearInvoices: true,
                  searchText: null,
                ),
              ),
            child: BuyIndicatorScreen(dashboardStatisticsEntity: args),
          ),
        );

      // case Routes.purchaseIndicator:
      //   return MaterialPageRoute(builder: (_) => const PurchaseIndicator());

      case Routes.clientsIndicatorScreen:
        initClientsIndicatorsDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ClientsIndicatorsBloc(inject())
                  ..add(GetClientsIndicatorsEvent()),
            child: const ClientsIndicatorScreen(),
          ),
        );
      case Routes.offerPriceToInvoiceScreen:
        final args = setting.arguments as Map<String, dynamic>;
        initMapOfferToInvoiceBlocDIModule();
        initBankAccountsDIModule();
        initCreateSaleInvoiceDIModule();
        initClientsBlocDIModule();
        initWorkplaceDIModule();
        initStockBlocDIModule();
        initPaymentsMethodseDIModule();
        initAccountsDIModule();
        initAdminBlocDIModule();

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    inject<AdminBloc>()..add(AdminSubmitted(type: 1)),
              ),
              BlocProvider(
                create: (context) => inject<MapOfferToInvoiceBloc>(),
              ),
              BlocProvider(create: (context) => inject<CashInTreasuryBloc>()),
              BlocProvider(
                create: (context) => inject<CreateSaleInvoiceBloc>(),
              ),
              BlocProvider(
                create: (context) =>
                    inject<ClientsBloc>()..add(ClientsSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<WorkplaceBloc>()..add(FetchWorkplaces()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<AccountsBloc>()..add(FetchAccounts()),
              ),
              BlocProvider(
                create: (context) => inject<StockBloc>()..add(StockSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<PaymentMethodsBloc>()
                      ..add(PaymentMethodsSubmitted(isGuaranteeAllowed: true)),
              ),
            ],
            child: OfferPriceToInvoiceScreen(
              offerPriceDataEntity:
                  args["offerPriceDataEntity"] as OfferPriceDataEntity,
            ),
          ),
        );
      case Routes.purchaseToInvoiceScreen:
        final args = setting.arguments as Map<String, dynamic>;
        initMapBuyOrderToInvoiceBlocDIModule();
        initBankAccountsDIModule();
        initAddPurchaseInvoiceDIModule();
        initWorkplaceDIModule();
        initStockBlocDIModule();
        initPaymentsMethodseDIModule();
        initAccountsDIModule();
        initAdminBlocDIModule();
        initSuppliersDIModule();

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    inject<AdminBloc>()..add(AdminSubmitted(type: 2)),
              ),
              BlocProvider(
                create: (context) => inject<MapBuyOrderToInvoiceBloc>(),
              ),
              BlocProvider(
                create: (context) =>
                    inject<SuppliersListBloc>()..add(SuppliersListSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
              BlocProvider(
                create: (context) => inject<AddPurchaseInvoiceBloc>(),
              ),
              // BlocProvider(
              //   create: (context) =>
              //       inject<ClientsBloc>()..add(ClientsSubmitted()),
              // ),
              BlocProvider(
                create: (context) =>
                    inject<WorkplaceBloc>()..add(FetchWorkplaces()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<AccountsBloc>()..add(FetchAccounts()),
              ),
              BlocProvider(
                create: (context) => inject<StockBloc>()..add(StockSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<PaymentMethodsBloc>()
                      ..add(PaymentMethodsSubmitted(isGuaranteeAllowed: true)),
              ),
            ],
            child: PurchasesToInvoiceScreen(
              uuid: args["uuid"] as String,
              buyOrderId: args["buyOrderId"] as int,
            ),
          ),
        );
      case Routes.supplierIndicatorScreen:
        initSuppliersIndicatorsDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                SuppliersIndicatorsBloc(inject())
                  ..add(GetSuppliersIndicatorsEvent()),
            child: const SupplierIndicatorScreen(),
          ),
        );

      // case Routes.bankIndicator:
      //   return MaterialPageRoute(builder: (_) => const BankIndicator());

      case Routes.producerIndicator:
        return MaterialPageRoute(builder: (_) => const ProducerIndicator());

      case Routes.indicatorProductDetail:
        return MaterialPageRoute(
          builder: (_) => const IndicatorProductDetail(),
        );

      // case Routes.shiftIndicator:
      //   return MaterialPageRoute(builder: (_) => const ShiftIndicator());

      // case Routes.shiftCombinedReport:
      //   return MaterialPageRoute(builder: (_) => const ShiftCombinedReport());

      // case Routes.shiftEndDetailedReport:
      //   return MaterialPageRoute(
      //     builder: (_) => const ShiftEndDetailedReport(),
      //   );
      case Routes.receiptDetailsScreen:
        final args = setting.arguments as Map<String, dynamic>;
        initBondDetailsDIModule();
        initUpdateBondDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            child: BondDetailsScreen(
              exchangeBondDataEntity:
                  args["exchangeBondDataEntity"] as ExchangeBondDataEntity,
              fromExchange: args["fromExchange"] as bool,
            ),
            providers: [
              BlocProvider(create: (context) => inject<BondDetailsBloc>()),
              BlocProvider(create: (context) => inject<UpdateBondBloc>()),
            ],
          ),
        );
      case Routes.receiptPrintScreen:
        final args = setting.arguments as Map<String, dynamic>;
        initBondDetailsDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<BondDetailsBloc>()),
            ],
            child: PrintBondScreen(
              fromExchange: args["fromExchange"] as bool,
              exchangeBondDataEntity:
                  args["exchangeBondDataEntity"] as ExchangeBondDataEntity,
            ),
          ),
        );

      case Routes.exchangeBondCreateCreateScreen:
        initExchnageBondCreateDIModule();
        initExchnageBondDIModule();
        initPaymentsMethodseDIModule();
        initBankAccountsDIModule();
        initAccountsDIModule();
        initTaxsDIModule();
        initUpdateBondDIModule();
        initBondDetailsDIModule();
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<BondsCreateBloc>()),
              BlocProvider(create: (context) => inject<BondsBloc>()),
              BlocProvider(create: (context) => inject<PaymentMethodsBloc>()),
              BlocProvider(create: (context) => inject<CashInTreasuryBloc>()),
              BlocProvider(create: (context) => inject<UpdateBondBloc>()),
              BlocProvider(create: (context) => inject<BondDetailsBloc>()),
            ],
            child: BondsCreateScreen(
              type: args["type"] as String,
              exchangeBondDataEntity:
                  args["exchangeBondDataEntity"] as ExchangeBondDataEntity?,
              fromEdit: args["fromEdit"] as bool,
            ),
          ),
        );

      case Routes.exchangeBondScreen:
        final args = setting.arguments as Map<String, dynamic>;
        initExchnageBondDIModule();
        initBankAccountsDIModule();
        initPaymentsMethodseDIModule();
        initUpdateBondDIModule();
        initBondDetailsDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            child: BondsScreen(
              type: args["type"],
              fromHome: args["fromHome"] ?? false,
            ),
            providers: [
              BlocProvider(create: (context) => inject<BondsBloc>()),
              BlocProvider(create: (context) => inject<PaymentMethodsBloc>()),
              BlocProvider(create: (context) => inject<CashInTreasuryBloc>()),
              BlocProvider(create: (context) => inject<UpdateBondBloc>()),
              BlocProvider(create: (context) => inject<BondDetailsBloc>()),
            ],
          ),
        );
      case Routes.SalesReturnsScreen:
        final args = setting.arguments as Map<String, dynamic>;
        initReturnBlocDIModule();
        initShiftReportDIModule();
        initSaleInvoiceDetailsDIModule();
        initExtractPdfDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            child: SalesInvoicesScreen(
              isReturn: args["isReturn"] as bool,
              fromHome: args["fromHome"] as bool?,
            ),
            providers: [
              BlocProvider(create: (context) => inject<ReturnsBloc>()),
              BlocProvider(create: (context) => inject<ShiftReportBloc>()),
              BlocProvider(create: (context) => inject<ExtractPdfBloc>()),
            ],
          ),
        );
      case Routes.purchaseInvoicesRoute:
        initBuyIndicatorsDIModule();
        initExtractPdfDIModule();
        initProfileDIModule();
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => BuyIndicatorsBloc(inject())
                  ..add(
                    GetBuyInvoicesEvent(
                      withLoading: false,
                      page: 1,
                      clearInvoices: true,
                      searchText: null,
                    ),
                  ),
              ),
              BlocProvider(create: (context) => inject<ExtractPdfBloc>()),
              // BlocProvider(
              //   create: (context) =>
              //       inject<ProfileBloc>()
              //         ..add(const ProfileSubmitted(withLoading: false)),
              // ),
            ],
            child: PurchaseInvoicesScreen(fromHome: args?["fromHome"] ?? false),
          ),
        );
      case Routes.purchaseReturnInvoicesRoute:
        initBuyIndicatorsDIModule();
        initExtractPdfDIModule();
        initProfileDIModule();
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => BuyIndicatorsBloc(inject())
                  ..add(
                    GetBuyReturnInvoicesEvent(
                      withLoading: false,
                      page: 1,
                      clearInvoices: true,
                      searchText: null,
                    ),
                  ),
              ),
              BlocProvider(create: (context) => inject<ExtractPdfBloc>()),
              // BlocProvider(
              //   create: (context) =>
              //       inject<ProfileBloc>()
              //         ..add(const ProfileSubmitted(withLoading: false)),
              // ),
            ],
            child: PurchaseReturnInvoicesScreen(
              fromHome: args?["fromHome"] ?? false,
            ),
          ),
        );
      case Routes.previousInvoiceScreen:
        initPreviousInvoiceDIModule();
        final args = setting.arguments as List<PreviousInvoiceEntity>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PreviousInvoiceBloc(inject()),
            child: PreviousInvoiceScreen(previousInvoices: args),
          ),
        );

      case Routes.editAccountScreen:
        final args = setting.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inject<EditAccountBloc>(),
            child: EditProfileScreen(
              data: args["data"] as AccountSettings,
              profileEntity: args["entity"] as ProfileEntity,
            ),
          ),
        );
      case Routes.accoutnScreen:
        initEditAccountDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<EditAccountBloc>()),
            ],
            child: AccountScreen(),
          ),
        );
      case Routes.upgradeAndSubscriptionsRoute:
        initUpgradeAndSubscriptionsDIModule();

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => UpgradeAndSubscriptionsBloc(inject())
              ..add(
                GetUpgradeAndSubscriptionsEvent(
                  refKey: context
                      .read<ProfileBloc>()
                      .profileEntity
                      ?.client
                      .refKey,
                ),
              ),
            child: const UpgradeAndSubscriptionsScreen(),
          ),
        );
      case Routes.paymentRoute:
        initPaymentDIModule();

        initUpgradeAndSubscriptionsDIModule();
        var args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => UpgradeAndSubscriptionsBloc(inject()),
              ),
              BlocProvider(create: (context) => PaymentBloc(inject())),
            ],
            child: PaymentScreen(
              package: args['package'] as PackageEntity,
              subscriptionId: args['subscriptionId'] as int,
              numOfPos: args['numOfPos'] as int,
              formNewPackage: args['formNewPackage'] as bool,
            ),
          ),
        );
      case Routes.costCenterScreen:
        final args = setting.arguments as DashboardStatisticsEntity;
        return MaterialPageRoute(
          builder: (_) => CostCenterScreen(dashboardStatistics: args),
        );
      // case Routes.shiftsIndicators:
      //   initShiftIndicatorsDIModule();
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (context) => inject<ShiftIndicatorsBloc>(),
      //       child: const ShiftsIndicatorsScreen(),
      //     ),
      //   );
      // case Routes.combinedShiftReportScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const CombinedShiftReportScreen(),
      //   );
      case Routes.shiftReportScreen:
        initShiftReportDIModule();
        initShiftDetailsDIModule();
        final args = setting.arguments as Map<String, dynamic>?;
        final shiftUuid = args?['uuid'] as String?;
        if (shiftUuid == null || shiftUuid.isEmpty) {
          throw ArgumentError(
            'ShiftReportScreen requires a non-empty uuid argument.',
          );
        }
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ShiftReportBloc>()),
              BlocProvider(create: (context) => inject<ShiftDetailsBloc>()),
            ],
            child: ShiftReportScreen(shiftUuid: shiftUuid),
          ),
        );
      case Routes.bankIndicatorsScreen:
        initBankIndicatorsDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inject<BankIndicatorsBloc>(),
            child: const BankIndicatorsScreen(),
          ),
        );
      case Routes.productIndicatorsScreen:
        // initProductIndicatorsDIModule();
        initProductsBlocDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                inject<ProductsBloc>()
                  ..add(const ProductsSubmitted(withLoading: true, perPage: 5)),
            child: ProductsIndicatorsScreen(),
          ),
          //  BlocProvider(
          //   create: (context) =>
          //       inject<ProductIndicatorsBloc>()..add(GetProductsEvent()),
          //   child: const ProductsIndicatorsScreen(),
          // ),
        );
      case Routes.productsScreen:
        initProductsBlocDIModule();
        initDeleteProductDIModule();
        initUpdateProductStatusDIModule();
        final args = setting.arguments as Map<String, dynamic>?;
        final fromHome = args?['fromHome'] as bool?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => inject<ProductsBloc>()
                  ..add(const ProductsSubmitted(withLoading: true, perPage: 5)),
              ),
              BlocProvider(create: (context) => inject<DeleteProductBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateProductStatusBloc>(),
              ),
            ],
            child: ProductsScreen(fromHome: fromHome),
          ),
        );
      case Routes.stocksScreen:
        initStockBlocDIModule();
        initUpdateStockStatusDIModule();
        initDeleteStockDIModule();
        initAdminBlocDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<StockBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateStockStatusBloc>(),
              ),
              BlocProvider(
                create: (context) => inject<delete_stock.DeleteStockBloc>(),
              ),
              BlocProvider(create: (context) => inject<AdminBloc>()),
            ],
            child: const StocksScreen(),
          ),
        );
      case Routes.addStockScreen:
        final args = setting.arguments as Map<String, dynamic>?;
        initAddStockDIModule();
        initStockDetailsDIModule();
        initWorkplaceDIModule();
        initAdminBlocDIModule();
        initCountriesDIModule();
        initRegionsDIModule();
        initCitiesDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<AddStockBloc>()),
              BlocProvider(create: (context) => inject<StockDetailsBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<WorkplaceBloc>()..add(FetchWorkplaces()),
              ),
              BlocProvider(create: (context) => inject<AdminBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<CountriesBloc>()
                      ..add(FetchCountries(withLoading: true)),
              ),
              BlocProvider(create: (context) => inject<RegionsBloc>()),
              BlocProvider(create: (context) => inject<CitiesBloc>()),
            ],
            child: AddStockScreen(
              fromEdit: args?['fromEdit'] ?? false,
              stockId: args?['id'] as String?,
            ),
          ),
        );
      case Routes.stockDetailsRoute:
        final args = setting.arguments as Map<String, dynamic>;
        initStockDetailsDIModule();
        initUpdateStockStatusDIModule();
        initDeleteStockDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<StockDetailsBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateStockStatusBloc>(),
              ),
              BlocProvider(
                create: (context) => inject<delete_stock.DeleteStockBloc>(),
              ),
            ],
            child: StockDetailsScreen(id: args['id'] as String),
          ),
        );
      case Routes.stockPrintScreen:
        initStockDetailsDIModule();
        final args = setting.arguments;
        StockEntity? stock;
        if (args is StockEntity) {
          stock = args;
        }
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<StockDetailsBloc>()),
            ],
            child: StockPrintScreen(stock: stock),
          ),
        );
      case Routes.clientPaymentMethodsRoute:
        initClientPaymentMethodsBlocDIModule();
        initDeleteClientPaymentMethodDIModule();
        initPaymentsMethodseDIModule();
        initDeleteClientPaymentMethodDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<PaymentMethodsBloc>()),
              BlocProvider(
                create: (context) => inject<ClientPaymentMethodsBloc>(),
              ),
              BlocProvider(
                create: (context) => inject<DeleteClientPaymentMethodBloc>(),
              ),
              BlocProvider(
                create: (context) => inject<DeleteClientPaymentMethodBloc>(),
              ),
            ],
            child: const ClientPaymentMethodsScreen(),
          ),
        );
      case Routes.addClientPaymentMethodScreen:
        final args = setting.arguments as Map<String, dynamic>?;
        initAddClientPaymentMethodDIModule();
        initClientPaymentMethodDetailsDIModule();

        initPaymentsMethodseDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => inject<AddClientPaymentMethodBloc>(),
              ),
              BlocProvider(
                create: (context) => inject<ClientPaymentMethodDetailsBloc>(),
              ),
              BlocProvider(create: (context) => inject<PaymentMethodsBloc>()),
            ],
            child: AddClientPaymentMethodScreen(
              type: args?['type'] as String? ?? '',
              fromEdit: args?['fromEdit'] ?? false,
              id: args?['id'] as String?,
            ),
          ),
        );
      case Routes.clientPaymentMethodDetailsRoute:
        final args = setting.arguments as Map<String, dynamic>?;
        initClientPaymentMethodDetailsDIModule();
        initDeleteClientPaymentMethodDIModule();
        initDeleteClientPaymentMethodDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => inject<ClientPaymentMethodDetailsBloc>(),
              ),
              BlocProvider(
                create: (context) => inject<DeleteClientPaymentMethodBloc>(),
              ),
              BlocProvider(create: (context) => inject<PaymentMethodsBloc>()),
            ],
            child: ClientPaymentMethodDetailsScreen(
              type: args?['type'] as String? ?? '',
              clientPaymentMethodId: args?['id'] as String? ?? '',
            ),
          ),
        );
      case Routes.productDetailsScreen:
        initProductDetailsDIModule();
        initDeleteProductDIModule();
        initUpdateProductStatusDIModule();
        final args = setting.arguments;
        ProductDetailsEntity productDetails;

        if (args is ProductEntity) {
          productDetails = ProductDetailsEntity(productData: args, stocks: []);
        } else if (args is ProductDetailsEntity) {
          productDetails = args;
        } else {
          productDetails = ProductDetailsEntity(productData: null, stocks: []);
        }

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => inject<ProductDetailsBloc>()
                  ..add(
                    ProductDetailsSubmitted(
                      productId:
                          productDetails.productData?.uuid ??
                          productDetails.productData?.id.toString() ??
                          '',
                    ),
                  ),
              ),
              BlocProvider(create: (context) => inject<DeleteProductBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateProductStatusBloc>(),
              ),
            ],
            child: ProductDetailsScreen(product: productDetails),
          ),
        );
      case Routes.productPrintScreen:
        initProductDetailsDIModule();
        final args = setting.arguments;
        ProductEntity? product;

        if (args is ProductEntity) {
          product = args;
        } else if (args is ProductDetailsEntity) {
          product = args.productData;
        }
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ProductDetailsBloc>()),
            ],
            child: ProductPrintScreen(product: product),
          ),
        );
      case Routes.settingsScreen:
        initSettingsDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inject<SettingsBloc>(),
            child: const SettingsScreen(),
          ),
        );
      case Routes.notificationSettingsScreen:
        initNotificationSettingsDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inject<NotificationSettingsBloc>(),
            child: const NotificationSettingsScreen(),
          ),
        );
      case Routes.posSettingsScreen:
        initClientsBlocDIModule();
        initPosSettingDIModule();
        // Initialize PosSetting dependencies
        // if (!inject.isRegistered<PosSettingRemoteDataSource>()) {
        //   inject.registerLazySingleton<PosSettingRemoteDataSource>(
        //     () => PosSettingRemoteDataSource(inject()),
        //   );
        // }
        // if (!inject.isRegistered<PosSettingRepository>()) {
        //   inject.registerLazySingleton<PosSettingRepository>(
        //     () => PosSettingRepository(inject(), inject()),
        //   );
        // }
        // if (!inject.isRegistered<PosSettingBloc>()) {
        //   inject.registerFactory<PosSettingBloc>(
        //     () => PosSettingBloc(inject()),
        //   );
        // }
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    inject<ClientsBloc>()
                      ..add(const ClientsSubmitted(withLoading: false)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<PosSettingBloc>()
                      ..add(const PosSettingSubmitted(withLoading: true)),
              ),
            ],
            child: const PosSettingsScreen(),
          ),
        );
      case Routes.helpAndSupportScreen:
        initHelpAndSupportDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inject<HelpAndSupportBloc>(),
            child: const HelpAndSupportScreen(),
          ),
        );
      case Routes.termsAndPolicy:
        initHelpAndSupportDIModule();
        var args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TermsAndPolicyScreen(
            headerTitle: args['headerTitle'],
            content: args['content'],
          ),
        );
      case Routes.notFoundStateRoute:
        var args = (setting.arguments as Map<String, dynamic>);
        return MaterialPageRoute(
          builder: (_) => NotFoundState(
            onPressed: args['onPressed'],
            showBackButton: args['showBackButton'] ?? true,
            title: args['title'],
          ),
        );
      case Routes.noInternetStateRoute:
        VoidCallback onPressed = setting.arguments as VoidCallback;
        return MaterialPageRoute(
          builder: (_) => NoInternetState(onPressed: onPressed),
        );
      case Routes.errorStateRoute:
        VoidCallback onPressed = setting.arguments as VoidCallback;
        return MaterialPageRoute(
          builder: (_) => ErrorState(onPressed: onPressed),
        );
      case Routes.paymentGatewayScreen:
        initPaymentGAtewayDIModule();
        var args = (setting.arguments as Map<String, dynamic>);
        return MaterialPageRoute(
          builder: (_) => PaymentGatewayScreen(
            amount: args['amount'],
            description: args['description'] ?? true,
            metadata: args['metadata'],
            refKey: args['refKey'],
          ),
        );
      case Routes.purchaseRequestScreen:
        initPurchaseRequestDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PurchaseRequestBloc(inject())
              ..add(
                const GetPurchaseRequestsEvent(
                  withLoading: true,
                  page: 1,
                  perPage: 10,
                  test: 1,
                  clearList: true,
                ),
              ),
            child: PurchaseRequestScreen(),
          ),
        );
      case Routes.purchaseRequestCreateScreen:
        final uuid = setting.arguments as String?;
        initPurchaseRequestCreateDIModule();
        initAdminBlocDIModule();
        initSuppliersDIModule();
        initDiscountReasonBlocDIModule();
        initPaymentsMethodseDIModule();
        initBankAccountsDIModule();
        initPosBlocDIModule();
        initWorkplaceDIModule();
        initStockBlocDIModule();
        if (uuid != null) {
          initTaxsDIModule();
          initTaxReasonBlocDIModule();
          initDiscountReasonBlocDIModule();
        }
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    WorkplaceBloc(inject())..add(FetchWorkplaces()),
              ),
              BlocProvider(
                create: (context) =>
                    StockBloc(inject())..add(StockSubmitted(withLoading: true)),
              ),
              BlocProvider(
                create: (context) =>
                    PurchaseRequestCreateBloc(inject(), inject()),
              ),
              BlocProvider(
                create: (context) => inject<PosBloc>()..add(PosSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<AdminBloc>()..add(AdminSubmitted(type: 2)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<PaymentMethodsBloc>()
                      ..add(PaymentMethodsSubmitted(isGuaranteeAllowed: true)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
              BlocProvider(create: (context) => inject<DiscountReasonsBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<SuppliersListBloc>()..add(SuppliersListSubmitted()),
              ),
            ],
            child: PurchaseRequestCreateScreen(uuid: uuid),
          ),
        );
      case Routes.purchaseRequestDetailsScreen:
        initPurchaseRequestDIModule();
        initPurchaseRequestDetailsDIModule();
        var args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => PurchaseRequestDetailsBloc(inject()),
              ),
              BlocProvider(create: (context) => PurchaseRequestBloc(inject())),
            ],
            child: PurchaseRequestDetailsScreen(
              uuid: args['uuid'],
              id: args['id'],
            ),
          ),
        );
      case Routes.addPurchaseInvoiceRoute:
        initAddPurchaseInvoiceDIModule();
        initAdminBlocDIModule();
        initSuppliersDIModule();
        initDiscountReasonBlocDIModule();
        initPaymentsMethodseDIModule();
        initBankAccountsDIModule();
        initPosBlocDIModule();
        initWorkplaceDIModule();
        initStockBlocDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    WorkplaceBloc(inject())..add(FetchWorkplaces()),
              ),
              BlocProvider(
                create: (context) =>
                    StockBloc(inject())..add(StockSubmitted(withLoading: true)),
              ),
              BlocProvider(
                create: (context) => AddPurchaseInvoiceBloc(inject()),
              ),
              BlocProvider(
                create: (context) => inject<PosBloc>()..add(PosSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<AdminBloc>()..add(AdminSubmitted(type: 2)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<PaymentMethodsBloc>()
                      ..add(PaymentMethodsSubmitted(isGuaranteeAllowed: true)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
              BlocProvider(create: (context) => inject<DiscountReasonsBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<SuppliersListBloc>()..add(SuppliersListSubmitted()),
              ),
            ],
            child: AddPurchaseInvoiceScreen(),
          ),
        );
      // case Routes.addPurchaseReturnInvoiceRoute:
      //   var args = setting.arguments as BuyInvoiceIndicatorEntity;
      //   initAddPurchaseReturnInvoiceDIModule();
      //   initAdminBlocDIModule();
      //   initClientsBlocDIModule();
      //   initDiscountReasonBlocDIModule();
      //   initPaymentsMethodseDIModule();
      //   initBankAccountsDIModule();
      //   initPosBlocDIModule();
      //   initWorkPlaceDIModule();
      //   return MaterialPageRoute(
      //     builder: (_) => MultiBlocProvider(
      //       providers: [
      //         BlocProvider(create: (context) => WorkPlaceBloc(inject())),
      //         BlocProvider(
      //           create: (context) => AddPurchaseReturnInvoiceBloc(inject()),
      //         ),
      //         BlocProvider(
      //           create: (context) => inject<PosBloc>()..add(PosSubmitted()),
      //         ),
      //         BlocProvider(
      //           create: (context) => inject<AdminBloc>()..add(AdminSubmitted()),
      //         ),
      //         BlocProvider(
      //           create: (context) => inject<PaymentMethodsBloc>()
      //             ..add(PaymentMethodsSubmitted()),
      //         ),
      //         BlocProvider(
      //           create: (context) => inject<CashInTreasuryBloc>()
      //             ..add(CashInTreasuryBankAccountsSubmitted()),
      //         ),
      //         BlocProvider(
      //           create: (context) => inject<DiscountReasonsBloc>(),
      //         ),
      //         BlocProvider(
      //           create: (context) =>
      //               inject<ClientsBloc>()..add(ClientsSubmitted()),
      //         ),
      //       ],
      //       child: AddPurchaseReturnInvoiceScreen(invoice: args),
      //     ),
      //   );
      case Routes.printInvoiceScreen:
        initPurchaseInvoiceDetailsDIModule();
        final args = setting.arguments as PrintInvoiceModel;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inject<PurchaseInvoiceDetailsBloc>()
              ..add(
                PurchaseInvoiceDetailsSubmitted(
                  id: args.uuid,
                  isReturn: args.isReturn,
                ),
              ),
            child: PrintInvoiceScreen(data: args, fromReturn: args.isReturn),
          ),
        );
      case Routes.printSaleInvoiceScreen:
        final args = setting.arguments as Map<String, dynamic>;
        initSaleInvoiceDetailsDIModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SaleInvoiceDetailsBloc(inject()),
            child: PrintSaleInvoiceScreen(
              uuid: args['uuid'],
              isReturn: args['isReturn'] as bool,
              fromPurchase: args['fromPurchase'] ?? false,
            ),
          ),
        );
      case Routes.printpurchaserequest:
        try {
          final args = setting.arguments as Map<String, dynamic>;
          print('Print purchase request route - Arguments: $args');
          print('Arguments type: ${args.runtimeType}');

          initPurchaseRequestDetailsDIModule();

          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => PurchaseRequestDetailsBloc(inject()),
                ),
              ],
              child: PurchaseRequestPrintScreen(
                uuid: args['uuid'] as String,
                isReturn: args['isReturn'] as bool,
              ),
            ),
          );
        } catch (e) {
          print('Error in printpurchaserequest route: $e');
          print('Arguments received: ${setting.arguments}');
          print('Arguments type: ${setting.arguments.runtimeType}');

          // Return an error route instead of crashing
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(child: Text('Navigation error: $e')),
            ),
          );
        }

      case Routes.offerPriceDetailsScreen:
        var args = setting.arguments as Map<String, dynamic>;
        initOfferPriceDetailsBlocDIModule();
        initDeleteOfferPriceBlocDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            child: OfferPriceDetailsScreen(
              offerPriceDataEntity:
                  args['offerPriceDataEntity'] as OfferPriceDataEntity,
            ),
            providers: [
              BlocProvider(
                create: (context) => OfferPriceDetailsBloc(inject()),
              ),
              BlocProvider(create: (context) => inject<DeleteOfferPriceBloc>()),
            ],
          ),
        );
      case Routes.returnInvoiceScreen:
        var args = setting.arguments as Map<String, dynamic>;
        initCreateReturnInvoiceDIModule();
        initInvoiceAfterReturnBlocDIModule();
        initBankAccountsDIModule();
        initPaymentsMethodseDIModule();
        initWorkplaceDIModule();
        initStockBlocDIModule();
        initAdminBlocDIModule();
        initClientsBlocDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ReturnInvoiceBloc(inject())),
              BlocProvider(
                create: (context) => SaleInvoiceAfterReturnBloc(inject()),
              ),
              BlocProvider(create: (context) => inject<CashInTreasuryBloc>()),
              BlocProvider(create: (context) => inject<PaymentMethodsBloc>()),
              BlocProvider(create: (context) => inject<AdminBloc>()),
              BlocProvider(create: (context) => WorkplaceBloc(inject())),
              BlocProvider(create: (context) => StockBloc(inject())),
              BlocProvider(create: (context) => inject<ClientsBloc>()),
            ],
            child: ReturnInvoiceScreen(
              saleInvoiceEntity: args["saleInvoiceEntity"] as SaleInvoiceEntity,
            ),
          ),
        );
      case Routes.purchaseInvoiceReturnScreen:
        var args = setting.arguments as Map<String, dynamic>;
        initPurchaseInvoiceReturnDIModule();
        initPurchaseInvoiceAfterReturnBlocDIModule();
        initBankAccountsDIModule();
        initPaymentsMethodseDIModule();
        initStockBlocDIModule();
        initAdminBlocDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => PurchaseInvoiceReturnBloc(inject()),
              ),
              BlocProvider(
                create: (context) => PurchaseInvoiceAfterReturnBloc(inject()),
              ),
              BlocProvider(create: (context) => inject<CashInTreasuryBloc>()),
              BlocProvider(create: (context) => inject<PaymentMethodsBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<StockBloc>()
                      ..add(const StockSubmitted(withLoading: true)),
              ),
              BlocProvider(create: (context) => inject<AdminBloc>()),
            ],
            child: PurchaseInvoiceReturnScreen(
              id: args["id"],
              uuid: args["uuid"],
            ),
          ),
        );
      case Routes.aiChatScreen:
        initAiChatDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ChatBloc>()),
              BlocProvider(create: (context) => inject<ChatInitializeBloc>()),
              BlocProvider(create: (context) => inject<ChatStopBloc>()),
            ],
            child: const ChatScreen(),
          ),
        );
      case Routes.adminsRoute:
        initAdminBlocDIModule();
        initWorkplaceDIModule();
        initUpdateAdminStatusDIModule();
        initDeleteAdminDIModule();
        final args = setting.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    inject<AdminBloc>(),
              ),
              BlocProvider(
                create: (context) =>
                    inject<WorkplaceBloc>()
                      ..add(const FetchWorkplaces(withLoading: true)),
              ),
              BlocProvider(
                create: (context) => inject<UpdateAdminStatusBloc>(),
              ),
              BlocProvider(create: (context) => inject<DeleteAdminBloc>()),
            ],
            child: AdminsScreen(fromHome: args?["fromHome"] ?? false),
          ),
        );
      case Routes.posListingRoute:
        final args = setting.arguments as Map<String, dynamic>?;
        initPosBlocDIModule();
        initUpdatePosStatusDIModule();
        initDeletePosDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    inject<PosBloc>()..add(PosListingSubmitted()),
              ),
              BlocProvider(create: (context) => inject<UpdatePosStatusBloc>()),
              BlocProvider(create: (context) => inject<DeletePosBloc>()),
            ],
            child: PosListingScreen(fromHome: args?["fromHome"] ?? false),
          ),
        );
      case Routes.addPosRoute:
        initCreatePosDIModule();
        initUpdatePosDIModule();
        initWorkplaceDIModule();
        initStockBlocDIModule();
        initBankAccountsDIModule();
        initAdminBlocDIModule();
        initPosDetailsDIModule();

        final String? posId = setting.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              if (posId != null) ...[
                BlocProvider(create: (context) => inject<PosDetailsBloc>()),
              ],
              BlocProvider(create: (context) => inject<CreatePosBloc>()),
              BlocProvider(create: (context) => inject<UpdatePosBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<WorkplaceBloc>()
                      ..add(const FetchWorkplaces(withLoading: true)),
              ),
              BlocProvider(
                create: (context) =>
                    inject<StockBloc>()..add(const StockSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<AdminBloc>()..add(const AdminSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<CashInTreasuryBloc>()
                      ..add(CashInTreasuryBankAccountsSubmitted()),
              ),
              BlocProvider(create: (context) => inject<PosDetailsBloc>()),
            ],
            child: AddPosScreen(posId: posId),
          ),
        );
      case Routes.posDetailsRoute:
        final args = setting.arguments as Map<String, dynamic>;
        initPosDetailsDIModule();
        initUpdatePosStatusDIModule();
        initDeletePosDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<PosDetailsBloc>()),
              BlocProvider(create: (context) => inject<UpdatePosStatusBloc>()),
              BlocProvider(create: (context) => inject<DeletePosBloc>()),
            ],
            child: PosDetailsScreen(
              posId: args['posId'] as String,
              posName: args['posName'] as String,
            ),
          ),
        );
      case Routes.shiftsRoute:
        final args = setting.arguments as Map<String, dynamic>?;
        initEndShiftDIModule();
        initShiftsBlocDIModule();
        initDeleteShiftDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ShiftsBloc>()),
              BlocProvider(create: (context) => inject<EndShiftBloc>()),
              BlocProvider(create: (context) => inject<DeleteShiftBloc>()),
            ],
            child: ShiftsScreen(fromHome: args?["fromHome"] ?? false),
          ),
        );
      case Routes.printShiftPlanRoute:
        initShiftPlanDetailsDIModule();

        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ShiftPlanDetailsBloc>()),
            ],
            child: ShiftPlanPrintScreen(id: args['id'] as String),
          ),
        );
      case Routes.printShiftOperationRoute:
        initShiftDetailsDIModule();
        initProfileDIModule();
        initReturnBlocDIModule();
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ShiftDetailsBloc>()),
              BlocProvider(create: (context) => PrintShiftOperationBloc()),
              BlocProvider(create: (context) => inject<ReturnsBloc>()),
            ],
            child: PrintShiftOperationScreen(
              uuid: args['uuid'] as String,
              id: args['id'] as String,
            ),
          ),
        );
      case Routes.shiftPlansRoute:
        initShiftPlansDIModule();
        initUpdateShiftPlanStatusDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ShiftPlansBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateShiftPlanStatusBloc>(),
              ),
            ],
            child: const ShiftPlansScreen(),
          ),
        );
      case Routes.shiftPlanDetailsRoute:
        initShiftPlanDetailsDIModule();
        initUpdateShiftPlanStatusDIModule();
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ShiftPlanDetailsBloc>()),
              BlocProvider(
                create: (context) => inject<UpdateShiftPlanStatusBloc>(),
              ),
            ],
            child: ShiftPlanDetailsScreen(id: args['id'] as String),
          ),
        );
      case Routes.addShiftPlanRoute:
        initAdminBlocDIModule();
        initPosBlocDIModule();
        initAddShiftPlanDIModule();
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    inject<AdminBloc>()..add(const AdminSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<PosBloc>()
                      ..add(const PosListingSubmitted(withLoading: true)),
              ),
            ],
            child: AddShiftPlanScreen(
              shiftPlanId: args?['shiftPlanId'] as String?,
            ),
          ),
        );
      case Routes.invoiceSettingsRoute:
        initInvoiceSettingDIModule();
        return MaterialPageRoute(
          builder: (context) {
            // Try to use the app-level bloc if it exists
            try {
              context.read<InvoiceSettingBloc>();
              // App-level bloc exists, use it directly
              return InvoiceSettingsScreen();
            } catch (_) {
              // If no app-level bloc exists, create a new one
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        inject<InvoiceSettingBloc>()
                          ..add(const InvoiceSettingSubmitted()),
                  ),
                ],
                child: InvoiceSettingsScreen(),
              );
            }
          },
        );
      case Routes.createProductRoute:
        final String? uuid = setting.arguments as String?;
        initCreateProductDIModule();
        initCategoryDIModule();
        initCreateCategoryDIModule();
        initMajorUnitDIModule();
        initCreateMajorUnitDIModule();
        initProductsBlocDIModule();
        initStockBlocDIModule();
        initTaxsDIModule();
        initTaxReasonBlocDIModule();

        initProductDetailsBlocDIModule();

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<CreateProductBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<CategoryBloc>()
                      ..add(const CategorySubmitted(isSelect: 1)),
              ),
              BlocProvider(create: (context) => inject<CreateCategoryBloc>()),
              BlocProvider(create: (context) => inject<CreateMajorUnitBloc>()),
              BlocProvider(
                create: (context) =>
                    inject<MajorUnitBloc>()..add(const MajorUnitSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<ProductsBloc>()
                      ..add(ProductsSubmitted(isSelect: 1, withLoading: false)),
              ),
              BlocProvider(
                create: (context) => inject<StockBloc>()..add(StockSubmitted()),
              ),
              BlocProvider(
                create: (context) =>
                    inject<TaxesBloc>()..add(FetchTaxesEvent()),
              ),
              BlocProvider(create: (context) => inject<TaxReasonsBloc>()),
              BlocProvider(create: (context) => inject<ProductDetailsBloc>()),
            ],
            child: CreateProductScreen(uuid: uuid),
          ),
        );
      case Routes.exportShiftsRoute:
        initShiftsBlocDIModule();
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => inject<ShiftsBloc>()),
            
            ],
            child: const ExportShiftsScreen(),
          ),
        );
      case Routes.workplacesScreen:
        initWorkplaceDIModule();
        initUpdateWorkplaceStatusDIModule();
        initAdminBlocDIModule();
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => WorkplaceBloc(inject())),
              BlocProvider(
                create: (context) => inject<UpdateWorkplaceStatusBloc>(),
              ),
              BlocProvider(
                create: (context) =>
                    AdminBloc(inject())..add(const AdminSubmitted()),
              ),
            ],
            child: WorkplacesScreen(fromHome: args?["fromHome"] ?? false),
          ),
        );
      case Routes.workplaceDetailsScreen:
        initWorkplaceDetailsDIModule();
        initUpdateWorkplaceStatusDIModule();
        initAdminBlocDIModule();
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => WorkplaceDetailsBloc(inject())),
              BlocProvider(
                create: (context) => inject<UpdateWorkplaceStatusBloc>(),
              ),

              BlocProvider(
                create: (context) =>
                    BuyerSchemeBloc(inject())
                      ..add(const BuyerSchemeSubmitted(withLoading: true)),
              ),

              BlocProvider(
                create: (context) =>
                    AdminBloc(inject())..add(const AdminSubmitted()),
              ),
            ],
            child: WorkplaceDetailsScreen(
              workPlaceId: args['uuid'],
              workPlaceName: args['name'],
            ),
          ),
        );
      case Routes.createWorkplaceScreen:
        initCreateWorkplaceBlocDIModule();
        initCountriesDIModule();
        initCitiesDIModule();
        initRegionsDIModule();
        initAdminBlocDIModule();
        initWorkplaceDetailsDIModule();
        initBuyerSchemeDIModule();
        final String? workplaceId = setting.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    AdminBloc(inject())..add(const AdminSubmitted()),
              ),
              BlocProvider(create: (context) => CreateWorkplaceBloc(inject())),
              BlocProvider(
                create: (context) =>
                    CountriesBloc(inject())..add(FetchCountries()),
              ),
              BlocProvider(create: (context) => CitiesBloc(inject())),
              BlocProvider(create: (context) => RegionsBloc(inject())),
              BlocProvider(
                create: (context) =>
                    BuyerSchemeBloc(inject())
                      ..add(const BuyerSchemeSubmitted(withLoading: true)),
              ),
              BlocProvider(create: (context) => WorkplaceDetailsBloc(inject())),
            ],
            child: CreateWorkplaceScreen(workplaceId: workplaceId),
          ),
        );
      case Routes.printWorkplaceRoute:
        try {
          final args = setting.arguments as Map<String, dynamic>?;
          final workplaceId = args?['workplaceId'] as String;
          initWorkplaceDetailsDIModule();
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => inject<WorkplaceDetailsBloc>(),
                ),
              ],
              child: PrintWorkplaceScreen(workplaceId: workplaceId),
            ),
          );
        } catch (e) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(child: Text('Navigation error: $e')),
            ),
          );
        }
      default:
        return unknownRoute(setting);
    }
  }

  static Route<MaterialPageRoute> unknownRoute(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => const UnknownRouteScreen());
}

class ValidateOtpParams {
  final String emailOrPhone;
  final bool loginWithPhone;
  final String? password;
  final bool fromForgotPassword;
  final int phoneCodeId;
  final bool fromChangeNumber;
  final ProfileEntity? profileEntity;
  final String? number;
  final bool fromChangePassword;
  ValidateOtpParams({
    required this.emailOrPhone,
    required this.loginWithPhone,
    this.fromForgotPassword = false,
    this.password,
    required this.phoneCodeId,
    required this.fromChangeNumber,
    this.profileEntity,
    this.number,
    required this.fromChangePassword,
    // this.profilePassword,
  });
}

class ForgotPasswordParams {
  final String emailOrPhone;
  final bool loginWithPhone;

  ForgotPasswordParams({
    required this.emailOrPhone,
    required this.loginWithPhone,
  });
}
