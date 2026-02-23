import 'package:fatoorahapp/core/classes/entities/account_entity.dart';
import 'package:fatoorahapp/core/classes/entities/admin_data_entity.dart';
import 'package:fatoorahapp/core/classes/entities/country_entity.dart';
import 'package:fatoorahapp/core/classes/entities/currency_entity.dart';
import 'package:fatoorahapp/core/classes/entities/pagination_entity.dart';
import 'package:fatoorahapp/core/classes/entities/product_invoices_entity.dart';
import 'package:fatoorahapp/core/classes/entities/sale_invoice_entity.dart';
import 'package:fatoorahapp/core/classes/mappers/admin_data_mapper.dart';
import 'package:fatoorahapp/core/classes/mappers/pagination_mapper.dart';
import 'package:fatoorahapp/core/classes/mappers/product_invoices_mapper.dart';
import 'package:fatoorahapp/core/classes/mappers/sale_invoice_mapper.dart';
import 'package:fatoorahapp/core/classes/mappers/tax_mapper.dart';
import 'package:fatoorahapp/core/helpful_funcations/extensions.dart';
import 'package:fatoorahapp/feature/clients/clients/data/mappers/clients_mapper.dart';
import 'package:fatoorahapp/feature/clients/clients/domain/entities/clients_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/data/models/offer_price_model.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';

extension OfferPriceMapper on OfferPriceModel? {
  OfferPriceEntity toDomain() {
    List<OfferPriceDataEntity> data =
        (this?.data?.map((e) {
          return e.toDomain();
        }))?.cast<OfferPriceDataEntity>().toList() ??
        [];
    return OfferPriceEntity(
      offerPriceDataEntity: data,
      offerPricePagination:
          this?.pagination?.toDomain() ??
          PaginationEntity(
            total: 0,
            count: 0,
            totalPages: 0,
            currentPage: 0,
            perPage: 0,
          ),
    );
  }
}

extension OfferPriceDataMapper on OfferPriceDataModel? {
  OfferPriceDataEntity toDomain() {
    List<SaleInvoicePaymentEntity> payment =
        (this?.payments!.map(
          (e) => e.toDomain(),
        ))?.cast<SaleInvoicePaymentEntity>().toList() ??
        [];
    return OfferPriceDataEntity(
      employeeDataEntity:
          this?.admin.toDomain() ??
          AdminDataEntity(
            id: 0,
            identification_number: "",
            name: "",
            uuid: "",
            phone: "",
            fire_base: "",
            ref_key: "",
            mainAdmin: "",
            packageId: "",
            email: "",
            role_id: "",
            mobile_number: "",
            system_access: "",
            type: "",
            avatar: "",
            username: "",
            password: "",
            role_job: "",
            active: "",
            status: "",
            pos_id: "",
            client_id: "",
            login_type: "",
            api_key: "",
          ),
      offerPriceDetails:
          this?.offerPriceDetails?.map((e) => e.toDomain()).toList() ?? [],
      payments: payment,
      id: this?.id.orZero() ?? 0,
      uuid: this?.uuid.orEmpty() ?? "",
      identificationNumber: this?.identificationNumber.orEmpty() ?? "",
      date: this?.date.orEmpty() ?? "",
      expirationDate: this?.expirationDate.orEmpty() ?? "",
      status: this?.status.orEmpty() ?? "",
      user:
          this?.user.toDomain() ??
          ClientsDataEntity(
            // Provide a default empty ClientsDataEntity
            companyPhone: "",
            companyMobile: "",
            companyEmail: "",
            id: 0,
            contacts: [],
            uuid: "",
            accountEntity: AccountEntity(
              type: '',
              name: '',
              id: 0,
              code: '',
              uuid: '',
              level: 0,
              title: '',
              balance: 0,
              clientId: 0,
              credit: 0,
              debit: 0,
              endAccount: '',
              isUsed: false,
              parentId: 0,
            ),
            currencyEntity: CurrencyEntity(
              id: 0,
              code: '',
              name: '',
              country: CountryEntity(
                id: 0,
                name: '',
                createdAt: '',
                code: '',
                updatedAt: '',
              ),
            ),
            email: "",
            phone: "",
            name: "",
            identificationNumber: "",
            address: "",
            notes: "",
            files: [],
            taxNumber: "",
            referenceNumber: "",
            invoicesCount: 0,
            commercialRecord: "",
            activity: "",
            canLogin: 0,
            company: "",
            area: "",
            city: "",
            country: "",
            type: "",
            invoicesDueCount: 0,
            clientsDataClassificationEntity: ClientsDataClassificationEntity(
              id: 0,
              status: 0,
              uuid: '',
              createdAt: '',
              updatedAt: '',
              name: '',
              identificationNumber: '',
            ),
            status: 0,
            isAddAccount: 0,
            lastInvoiceId: "",
            lastInvoiceUuid: "",
            image: "",
            remainingCreditLimit: 0,
            totalInvoiceValue: 0,
            clientsDataAddressesEntity: [],
            totalDueInvoicePrice: 0,
            creditLimit: 0,
            lastInvoiceDate: "",
            lastPayment: 0,
            lastPaymentDate: "",
          ),
      totalPrice: this?.totalPrice.orEmpty() ?? "",
      netPrice: this?.netPrice.orEmpty() ?? "",
      isConverted: this?.isConverted ?? false,
      createdAt: this?.createdAt.orEmpty() ?? "",
    );
  }
}

extension OfferProductMapper on OfferProductModel? {
  OfferProductEntity toDomain() {
    return OfferProductEntity(
      productUnitEntity:
          this?.productUnitModel.toDomain() ?? ProductUnitEntity(name: ""),
      highestDiscountRate: this?.highestDiscountRate.orEmpty() ?? "",
      id: this?.id.orZero() ?? 0,
      name: this?.name.orEmpty() ?? "",
      image: this?.image.orEmpty() ?? "",
      salePrice: this?.salePrice.orEmpty() ?? "",
    );
  }
}

extension OfferPriceDetailMapper on OfferPriceDetailModel? {
  OfferPriceDetailEntity toDomain() {
    return OfferPriceDetailEntity(
      discountPrice: this?.discountPrice.orEmpty() ?? "",
      reasonId: this?.reasonId.orZero() ?? 0,
      discountValue: this?.discountValue.orEmpty() ?? "",
      discountType: this?.discountType.orZero() ?? 0,
      taxes: this?.taxes?.map((e) => e.toDomain()).toList() ?? [],
      id: this?.id.orZero() ?? 0,
      quantity: this?.quantity.orEmpty() ?? "",
      price: this?.price.orEmpty() ?? "",
      totalPrice: this?.totalPrice.orEmpty() ?? "",
      product: this!.product.toDomain(),
    );
  }
}

extension CreateOfferPriceDataMapper on CreateOfferPriceDataModel? {
  CreateOfferPriceDataEntity toDomain() {
    return CreateOfferPriceDataEntity(uuid: this?.uuid.orEmpty() ?? "");
  }
}
