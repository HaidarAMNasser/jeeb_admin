import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/constances/values_manager.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/discount_reason/presentation/bloc/discount_reason_bloc.dart';
import 'package:fatoorahapp/feature/discount_reason/presentation/widgets/discount_reason_widget.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/add_produt_presentation/add_product_bloc/add_product_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/add_produt_presentation/widgets/add_product_subbmissions_buttons.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/widgets/products/discount_widget.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/widgets/products/product_widget.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/widgets/products/quantity_price_widget.dart';
import 'package:fatoorahapp/feature/taxs/presentation/presentation/widgets/tax_widget.dart';
import 'package:fatoorahapp/feature/product_indicators/domain/entities/product_entity.dart';
import 'package:fatoorahapp/feature/tax_reason/presentation/bloc/tax_reason_bloc.dart';
import 'package:fatoorahapp/feature/tax_reason/presentation/widgets/tax_reason_widget.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddProductSheet extends StatelessWidget {
  final CreateProductEntity? productToEdit;
  final int? editIndex;

  const AddProductSheet({super.key, this.productToEdit, this.editIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddProductBloc(
            null,
            context.read<OfferPriceCreateBloc>(),
            null,
            null,
            null,
            null,
            // context.read<MapOfferToInvoiceBloc>(),
            // null,
            // null,
            // null,
            // null,
            // null,
          )..add(
            InitializeProduct(
              productToEdit: productToEdit,
              editIndex: editIndex,
            ),
          ),
      child: const AddProductView(),
    );
  }
}

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountValueController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProductEntity? productEntity;
  Key discountWidgetKey = UniqueKey();
  Key taxWidgetKey = UniqueKey();
  Key taxSelectionWidgetKey = UniqueKey();
  Key productSelectionWidgetKey = UniqueKey();
  @override
  void initState() {
    super.initState();
    final initialState = context.read<AddProductBloc>().state;
    quantityController.text = initialState.quantity;
    priceController.text = initialState.price;
    discountValueController.text = initialState.discountValue;
  }

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    discountValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductBloc, AddProductState>(
      listener: (context, state) {
        if (quantityController.text != state.quantity) {
          quantityController.text = state.quantity;
        }
        if (priceController.text != state.price) {
          priceController.text = state.price;
        }
        if (discountValueController.text != state.discountValue) {
          discountValueController.text = state.discountValue;
        }
        BlocProvider.of<TaxReasonsBloc>(context).add(
          TaxReasonsSubmitted(
            key: state.selectedTaxKey ?? "",
            withLoading: true,
          ),
        );
      },
      builder: (context, state) {
        final bloc = context.read<AddProductBloc>();
        final String taxRate = (state.taxValue ?? "").trim();
        final String taxReasonId = state.selectedTaxReasonId ?? "";
        final bool needsTaxReason = taxRate.isNotEmpty && taxRate != "15.00";
        final bool isTaxReasonMissing = needsTaxReason && taxReasonId.isEmpty;
        final bool baseValid = state.isEditMode
            ? (state.isFormValid && state.hasChanges)
            : state.isFormValid;
        final bool isButtonActive = baseValid && !isTaxReasonMissing;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSize.s20.w,
            AppSize.s30.h,
            AppSize.s20.w,
            AppSize.s30.h + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductWidget(
                    key: productSelectionWidgetKey,
                    isEditMode: state.isEditMode,
                    name: state.productToEdit?.name,
                    onEditProduct: (val) {
                      setState(() {
                        productEntity = val;
                        discountWidgetKey = UniqueKey();
                        taxWidgetKey = UniqueKey();
                        taxSelectionWidgetKey = UniqueKey();
                      });
                      bloc.add(
                        ProductSelected(
                          val,
                          state.selectedDiscountReason ?? "",
                          state.selectedDiscountReasonId ?? "0",
                          state.selectedDiscountType ?? "",
                          state.selectedDiscountTypeId ?? "0",
                          state.discountValue,
                          "",
                          "0",
                          '',
                          "",
                          state.highestDiscountRate,
                          state.saleProductPrice,
                          state.buyPrice ?? '',
                        ),
                      );

                      if (val.tax.isNotEmpty) {
                        bloc.add(TaxSelected(val.tax[0]));

                        context.read<TaxReasonsBloc>().add(
                          TaxReasonsSubmitted(
                            key: val.tax[0].key,
                            withLoading: true,
                          ),
                        );

                        if (val.tax[0].taxReason != null)
                          bloc.add(TaxReasonSelected(val.tax[0].taxReason!));
                        // bloc.add(ProductSelected(
                        //   val,
                        //   state.selectedDiscountReason ?? "",
                        //   state.selectedDiscountReasonId ?? "0",
                        //   state.selectedDiscountType ?? "",
                        //   state.selectedDiscountTypeId ?? "0",
                        //   state.discountValue ?? "0",
                        //   state.selectedTaxReason ?? "",
                        //   state.selectedTaxReasonId ?? "0",
                        //   state.selectedTaxId ?? "0",
                        //   state.selectedTaxName ?? "",
                        //   state.highestDiscountRate,
                        //   state.saleProductPrice,
                        // ));
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSize.s10),
                    child: quantityPriceWidget(
                      quantityController,
                      priceController,
                      onQuantityChanged: (val) =>
                          bloc.add(QuantityChanged(val)),
                      onPriceChanged: (val) => bloc.add(PriceChanged(val)),
                    ),
                  ),
                  DisCountWidget(
                    highestDiscountRate:
                        state.highestDiscountRate.isNotEmpty &&
                            state.highestDiscountRate != ""
                        ? num.tryParse(state.highestDiscountRate) != 0
                              ? num.tryParse(
                                  state.highestDiscountRate,
                                ).toString()
                              : null
                        : null,
                    selectedDiscountTypeId: state.selectedDiscountTypeId,
                    saleProductPrice: state.saleProductPrice,
                    key: discountWidgetKey,
                    isEditMode: state.isEditMode,
                    discountValueController: discountValueController,
                    initOption: DisCountType.fromId(
                      state.selectedDiscountTypeId ?? "",
                    ).title,
                    onSetDiscountType: (val) {
                      bloc.add(DiscountTypeSelected(val));
                      context.read<DiscountReasonsBloc>().add(
                        DiscountReasonsSubmitted(),
                      );
                      discountValueController.clear();
                    },
                    onSetValue: (val) {
                  

                      bloc.canAddDiscount(
                        value: discountValueController,
                        highestDiscountRate: state.highestDiscountRate,
                        saleProductPrice: state.saleProductPrice,
                        discountType: state.selectedDiscountTypeId.toString(),
                        onSet: () {
                          bloc.add(DiscountValueChanged(val)); // عند النجاح
                        },
                        onFail: () {
                          bloc.add(DiscountValueChanged('0')); // عند الفشل
                        },
                      );
                    },
                  ),
                  if (state.selectedDiscountTypeId != null) ...[
                    SizedBox(height: AppSize.s10),
                    discountReasonWidget(
                      initOptionTitle:
                          state.selectedDiscountReason != null &&
                              state.selectedDiscountReason != ""
                          ? state.selectedDiscountReason
                          : null,
                      onDiscountReasonSelection: (val) =>
                          bloc.add(DiscountReasonSelected(val)),
                      initOption: state.selectedDiscountReason != ""
                          ? state.selectedDiscountReason
                          : null,
                    ),
                  ],
                  SizedBox(height: AppSize.s10),
                  TaxDropdownWidget(
                    key: taxSelectionWidgetKey,
                    isEditMode: state.isEditMode,
                    initialTax: state.selectedTaxName,
                    initialTaxId: state.selectedTaxId,
                    selectedTaxId: state.selectedTaxId,
                    selectedTaxName: state.selectedTaxName,
                    onTaxSelected: (val) {
                      bloc.add(TaxSelected(val));
                      context.read<TaxReasonsBloc>().add(
                        TaxReasonsSubmitted(key: val.key, withLoading: true),
                      );
                      setState(() {
                        taxWidgetKey = UniqueKey();
                      });
                    },
                  ),
                  SizedBox(height: AppSize.s10),
                  if (state.selectedTaxId != null)
                    TaxReasonWidget(
                      key: taxWidgetKey,
                      (val) => bloc.add(TaxReasonSelected(val)),
                      state.selectedTaxReason,
                      needsTaxReason,
                    ),
                  SizedBox(height: AppSize.s20),
                  addProductSubbmissionButtons(
                    isEditMode: state.isEditMode,
                    isButtonActive: isButtonActive,
                    isFormValid: state.isFormValid,
                    onSave: () {
                      if (state.selectedProduct == null) {
                        customToast(
                          msg: TranslationsController.instance
                              .getTranslations()
                              .selectProductToast,
                        );
                      } else if (state.quantity.isEmpty) {
                        customToast(
                          msg: TranslationsController.instance
                              .getTranslations()
                              .pleaseEnterQuantity,
                        );
                      } else if (_formKey.currentState!.validate()) {
                        final String taxRate = (state.taxValue ?? "").trim();
                        final String taxReasonId =
                            state.selectedTaxReasonId ?? "";
                        if (taxRate.isNotEmpty &&
                            taxRate != "15.00" &&
                            taxReasonId.isEmpty) {
                          customToast(
                            msg: TranslationsController.instance
                                .getTranslations()
                                .enterTaxReason,
                          );
                          return;
                        }
                        bloc.add(SubmitProduct());
                        Navigator.of(context).pop();
                      }
                    },
                    onSaveAndAddNew: () {
                      if (_formKey.currentState!.validate()) {
                        final String taxRate = (state.taxValue ?? "").trim();
                        final String taxReasonId =
                            state.selectedTaxReasonId ?? "";
                        if (taxRate.isNotEmpty &&
                            taxRate != "15.00" &&
                            taxReasonId.isEmpty) {
                          customToast(
                            msg: TranslationsController.instance
                                .getTranslations()
                                .enterTaxReason,
                          );
                          return;
                        }
                        bloc.add(SubmitAndReset());
                        setState(() {
                          productSelectionWidgetKey = UniqueKey();
                          discountWidgetKey = UniqueKey();
                          taxWidgetKey = UniqueKey();
                          taxSelectionWidgetKey = UniqueKey();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
