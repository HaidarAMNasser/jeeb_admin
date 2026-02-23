// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_price_model.dart';
// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferPriceModel _$OfferPriceModelFromJson(Map<String, dynamic> json) =>
    OfferPriceModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OfferPriceDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : PaginationModel.fromJson(
              json['pagination'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OfferPriceModelToJson(OfferPriceModel instance) =>
    <String, dynamic>{'data': instance.data, 'pagination': instance.pagination};

OfferPriceDataModel _$OfferPriceDataModelFromJson(Map<String, dynamic> json) {
  return OfferPriceDataModel(
    payments: (json['payments'] as List<dynamic>)
        .map((e) => Payment.fromJson(e as Map<String, dynamic>))
        .toList(),
    admin: json['employee'] == null
        ? null
        : AdminDataModel.fromJson(json['employee'] as Map<String, dynamic>),
    id: (json['id'] as num?)?.toInt(),
    uuid: json['uuid'] as String?,
    identificationNumber: json['identification_number'] as String?,
    date: json['date'] as String?,
    expirationDate: json['expirationDate'] as String?,
    status: json['status'] as String?,
    user: json['user'] == null
        ? null
        : ClientsDataModel.fromJson(json['user'] as Map<String, dynamic>),
    totalPrice: json['totalPrice'] as String?,
    netPrice: json['netPrice'] as String?,
    isConverted: json['is_converted'] as bool?,
    createdAt: json['created_at'] as String?,
  );
}

Map<String, dynamic> _$OfferPriceDataModelToJson(
  OfferPriceDataModel instance,
) => <String, dynamic>{
  'offerPriceDetails': instance.offerPriceDetails,
  'payments': instance.payments,
  'id': instance.id,
  'uuid': instance.uuid,
  'identification_number': instance.identificationNumber,
  'date': instance.date,
  'expirationDate': instance.expirationDate,
  'status': instance.status,
  'user': instance.user,
  'totalPrice': instance.totalPrice,
  'netPrice': instance.netPrice,
  'is_converted': instance.isConverted,
  'created_at': instance.createdAt,
};
OfferProductModel _$OfferProductModelFromJson(Map<String, dynamic> json) =>
    OfferProductModel(
      productUnitModel: json['unit'] == null
          ? null
          : ProductUnitModel.fromJson(json['unit'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      salePrice: json['salePrice'] as String?,
    );

Map<String, dynamic> _$OfferProductModelToJson(OfferProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'salePrice': instance.salePrice,
    };

OfferPriceDetailModel _$OfferPriceDetailModelFromJson(
  Map<String, dynamic> json,
) => OfferPriceDetailModel(
  id: (json['id'] as num?)?.toInt(),
  quantity: json['quantity'] as String?,
  price: json['price'] as String?,
  totalPrice: json['totalPrice'] as String?,
  product: json['product'] == null
      ? null
      : OfferProductModel.fromJson(json['product'] as Map<String, dynamic>),
  discountPrice: json['discountPrice'] as String?,
  taxes: (json['taxes'] as List<dynamic>?)
      ?.map((e) => TaxModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  discountValue: json['discountValue']?.toString(),
  discountType: json['discountType'] as int?,
  reasonId: json['reason_id'] as int?,
);

Map<String, dynamic> _$OfferPriceDetailModelToJson(
  OfferPriceDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'quantity': instance.quantity,
  'price': instance.price,
  'totalPrice': instance.totalPrice,
  'product': instance.product,
  'discountPrice': instance.discountPrice,
  'taxes': instance.taxes,
  'discountValue': instance.discountValue,
  'discountType': instance.discountType,
  'reason_id': instance.reasonId,
};



CreateOfferPriceDataModel _$CreateOfferPriceDataModelFromJson(Map<String, dynamic> json) =>
    CreateOfferPriceDataModel(
      uuid: json['uuid'] as String?,
    );

Map<String, dynamic> _$CreateOfferPriceDataModelToJson(CreateOfferPriceDataModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
    };
