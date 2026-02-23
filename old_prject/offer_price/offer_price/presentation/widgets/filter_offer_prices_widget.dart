import 'package:fatoorahapp/core/classes/entities/admin_data_entity.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/font_manager.dart';
import 'package:fatoorahapp/core/constances/styles_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/admin/presentation/blocs/admin_bloc.dart';
import 'package:fatoorahapp/feature/bonds/create_bonds/presentation/widgets/select_date_widget.dart';
import 'package:fatoorahapp/feature/clients/clients/domain/entities/clients_entity.dart';
import 'package:fatoorahapp/feature/clients/clients/presentation/widgets/clients_widget.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/presentation/blocs/offer_price_bloc.dart';

import 'package:fatoorahapp/widgets/custom_drop_down_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/button_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/text_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterOfferPricesWidget extends StatefulWidget {
  const FilterOfferPricesWidget({
    super.key,
  });

  @override
  State<FilterOfferPricesWidget> createState() =>
      _FilterOfferPricesWidgetState();
}

class _FilterOfferPricesWidgetState extends State<FilterOfferPricesWidget> {
  String? selectedClient;
  String? fromDate;
  String? dueDate;
  String? selectedAdmin;
  String? from;
  String? to;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(height: AppHeight.s20),
        CustomText(
          text: TranslationsController.instance
              .getTranslations()
              .filterReceiptVouchers,
          textStyle: getExtraBoldStyle(fontSize: AppFontSize.s16),
        ),
        verticalSpace(height: AppHeight.s16),
        ClientsWidget(  
          isRequired: false,
          onClientSelection: (val) {
          ClientsDataEntity clientsDataEntity = val;
          selectedClient = clientsDataEntity.id.toString();
        }),
        BlocBuilder<AdminBloc, AdminState>(builder: (context, state) {
          return Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.s10.w),
              child: CustomDropDownWidget(
                isLoading: state is AdminLoadingState,
                isSuccess: state is AdminSuccessState,
                title: TranslationsController.instance
                    .getTranslations()
                    .purchaseAgentName,

                color: ColorManager.white,
                hintText: TranslationsController.instance
                    .getTranslations()
                    .purchaseAgentName,
                dropDownList:
                    state is AdminSuccessState ? state.adminDataEntity : [],
                onSelectItem: (val) {
                  setState(() {
                    AdminDataEntity adminDataEntity = val;
                    selectedAdmin = adminDataEntity.id.toString();
                  });
                },
              ));
        }),
        Row(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SelectDateWidget(
                  withInit: false,
                  onDateSelected: (date) {
                    fromDate = date;
                  },
                  title: TranslationsController.instance
                      .getTranslations()
                      .startDate),
            ),
            SizedBox(width: 8),
            Flexible(
              fit: FlexFit.loose,
              child: SelectDateWidget(
                  withInit: false,
                  onDateSelected: (date) {
                    dueDate = date;
                  },
                  title: TranslationsController.instance
                      .getTranslations()
                      .endDate),
            ),
          ],
        ),
        SizedBox(
          height: AppHeight.s18,
        ),
        Row(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SelectDateWidget(
                withInit: false,
                onDateSelected: (date) {
                  setState(() {
                    from = date;
                  });
                },
                title: TranslationsController.instance
                    .getTranslations()
                    .creationStartDate,
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              fit: FlexFit.loose,
              child: SelectDateWidget(
                withInit: false,
                onDateSelected: (date) {
                  setState(() {
                    to = date;
                  });
                },
                title: TranslationsController.instance
                    .getTranslations()
                    .creationEndDate,
              ),  
            ),
          ],
        ),
        // ...existing code...
        Row(
          children: [
            Flexible(
              child: CustomElevatedButton(
                elevation: 0,
                borderRadius: AppRadius.r100,
                borderWidth: 0,
                color: ColorManager.primaryColor,
                text: TranslationsController.instance
                    .getTranslations()
                    .appAndDisplay
                    .replaceAll('-', ''),
                textColor: ColorManager.white,
                textSize: AppFontSize.s14,
                // Remove width
                onPressed: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<OfferPriceBloc>(context).add(
                    OfferPriceSubmitted(
                      withLoading: true,
                      isFiltered: true,
                      adminId: selectedAdmin,
                      userId: selectedClient,
                      toDueDate: dueDate,
                      fromDueDate: fromDate,
                      to: to,
                      from: from,
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: CustomElevatedButton(
                elevation: 0,
                borderRadius: AppRadius.r100,
                borderWidth: 0,
                color: ColorManager.secondaryScaffoldBackgroundColor,
                text: TranslationsController.instance.getTranslations().cancel,
                textColor: ColorManager.inActiveText,
                textSize: AppFontSize.s14,
                // Remove width
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
// ...existing code...
        verticalSpace(height: AppHeight.s16),
      ],
    );
  }
}
