import 'package:fatoorahapp/core/classes/models/admin_data_model/admin_data_model.dart';
import 'package:fatoorahapp/core/classes/models/pagination_model/pagination_model.dart';
import 'package:fatoorahapp/core/classes/models/product_model/product_invoices_model.dart';
import 'package:fatoorahapp/core/classes/models/sale_invoice_model/sale_invoice_model.dart';
import 'package:fatoorahapp/core/classes/models/tax/tax_model.dart';
import 'package:fatoorahapp/feature/clients/clients/data/models/clients_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_price_model.g.dart';

@JsonSerializable()
class OfferPriceModel {
  @JsonKey(name: 'data')
  List<OfferPriceDataModel>? data;
  @JsonKey(name: 'pagination')
  PaginationModel? pagination;

  OfferPriceModel({this.data, this.pagination});

  factory OfferPriceModel.fromJson(Map<String, dynamic> json) =>
      _$OfferPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferPriceModelToJson(this);
}

@JsonSerializable()
class OfferPriceDataModel {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'uuid')
  String? uuid;
  @JsonKey(name: 'identification_number')
  String? identificationNumber;
  @JsonKey(name: 'date')
  String? date;
  @JsonKey(name: 'expirationDate')
  String? expirationDate;
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'user')
  ClientsDataModel? user; // Reusing ClientsDataModel
  @JsonKey(name: 'totalPrice')
  AdminDataModel? admin;
  @JsonKey(name: 'admin')
  String? totalPrice;
  @JsonKey(name: 'netPrice')
  String? netPrice;
  @JsonKey(name: 'is_converted')
  bool? isConverted;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'offerPriceDetails')
  List<OfferPriceDetailModel>? offerPriceDetails;
  @JsonKey(name: 'payments')
  List<Payment>? payments;
  OfferPriceDataModel({
    this.id,
    this.payments,
    this.uuid,
    this.identificationNumber,
    this.date,
    this.expirationDate,
    this.status,
    this.user,
    this.totalPrice,
    this.netPrice,
    this.isConverted,
    this.createdAt,
    this.admin,
  });

  factory OfferPriceDataModel.fromJson(Map<String, dynamic> json) =>
      _$OfferPriceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferPriceDataModelToJson(this);
}

@JsonSerializable()
class OfferProductModel {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'image')
  String? image;
  @JsonKey(name: 'salePrice')
  String? salePrice;
  @JsonKey(name: 'highest_discount_rate')
  String? highestDiscountRate;
  @JsonKey(name: 'unit')
  ProductUnitModel? productUnitModel;
  OfferProductModel({
    this.id,
    required this.productUnitModel,
    this.name,
    this.image,
    this.salePrice,
    this.highestDiscountRate,
  });
  factory OfferProductModel.fromJson(Map<String, dynamic> json) =>
      _$OfferProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$OfferProductModelToJson(this);
}

@JsonSerializable()
class OfferPriceDetailModel {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'quantity')
  String? quantity;
  @JsonKey(name: 'price')
  String? price;
  @JsonKey(name: 'totalPrice')
  String? totalPrice;
  @JsonKey(name: 'product')
  OfferProductModel? product;
  @JsonKey(name: 'discountPrice')
  String? discountPrice;
  @JsonKey(name: 'taxes')
  List<TaxModel>? taxes;
  @JsonKey(name: 'discountValue')
  String? discountValue;
  @JsonKey(name: 'discountType')
  int? discountType;
  @JsonKey(name: 'reason_id')
  int? reasonId;
  OfferPriceDetailModel({
    this.id,
    this.quantity,
    this.price,
    this.totalPrice,
    this.product,
    this.taxes,
    this.discountValue,
    this.reasonId,
    this.discountType,
    this.discountPrice,
  });
  factory OfferPriceDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OfferPriceDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$OfferPriceDetailModelToJson(this);
}



@JsonSerializable()
class CreateOfferPriceDataModel {

  @JsonKey(name: 'uuid')
  String? uuid;

  CreateOfferPriceDataModel({

    this.uuid,
   
  });

  factory CreateOfferPriceDataModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOfferPriceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOfferPriceDataModelToJson(this);
}