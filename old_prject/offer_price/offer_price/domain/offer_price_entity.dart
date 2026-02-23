import 'package:equatable/equatable.dart';
import 'package:fatoorahapp/core/classes/entities/admin_data_entity.dart';
import 'package:fatoorahapp/core/classes/entities/pagination_entity.dart';
import 'package:fatoorahapp/core/classes/entities/product_invoices_entity.dart';
import 'package:fatoorahapp/core/classes/entities/sale_invoice_entity.dart';
import 'package:fatoorahapp/core/classes/entities/tax_entity.dart';
import 'package:fatoorahapp/feature/clients/clients/domain/entities/clients_entity.dart';

class OfferPriceEntity extends Equatable {
  final List<OfferPriceDataEntity> offerPriceDataEntity;
  final PaginationEntity offerPricePagination;

  const OfferPriceEntity({
    required this.offerPriceDataEntity,
    required this.offerPricePagination,
  });

  @override
  List<Object?> get props => [offerPriceDataEntity, offerPricePagination];
}

class OfferPriceDataEntity extends Equatable {
  final int id;
  final String uuid;
  final String identificationNumber;
  final String date;
  final String expirationDate;
  final String status;
  final ClientsDataEntity user; // Reusing ClientsDataEntity
  final String totalPrice;
  final String netPrice;
  final bool isConverted;
  final String createdAt;
  final List<OfferPriceDetailEntity> offerPriceDetails;
  final List<SaleInvoicePaymentEntity> payments;
  final AdminDataEntity employeeDataEntity;
  const OfferPriceDataEntity({
    required this.id,
    required this.uuid,
    required this.identificationNumber,
    required this.date,
    required this.expirationDate,
    required this.status,
    required this.isConverted,
    required this.user,
    required this.totalPrice,
    required this.netPrice,
    required this.createdAt,
    required this.employeeDataEntity,
    required this.payments,
    required this.offerPriceDetails,
  });

  @override
  List<Object?> get props => [
    id,
    uuid,
    identificationNumber,
    date,
    expirationDate,
    status,
    user,
    totalPrice,
    netPrice,
    isConverted,
    createdAt,
    offerPriceDetails,
    payments,
  ];
}

class OfferProductEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final String salePrice;
  final String highestDiscountRate;
  final ProductUnitEntity productUnitEntity;

  const OfferProductEntity({
    required this.id,
    required this.productUnitEntity,
    required this.name,
    required this.image,
    required this.salePrice,
    required this.highestDiscountRate,
  });

  @override
  List<Object?> get props => [id, name, image, salePrice];
}

class OfferPriceDetailEntity extends Equatable {
  final int id;
  final String quantity;
  final String price;
  final String discountPrice;
  final String totalPrice;
  final OfferProductEntity product;
  final List<TaxEntity> taxes;
  final String discountValue;
  final int discountType;
  final int reasonId;

  const OfferPriceDetailEntity({
    required this.id,
    required this.quantity,
    required this.price,
    required this.discountPrice,
    required this.totalPrice,
    required this.product,
    required this.taxes,
    required this.discountValue,
    required this.discountType,
    required this.reasonId,
  });

  @override
  List<Object?> get props => [
    id,
    quantity,
    price,
    discountPrice,
    totalPrice,
    product,
    this.discountType,
    this.discountType,
    this.reasonId,
  ];
}

class CreateOfferPriceDataEntity extends Equatable {
  final String uuid;

  const CreateOfferPriceDataEntity({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}
