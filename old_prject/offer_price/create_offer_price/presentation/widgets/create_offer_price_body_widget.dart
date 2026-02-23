import 'package:fatoorahapp/core/classes/entities/admin_data_entity.dart';
import 'package:fatoorahapp/core/classes/entities/workplace_entity.dart';
import 'package:fatoorahapp/core/constances/colors_manager.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/routing/navigation_extensions.dart';
import 'package:fatoorahapp/core/routing/routes.dart';
import 'package:fatoorahapp/feature/admin/presentation/widgets/admin_widget.dart';
import 'package:fatoorahapp/feature/bonds/create_bonds/presentation/widgets/select_date_widget.dart';
import 'package:fatoorahapp/feature/clients/clients/domain/entities/clients_entity.dart';
import 'package:fatoorahapp/feature/clients/clients/presentation/widgets/clients_widget.dart';
import 'package:fatoorahapp/feature/discount_reason/presentation/bloc/discount_reason_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/helpful_functions/has_form_changed.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/helpful_functions/initialize_edit_mode.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/widgets/create_offer_price_subbmission_button.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/widgets/paymnets/payment_section.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/widgets/products/products_section.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/sales_invoices/create_sale_invoice/presentation/widgets/summery_selection.dart';
import 'package:fatoorahapp/feature/offer_price/update_offer_price/presentation/bloc/update_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/work_place_section/work_place/presentation/widgets/workplace_widget.dart';
import 'package:fatoorahapp/widgets/helpful_widgets/custom_text_field_widget.dart';
import 'package:fatoorahapp/widgets/spacing_widget.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// لا يمكن اخيار كرسيقة الدفع نفشها مرتين
class CreateOfferPriceBodyScreen extends StatefulWidget {
  final bool fromEdit;
  final OfferPriceSingleEntity? offerPriceDataEntity;
  final String? adminId;
  const CreateOfferPriceBodyScreen({
    super.key,
    required this.fromEdit,
    required this.offerPriceDataEntity,
    required this.adminId,
  });
  @override
  State<CreateOfferPriceBodyScreen> createState() =>
      _CreateOfferPriceBodyScreenState();
}

class _CreateOfferPriceBodyScreenState
    extends State<CreateOfferPriceBodyScreen> {
  TextEditingController offerPirceNumber = TextEditingController();
  TextEditingController identificationNumber = TextEditingController();
  TextEditingController refrenceNumber = TextEditingController();
  String expirationDate = "";
  String date = "";
  String selectedClient = "";
  String selectedAdmin = "";
  String testId = "";
  String supplyDate = "";
  String serviceEndDate = "";
  String selectedPaymentMethod = "";
  int selectedWorkPlace = 0;

  void initState() {
    super.initState();
    if (widget.fromEdit && widget.offerPriceDataEntity != null) {
      _initializeEditMode();
    }
    BlocProvider.of<DiscountReasonsBloc>(
      context,
    ).add(DiscountReasonsSubmitted());
  }

  void _initializeEditMode() {
    EditModeInitializer.initializeEditMode(
      context: context,
      entity: widget.offerPriceDataEntity!,
      adminId: widget.adminId,
      refrenceNumber: refrenceNumber,
      identificationNumber: identificationNumber,
      setSelectedAdmin: (value) => selectedAdmin = value,
      setSelectedClient: (value) => selectedClient = value,
      setSelectedWorkPlace: (value) => selectedWorkPlace = value,
      setDate: (value) => date = value,
      setExpirationDate: (value) => expirationDate = value,
      setSupplyDate: (value) => supplyDate = value,
      setServiceEndDate: (value) => serviceEndDate = value,
    );
  }

  void _checkForChanges() {
    if (widget.fromEdit) {
      dispatchChangesIfNeeded(
        context: context,
        initialData: widget.offerPriceDataEntity,
        initialAdminId: widget.adminId ?? "",
        currentClientId: selectedClient,
        currentAdminId: selectedAdmin,
        currentWorkplaceId: selectedWorkPlace,
        currentExpirationDate: expirationDate,
        currentSupplyDate: supplyDate,
        currentServiceEndDate: serviceEndDate,
        currentReferenceNumber: refrenceNumber.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFromEdit = widget.fromEdit && widget.offerPriceDataEntity != null;
    return BlocConsumer<OfferPriceUpdateBloc, OfferPriceUpdateState>(
      listener: (context, updateState) {
        if (updateState is OfferPriceUpdateSuccess) {
          customToast(
            msg: TranslationsController.instance
                .getTranslations()
                .operationSuccessful,
          );
          context.pushNamed(
            Routes.printOfferPriceRoute,
            arguments: {'uuid': widget.offerPriceDataEntity!.uuid},
          );
        } else if (updateState is OfferPriceUpdateError) {
          customToast(msg: updateState.message);
          final userId = int.tryParse(selectedClient) ?? 0;
          final employeeId = int.tryParse(selectedAdmin) ?? 0;
          context.read<OfferPriceUpdateBloc>().add(
            ResetUpdateToInit(
              details: updateState.details,
              payments: updateState.payments,
              referenceNumber: identificationNumber.text,
              userId: userId,
              supplyDate: supplyDate,
              serviceEndDate: serviceEndDate,
              workPalceId: selectedWorkPlace,
              expirationDate: expirationDate,
              employeeId: employeeId,
              date: date,
              status: 1,
            ),
          );
        }
      },
      builder: (context, updateState) {
        return BlocConsumer<OfferPriceCreateBloc, CreateOfferPriceState>(
          listener: (context, state) {
            if (state is CreateOfferPriceSuccess) {
              customToast(
                msg: TranslationsController.instance
                    .getTranslations()
                    .operationSuccessful,
              );

              context.pushNamed(
                Routes.printOfferPriceRoute,
                arguments: {'uuid': state.createOfferPriceDataEntity.uuid},
              );
            } else if (state is CreateOfferPriceError) {
              customToast(msg: state.message);
              final userId = int.tryParse(selectedClient) ?? 0;
              final employeeId = int.tryParse(selectedAdmin) ?? 0;
              context.read<OfferPriceCreateBloc>().add(
                ResetToInit(
                  details: state.details,
                  payments: state.payments,
                  referenceNumber: identificationNumber.text,
                  userId: userId,
                  supplyDate: supplyDate,
                  serviceEndDate: serviceEndDate,
                  workPalceId: selectedWorkPlace,
                  expirationDate: expirationDate,
                  employeeId: employeeId,
                  date: date,
                  status: 1,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: SingleChildScrollView(
                padding: AppPadding.defaultPadding,
                child: Column(
                  children: [
                    Column(
                      spacing: AppHeight.s15,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFieldWidget(
                          isFieldRequired: false,
                          borderColor: ColorManager.borderColor,
                          hasBorder: true,
                          controller: refrenceNumber,
                          title: TranslationsController.instance
                              .getTranslations()
                              .referenceNumber,
                          hint: isFromEdit
                              ? widget.offerPriceDataEntity!.referenceNumber !=
                                        ""
                                    ? widget
                                          .offerPriceDataEntity!
                                          .referenceNumber
                                    : '0'
                              : '0',
                          onChanged: (value) {
                            _checkForChanges();
                          },
                        ),
                        SelectDateWidget(
                          withInit: true,
                          isRequired: true,
                          title: TranslationsController.instance
                              .getTranslations()
                              .offerDate,
                          initValue: isFromEdit && date.isNotEmpty
                              ? date
                              : null,
                          onDateSelected: (selectedDate) {
                            date = selectedDate;
                            _checkForChanges();
                          },
                        ),
                        SelectDateWidget(
                          allowOnlyFutureDates: true,
                          withInit: true,
                          isRequired: true,
                          title: TranslationsController.instance
                              .getTranslations()
                              .offerExpirationDate,
                          initValue: isFromEdit && expirationDate.isNotEmpty
                              ? expirationDate
                              : null,
                          onDateSelected: (selectedDate) {
                            expirationDate = selectedDate;

                            _checkForChanges();
                          },
                        ),

                        SelectDateWidget(
                          title: TranslationsController.instance
                              .getTranslations()
                              .quotationDate,
                          initValue: isFromEdit && supplyDate.isNotEmpty
                              ? supplyDate
                              : null,
                          onDateSelected: (selectedDate) {
                            supplyDate = selectedDate;
                            _checkForChanges();
                          },
                        ),

                        SelectDateWidget(
                          title: TranslationsController.instance
                              .getTranslations()
                              .quotationExpiryDate,
                          initValue: isFromEdit && serviceEndDate.isNotEmpty
                              ? serviceEndDate
                              : null,
                          onDateSelected: (selectedDate) {
                            serviceEndDate = selectedDate;
                            _checkForChanges();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppHeight.s15),
                    Column(
                      spacing: AppHeight.s10,
                      children: [
                        ClientsWidget(
                          onRefreshPressed: () {
                            setState(() {
                              selectedClient = "";
                              context
                                      .read<OfferPriceCreateBloc>()
                                      .selectedClient =
                                  "";
                            });
                            context.read<OfferPriceCreateBloc>().add(
                              CheckValidationEvent(),
                            );
                            _checkForChanges();
                          },
                          initOption: isFromEdit
                              ? "${widget.offerPriceDataEntity!.user.name} - ${widget.offerPriceDataEntity!.user.identificationNumber}"
                              : null,
                          onClientSelection: (val) {
                            setState(() {
                              ClientsDataEntity clientEntity = val;
                              selectedClient = clientEntity.id.toString();
                              context
                                      .read<OfferPriceCreateBloc>()
                                      .selectedClient =
                                  selectedClient;
                              context.read<OfferPriceCreateBloc>().add(
                                CheckValidationEvent(),
                              );
                            });
                            _checkForChanges();
                          },
                        ),
                        WorkPlaceWidget(
                          toCancel: true,
                          onCancel: () {
                            setState(() {
                              selectedWorkPlace = 0;
                            });
                            context.read<OfferPriceCreateBloc>().add(
                              CheckValidationEvent(),
                            );
                          },
                          initOption:
                              isFromEdit &&
                                  widget
                                          .offerPriceDataEntity
                                          ?.workplaceEntity !=
                                      null &&
                                  widget
                                          .offerPriceDataEntity!
                                          .workplaceEntity
                                          .name !=
                                      ""
                              ? "${widget.offerPriceDataEntity!.workplaceEntity.name} - ${widget.offerPriceDataEntity!.workplaceEntity.identificationNumber}"
                              : null,
                          onWorkPlaceSelection: (val) {
                            setState(() {
                              WorkplaceEntity workplaceEntity = val;
                              selectedWorkPlace = workplaceEntity.id;
                              context
                                  .read<OfferPriceCreateBloc>()
                                  .selectedWorkplace = selectedWorkPlace
                                  .toString();
                              context.read<OfferPriceCreateBloc>().add(
                                CheckValidationEvent(),
                              );
                            });
                            _checkForChanges();
                          },
                        ),
                        AdminWidget(
                          type: 1,
                          toCancel: true,
                          onCancel: () {
                            setState(() {
                              context
                                      .read<OfferPriceCreateBloc>()
                                      .selectedAdmin =
                                  "";
                              selectedAdmin = "";
                              context.read<OfferPriceCreateBloc>().add(
                                CheckValidationEvent(),
                              );
                            });
                          },
                          hintText: TranslationsController.instance
                              .getTranslations()
                              .salesRepresentative,
                          title: TranslationsController.instance
                              .getTranslations()
                              .salesRepresentative,
                          initOption: isFromEdit
                              ? (widget.offerPriceDataEntity!.employee != ""
                                    ? widget.offerPriceDataEntity!.employee
                                    : null)
                              : null,
                          onAdminSelection: (val) {
                            setState(() {
                              AdminDataEntity adminDataEntity = val;
                              selectedAdmin = adminDataEntity.id.toString();
                              context
                                      .read<OfferPriceCreateBloc>()
                                      .selectedAdmin =
                                  selectedAdmin;

                              context.read<OfferPriceCreateBloc>().add(
                                CheckValidationEvent(),
                              );
                            });
                            _checkForChanges();
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: AppHeight.s20),
                    productsSection(
                      fromEdit: isFromEdit,
                      offerPriceSingleEntity: widget.offerPriceDataEntity,
                    ),
                    SizedBox(height: AppHeight.s20),
                    BlocBuilder<OfferPriceCreateBloc, CreateOfferPriceState>(
                      builder: (context, state) {
                        if (state.details.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final num paid = state.payments.fold<num>(0, (sum, p) {
                          final text = p.amount?.text.trim() ?? '';
                          return sum + (num.tryParse(text) ?? 0);
                        });
                        final num remaining = state.finalAmount - paid;

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.r20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppPadding.p8),
                            child: Column(
                              children: [
                                SizedBox(height: AppHeight.s20),
                                SummarySection(
                                  productLength: state.details.length,
                                  taxableAmount: state.taxableAmount
                                      .toStringAsFixed(2),
                                  vatAmount: state.totalDiscount
                                      .toStringAsFixed(2),
                                  finalAmount: state.finalAmount
                                      .toStringAsFixed(2),
                                  taxAmount: state.taxAmount.toStringAsFixed(2),
                                  total: state.totalAmount.toStringAsFixed(2),
                                  remainingAmount: remaining.toStringAsFixed(2),
                                  payments: state.payments,
                                  totalFinalAmountForGuarantee:
                                      state.finalAmount,
                                ),
                                SizedBox(height: AppHeight.s10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: AppHeight.s25),
                    PaymentSection(
                      fromEdit: isFromEdit,
                      offerPriceSingleEntity: widget.offerPriceDataEntity,
                    ),
                    verticalSpace(height: 16.h),
                  ],
                ),
              ),
              bottomNavigationBar: createOfferPriceSubbmissionButton(
                refrenceNumber: refrenceNumber,
                offerPriceId: widget.fromEdit
                    ? widget.offerPriceDataEntity!.uuid
                    : null,
                fromEdit: widget.fromEdit,
                selectedClient: selectedClient,
                selectedAdmin: selectedAdmin,
                identificationNumber: identificationNumber,
                supplyDate: supplyDate,
                serviceEndDate: serviceEndDate,
                expirationDate: expirationDate,
                date: date,
                selectedWorkPlace: selectedWorkPlace,
              ),
            );
          },
        );
      },
    );
  }
}
