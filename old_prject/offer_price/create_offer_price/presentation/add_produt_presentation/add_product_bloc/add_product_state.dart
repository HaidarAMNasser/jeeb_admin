part of 'add_product_bloc.dart';

class AddProductState extends Equatable {
  final CreateProductEntity? productToEdit;
  final int? editIndex;
  final bool isEditMode;

  final CreateProductEntity? selectedProduct;
  final String quantity;
  final String price;
  final String? buyPrice;
  final String discountValue;
  final String? taxValue;
  final String? selectedTaxId;
  final String? selectedTaxName;
  final String? selectedTaxKey;
  final String? selectedDiscountTypeId;
  final String? selectedDiscountType;
  final String? selectedDiscountReasonId;
  final String? selectedDiscountReason;
  final String? selectedTaxReasonId;
  final String? selectedTaxReason;
  final String highestDiscountRate;
  final String saleProductPrice;

  const AddProductState({
    this.productToEdit,
    this.editIndex,
    this.isEditMode = false,
    this.selectedProduct,
    this.quantity = '',
    this.price = '',
    this.buyPrice,
    this.discountValue = '',
    this.taxValue = '0.0',
    this.selectedTaxId,
    this.selectedTaxName,
    this.selectedTaxKey,
    this.selectedDiscountTypeId,
    this.selectedDiscountType,
    this.selectedDiscountReasonId,
    this.selectedDiscountReason,
    this.selectedTaxReasonId,
    this.selectedTaxReason,
    this.highestDiscountRate = '0',
    this.saleProductPrice = '0',
  });

  AddProductState copyWith({
    CreateProductEntity? productToEdit,
    int? editIndex,
    bool? isEditMode,
    CreateProductEntity? selectedProduct,
    String? quantity,
    String? price,
    String? discountValue,
    String? buyPrice,
    String? highestDiscountRate,
    String? saleProductPrice,

    // These functions allow us to explicitly set a value to null
    String? Function()? selectedTaxId,
    String? Function()? taxValue,
    String? Function()? selectedTaxName,
    String? Function()? selectedTaxKey,
    String? Function()? selectedDiscountTypeId,
    String? Function()? selectedDiscountType,
    String? Function()? selectedDiscountReasonId,
    String? Function()? selectedDiscountReason,
    String? Function()? selectedTaxReasonId,
    String? Function()? selectedTaxReason,
  }) {
    return AddProductState(
      highestDiscountRate: highestDiscountRate ?? this.highestDiscountRate,
      saleProductPrice: saleProductPrice ?? this.saleProductPrice,
      productToEdit: productToEdit ?? this.productToEdit,
      editIndex: editIndex ?? this.editIndex,
      isEditMode: isEditMode ?? this.isEditMode,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      buyPrice: buyPrice ?? this.buyPrice,
      taxValue: taxValue != null ? taxValue() : this.taxValue,
      discountValue: discountValue ?? this.discountValue,
      selectedTaxId: selectedTaxId != null
          ? selectedTaxId()
          : this.selectedTaxId,
      selectedTaxName: selectedTaxName != null
          ? selectedTaxName()
          : this.selectedTaxName,
      selectedTaxKey: selectedTaxKey != null
          ? selectedTaxKey()
          : this.selectedTaxKey,
      selectedDiscountTypeId: selectedDiscountTypeId != null
          ? selectedDiscountTypeId()
          : this.selectedDiscountTypeId,
      selectedDiscountType: selectedDiscountType != null
          ? selectedDiscountType()
          : this.selectedDiscountType,
      selectedDiscountReasonId: selectedDiscountReasonId != null
          ? selectedDiscountReasonId()
          : this.selectedDiscountReasonId,
      selectedDiscountReason: selectedDiscountReason != null
          ? selectedDiscountReason()
          : this.selectedDiscountReason,
      selectedTaxReasonId: selectedTaxReasonId != null
          ? selectedTaxReasonId()
          : this.selectedTaxReasonId,
      selectedTaxReason: selectedTaxReason != null
          ? selectedTaxReason()
          : this.selectedTaxReason,
    );
  }

  bool get isFormValid => selectedProduct != null && quantity.isNotEmpty;

  bool get hasChanges {
    if (!isEditMode) return false;
    return (selectedProduct?.id != productToEdit?.id ||
        selectedTaxId != productToEdit?.taxId ||
        selectedTaxName != productToEdit?.tax ||
        selectedTaxKey != productToEdit?.taxKey ||
        selectedTaxReasonId != productToEdit?.taxReasonId ||
        selectedTaxReason != productToEdit?.taxReason ||
        selectedDiscountReason != productToEdit?.disCountReason ||
        selectedDiscountReasonId != productToEdit?.disCountReasonId ||
        quantity != productToEdit?.quantity ||
        buyPrice != productToEdit?.buyPrice ||
        taxValue != productToEdit?.taxValue ||
        price != productToEdit?.price ||
        discountValue != productToEdit?.discountValue ||
        selectedDiscountType != productToEdit?.discountType ||
        selectedDiscountTypeId != productToEdit?.discountTypeId);
  }

  @override
  List<Object?> get props => [
    productToEdit,
    editIndex,
    isEditMode,
    selectedProduct,
    quantity,
    price,
    discountValue,
    buyPrice,
    taxValue,
    selectedTaxId,
    selectedTaxName,
    selectedTaxKey,
    selectedDiscountTypeId,
    selectedDiscountType,
    selectedDiscountReasonId,
    selectedDiscountReason,
    selectedTaxReasonId,
    selectedTaxReason,
  ];
}
