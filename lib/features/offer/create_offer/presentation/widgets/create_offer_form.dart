import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/bloc/create_offer_bloc.dart';
import 'package:jeeb_admin/features/offer/list_offer/domain/entities/offer_entity.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';
import 'package:jeeb_admin/features/offer/update_offer/presentation/bloc/update_offer_bloc.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/widgets/offer_description_fields.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/widgets/offer_products_section.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/widgets/offer_totals_section.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_date_select.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/widgets/offer_discount_section.dart';
import 'package:jeeb_admin/features/offer/create_offer/presentation/widgets/offer_form_submit_button.dart';
import 'package:jeeb_admin/features/offer/create_offer/helpful_functions/offer_validation.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_text_field.dart';

class CreateOfferForm extends StatefulWidget {
  final CreateOfferBloc bloc;
  final CreateOfferState state;
  final bool isEdit;
  final OfferEntity? offer;

  const CreateOfferForm({
    super.key,
    required this.bloc,
    required this.state,
    required this.isEdit,
    this.offer,
  });

  @override
  State<CreateOfferForm> createState() => _CreateOfferFormState();
}

class _CreateOfferFormState extends State<CreateOfferForm> {
  late List<ProductEntity> _selectedProducts;
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _discountValueController;

  @override
  void initState() {
    super.initState();
    _selectedProducts = List.from(widget.offer?.products ?? []);
    _nameController = TextEditingController(
      text: widget.state.name,
    );
    _descController = TextEditingController(
      text: widget.state.description,
    );
    _discountValueController = TextEditingController(
      text: widget.state.discountValue,
    );
  }

  @override
  void didUpdateWidget(CreateOfferForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.name != _nameController.text) {
      _nameController.text = widget.state.name;
    }
    if (widget.state.description != _descController.text) {
      _descController.text = widget.state.description;
    }
    if (widget.state.discountValue != _discountValueController.text) {
      _discountValueController.text = widget.state.discountValue;
    }
    if (widget.offer != null &&
        _selectedProducts.isEmpty &&
        widget.state.productIds.isNotEmpty) {
      _selectedProducts = widget.offer!.products;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _discountValueController.dispose();
    super.dispose();
  }

  void _addProduct(ProductEntity? product) {
    if (product == null) return;
    if (_selectedProducts.any((p) => p.id == product.id)) return;
    setState(() {
      _selectedProducts = [..._selectedProducts, product];
    });
    widget.bloc.add(
      UpdateOfferProductIds(_selectedProducts.map((e) => e.id).toList()),
    );
  }

  void _removeProduct(ProductEntity product) {
    setState(() {
      _selectedProducts = _selectedProducts
          .where((p) => p.id != product.id)
          .toList();
    });
    widget.bloc.add(
      UpdateOfferProductIds(_selectedProducts.map((e) => e.id).toList()),
    );
  }

  void _onSubmit() {
    offerValidationToast(
      name: widget.state.name,
      description: widget.state.description,
      productIds: widget.state.productIds,
      discountType: widget.state.discountType,
      discountValue: widget.state.discountValue,
    );
    if (!widget.state.isValid) return;
    if (widget.isEdit) {
      context.read<UpdateOfferBloc>().add(
        UpdateOfferSubmitted(
          id: widget.state.offerId!,
          name: widget.state.name,
          description: widget.state.description,
          productIds: widget.state.productIds,
          startDate: widget.state.startDate,
          endDate: widget.state.endDate,
          discountType: widget.state.discountType,
          discountValue: num.tryParse(widget.state.discountValue) ?? 0,
        ),
      );
    } else {
      widget.bloc.add(const CreateOfferSubmitted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.p16),
      child: Column(
        spacing: AppSize.s16.h,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            title: AppTranslation.offerName,
            hintText: AppTranslation.offerName,
            controller: _nameController,
            onChanged: (value) => widget.bloc.add(UpdateOfferName(value)),
          ),
          OfferProductsSection(
            selectedProducts: _selectedProducts,
            onSelectProduct: _addProduct,
            onRemoveProduct: _removeProduct,
          ),
          OfferTotalsSection(
            selectedProducts: _selectedProducts,
            state: state,
          ),
          OfferDiscountSection(
            state: state,
            discountValueController: _discountValueController,
            onDiscountTypeChanged: (v) =>
                widget.bloc.add(UpdateOfferDiscountType(v)),
            onDiscountValueChanged: (v) =>
                widget.bloc.add(UpdateOfferDiscountValue(v)),
          ),
          Row(
            children: [
              Expanded(
                child: CustomDateSelect(
                  title: AppTranslation.offerStartDate,
                  initialValue: state.startDate,
                  onDateSelected: (date) {
                    if (date != null) widget.bloc.add(UpdateOfferStartDate(date));
                  },
                ),
              ),
              SizedBox(width: AppWidth.s16),
              Expanded(
                child: CustomDateSelect(
                  title: AppTranslation.offerEndDate,
                  initialValue: state.endDate,
                  onDateSelected: (date) {
                    if (date != null) widget.bloc.add(UpdateOfferEndDate(date));
                  },
                ),
              ),
            ],
          ),

          OfferDescriptionFields(
            descriptionController: _descController,
            onDescriptionChanged: (v) =>
                widget.bloc.add(UpdateOfferDescription(v)),
          ),
          OfferFormSubmitButton(
            state: state,
            isEdit: widget.isEdit,
            onSubmit: _onSubmit,
          ),
        ],
      ),
    );
  }
}
