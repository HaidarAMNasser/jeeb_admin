import 'package:fatoorahapp/core/classes/entities/account_entity.dart';
import 'package:fatoorahapp/core/classes/entities/city_entity.dart';
import 'package:fatoorahapp/core/classes/entities/country_entity.dart';
import 'package:fatoorahapp/core/classes/entities/currency_entity.dart';
import 'package:fatoorahapp/core/classes/entities/region_entity.dart';
import 'package:fatoorahapp/core/classes/entities/workplace_entity.dart';
import 'package:fatoorahapp/core/classes/mappers/workplace_mapper.dart';
import 'package:fatoorahapp/core/helpful_funcations/extensions.dart';
import 'package:fatoorahapp/feature/clients/clients/data/mappers/clients_mapper.dart';
import 'package:fatoorahapp/feature/clients/clients/domain/entities/clients_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/mapper/offer_price_mapper.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/data/models/offer_price_single_model.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/payment_method/data/mappers/payment_methods_mapper.dart';
import 'package:fatoorahapp/feature/payment_method/domain/entities/payment_methods_entity.dart';

extension OfferPriceSingleMapper on OfferPriceSingleModel? {
  OfferPriceSingleEntity toDomain() {
    return OfferPriceSingleEntity(
      isConverted: this?.isConverted.orFalse() ?? false,
      serviceEndDate: this?.serviceEndDate.orEmpty() ?? "",
      workplaceEntity:
          this?.workplace.toDomain() ??
          WorkplaceEntity(
            phone: "",
            admins: [],
            mobile: "",
            streetName: "",
            commercialName: "",
            area: "",
            buildingNumber: "",
            postalNumber: "",
            additionalNumber: "",
            adress: "",
            commercialRecord: "",
            name: "",
            status: 0,
            id: 0,
            cityEntity: CityEntity(
              id: 0,
              name: "",
              region: RegionEntity(
                name: "",
                id: 0,
                code: "",
                country: CountryEntity(
                  code: "",
                  id: 0,
                  name: "",
                  createdAt: "",
                  updatedAt: "",
                ),
                updatedAt: "",
                createdAt: "",
              ),
              country: CountryEntity(
                createdAt: "",
                updatedAt: "",
                name: "",
                id: 0,
                code: "",
              ),
              latitude: "",
              longitude: "",
            ),
            updatedAt: "",
            createdAt: "",
            identificationNumber: "",
            level: 0,
            uuid: "",
            countryEntity: CountryEntity(
              createdAt: "",
              updatedAt: "",
              code: "",
              id: 0,
              name: "",
            ),
            regionEntity: RegionEntity(
              name: "",
              id: 0,
              code: "",
              updatedAt: "",
              createdAt: "",
              country: CountryEntity(
                createdAt: "",
                updatedAt: "",
                code: "",
                id: 0,
                name: "",
              ),
            ),
          ),
      id: this?.id.orZero() ?? 0,
      uuid: this?.uuid.orEmpty() ?? "",
      identificationNumber: this?.identificationNumber.orEmpty() ?? "",
      referenceNumber: this?.referenceNumber.orEmpty() ?? "",
      date: this?.date.orEmpty() ?? "",
      expirationDate: this?.expirationDate.orEmpty() ?? "",
      user:
          this?.user.toDomain() ??
          ClientsDataEntity(
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
      admin: this?.admin.orEmpty() ?? "",
      employee: this?.employee.orEmpty() ?? "",
      clientId: this?.clientId.orZero() ?? 0,
      status: this?.status.orEmpty() ?? "",
      additionalNotes: this?.additionalNotes.orEmpty() ?? "",
      totalPrice: this?.totalPrice.orEmpty() ?? "",
      discountPrice: this?.discountPrice.orEmpty() ?? "",
      itemsDiscountPrice: this?.itemsDiscountPrice.orEmpty() ?? "",
      netPrice: this?.netPrice.orEmpty() ?? "",
      invoiceDiscountType: this?.invoiceDiscountType.orZero() ?? 0,
      invoiceDiscountValue: this?.invoiceDiscountValue.orZero() ?? 0,
      offerPriceDetails:
          this?.offerPriceDetails?.map((e) => e.toDomain()).toList() ?? [],
      // payments: this?.payments?.map((e) => e.toDomain()).toList() ?? [],
      payments:
          this?.payments?.map((payment) => payment.toDomain()).toList() ?? [],

      taxPrice: this?.taxPrice.orZero() ?? 0,
      totalTaxAmounts:
          this?.totalTaxAmounts?.map((e) => e.toDomain()).toList() ?? [],
      files: this?.files ?? [],
      policies: this?.policies ?? [],
      supplyDate: this?.supplyDate.orEmpty() ?? "",
    );
  }
}

extension TotalTaxAmountMapper on TotalTaxAmountModel? {
  TotalTaxAmountEntity toDomain() {
    return TotalTaxAmountEntity(
      taxId: this?.taxId.orZero() ?? 0,
      name: this?.name.orEmpty() ?? "",
      parentName: this?.parentName.orEmpty() ?? "",
      taxName: this?.taxName.orEmpty() ?? "",
      taxRate: this?.taxRate.orZero() ?? 0,
      totalAmount: this?.totalAmount.orZero() ?? 0,
    );
  }
}

extension OfferPricePaymentMapper on OfferPricePaymentModel? {
  OfferPricePaymentEntity toDomain() {
    // Use paymentMethod if available (newer API), otherwise fall back to method (older API)
    final paymentMethodData = this?.paymentMethod ?? this?.method;
    return OfferPricePaymentEntity(
      treasuryId: this?.treasuryId.orZero() ?? 0,
      date: this?.date.orEmpty() ?? "",
      bankId: this?.bankId.orZero() ?? 0,
      bankName: this?.bankName.orEmpty() ?? "",
      id: this?.id.orZero() ?? 0,
      value: this?.value.orEmpty() ?? "",
      methodId: this?.methodId.orZero() ?? 0,
      method:
          paymentMethodData?.toDomain() ??
          PaymentMethodsDataEntity(id: 0, name: "----", active: 0),
      guaranteePercent: this?.guaranteePercent?.orEmpty(),
      notes: this?.notes?.orEmpty(),
    );
  }
}
