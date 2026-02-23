part of 'add_product_bloc.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object?> get props => [];
}

class InitializeProduct extends AddProductEvent {
  final CreateProductEntity? productToEdit;
  final int? editIndex;
  const InitializeProduct({this.productToEdit, this.editIndex});
}

class ProductSelected extends AddProductEvent {
  final ProductEntity product;
  final String discountReason;
  final String discountReasonId;
  final String discountType;
  final String discountTypeId;
  final String discountValue;
  final String taxReason;
  final String taxReasonId;
  final String taxType;
  final String? buyPrice;
  final String taxTypeId;
  final String highestDiscountRate;
  final String saleProductPrice;
  const ProductSelected(
    this.product,
    this.discountReason,
    this.discountReasonId,
    this.discountType,
    this.discountTypeId,
    this.discountValue,
    this.taxReason,
    this.taxReasonId,
    this.taxType,
    this.taxTypeId,
    this.buyPrice,
    this.highestDiscountRate,
    this.saleProductPrice,
  );
}

class QuantityChanged extends AddProductEvent {
  final String quantity;
  const QuantityChanged(this.quantity);
}

class PriceChanged extends AddProductEvent {
  final String price;
  const PriceChanged(this.price);
}

class DiscountValueChanged extends AddProductEvent {
  final String value;
  const DiscountValueChanged(this.value);
}

class DiscountTypeSelected extends AddProductEvent {
  final DisCountType discountType;
  const DiscountTypeSelected(this.discountType);
}

class DiscountReasonSelected extends AddProductEvent {
  final DiscountReasonDataEntity reason;
  const DiscountReasonSelected(this.reason);
}

class TaxSelected extends AddProductEvent {
  final cTax.TaxEntity tax;
  const TaxSelected(this.tax);
}

class TaxReasonSelected extends AddProductEvent {
  final TaxReasonDataEntity reason;
  const TaxReasonSelected(this.reason);
}

class TaxValueChanged extends AddProductEvent {
  final String taxValue;
  const TaxValueChanged(this.taxValue);
}

class SubmitProduct extends AddProductEvent {}

class SubmitAndReset extends AddProductEvent {}
