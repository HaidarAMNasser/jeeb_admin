import 'package:equatable/equatable.dart';
import 'package:fatoorahapp/core/classes/entities/tax_entity.dart' as cTax;
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/helpful_funcations/price_perecentage_to_value.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/feature/discount_reason/domain/entities/discount_reason_entity.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/presentation/create_offer_price_presentation/create_offer_price_bloc/create_offer_price_bloc.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/presentation/bloc/offer_to_sale_Invoice_bloc.dart'
    as map_offer;
import 'package:fatoorahapp/feature/product_indicators/domain/entities/product_entity.dart';
import 'package:fatoorahapp/feature/purchase_invoices/add_purchase_invoice/presentation/blocs/add_purchase_invoice_bloc.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchase_request_create/presentation/blocs/purchase_request_create_bloc.dart';
import 'package:fatoorahapp/feature/purchases_request_section/purchases_to_invoice/presentation/bloc/purchases_to_invoice_bloc.dart';
import 'package:fatoorahapp/feature/sales_invoices/create_sale_invoice/presentation/bloc/create_sale_invoice_bloc.dart'
    as sales;
import 'package:fatoorahapp/feature/tax_reason/domain/entities/tax_reason_entity.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final OfferPriceCreateBloc? _offerPriceCreateBloc;
  final AddPurchaseInvoiceBloc? _addPurchaseInvoiceBloc;
  final sales.CreateSaleInvoiceBloc? _createSaleInvoiceBloc;
  final PurchaseRequestCreateBloc? _purchaseRequestCreateBloc;
  final map_offer.MapOfferToInvoiceBloc? _mapOfferToInvoiceBloc;
  final MapBuyOrderToInvoiceBloc? _mapBuyOrderToInvoiceBloc;

  AddProductBloc(
    this._mapOfferToInvoiceBloc,
    this._offerPriceCreateBloc,
    this._addPurchaseInvoiceBloc,
    this._createSaleInvoiceBloc,
    this._purchaseRequestCreateBloc,
    this._mapBuyOrderToInvoiceBloc,
  ) : super(const AddProductState()) {
    on<InitializeProduct>(_onInitializeProduct);
    on<ProductSelected>(_onProductSelected);

    on<QuantityChanged>(
      (event, emit) => emit(state.copyWith(quantity: event.quantity)),
    );
    on<PriceChanged>((event, emit) => emit(state.copyWith(price: event.price)));
    on<DiscountValueChanged>(_onDiscountValueChanged);
    on<DiscountTypeSelected>(_onDiscountTypeSelected);
    on<DiscountReasonSelected>(_onDiscountReasonSelected);
    on<TaxSelected>(_onTaxSelected);
    on<TaxReasonSelected>(_onTaxReasonSelected);
    on<SubmitProduct>(_onSubmitProduct);
    on<SubmitAndReset>(_onSubmitAndReset);
    on<TaxValueChanged>(_onTaxValueChanged);
  }

  void _onInitializeProduct(
    InitializeProduct event,
    Emitter<AddProductState> emit,
  ) {
    if (event.productToEdit != null) {
      final product = event.productToEdit!;
      emit(
        AddProductState(
          highestDiscountRate: product.highestDiscountRate,
          saleProductPrice: product.salePrice,
          productToEdit: product,
          editIndex: event.editIndex,
          isEditMode: true,
          selectedProduct: product,
          quantity: product.quantity,
          taxValue: product.taxValue,
          price: product.price,
          buyPrice: product.buyPrice ?? '',

          discountValue: product.discountValue ?? '0.0',
          selectedDiscountType: product.discountType,
          selectedDiscountTypeId: product.discountTypeId,
          selectedTaxId: product.taxId,
          selectedTaxName: product.tax,
          selectedTaxKey: product.taxKey,
          selectedDiscountReason: product.disCountReason,
          selectedDiscountReasonId: product.disCountReasonId,
          selectedTaxReason: product.taxReason,
          selectedTaxReasonId: product.taxReasonId,
        ),
      );
    }
  }

  void _onProductSelected(
    ProductSelected event,
    Emitter<AddProductState> emit,
  ) {
    // Get the first tax entity if it exists
    final firstTax = event.product.tax.isNotEmpty ? event.product.tax[0] : null;

    final product = CreateProductEntity(
      highestDiscountRate: event.product.highestDiscountRate,
      salePrice: event.product.salePrice,
      buyPrice: event.product.buyPrice,
      id: event.product.id.toString(),
      name: event.product.name,
      price: event.product.salePrice,
      quantity: '',

      taxId: firstTax?.id.toString() ?? '',
      tax: firstTax?.taxName ?? '',
      taxValue: firstTax?.taxRate ?? '',
      taxKey: firstTax?.key ?? '',
      disCountReason: '',
      disCountReasonId: '',
      discountType: '',
      discountTypeId: '',
      discountValue: '',
      // Initialize tax reason from the first tax entity if it exists
      taxReason: firstTax?.taxReason?.arabicText ?? '',
      taxReasonId: firstTax?.taxReason?.id.toString() ?? '',
    );

    emit(
      state.copyWith(
        highestDiscountRate: event.product.highestDiscountRate,
        saleProductPrice: event.product.salePrice,
        selectedProduct: product,
        price: product.price,
        buyPrice: product.buyPrice,

        quantity: '',
        discountValue: '',
        taxValue: () => product.taxValue,
        selectedDiscountTypeId: () => null,
        selectedDiscountType: () => null,
        selectedDiscountReasonId: () => null,
        selectedDiscountReason: () => null,
        selectedTaxId: () => product.taxId,
        selectedTaxName: () => product.tax,
        selectedTaxKey: () => product.taxKey,
        // Initialize tax reason from the first tax entity if it exists
        selectedTaxReasonId: () =>
            product.taxReasonId.isNotEmpty ? product.taxReasonId : null,
        selectedTaxReason: () =>
            product.taxReason.isNotEmpty ? product.taxReason : null,
      ),
    );
  }

  void _onDiscountTypeSelected(
    DiscountTypeSelected event,
    Emitter<AddProductState> emit,
  ) {
    emit(
      state.copyWith(
        selectedDiscountType: () => event.discountType.title,
        selectedDiscountTypeId: () => event.discountType.id,
        selectedDiscountReason: () => null,
        selectedDiscountReasonId: () => null,
      ),
    );
  }

  void _onDiscountReasonSelected(
    DiscountReasonSelected event,
    Emitter<AddProductState> emit,
  ) {
    emit(
      state.copyWith(
        selectedDiscountReason: () => event.reason.descriptionAr,
        selectedDiscountReasonId: () => event.reason.id.toString(),
      ),
    );
  }

  void _onTaxSelected(TaxSelected event, Emitter<AddProductState> emit) {
    emit(
      state.copyWith(
        selectedTaxId: () => event.tax.id.toString(),
        selectedTaxName: () => event.tax.taxName,
        taxValue: () => event.tax.taxRate,
        selectedTaxKey: () => event.tax.key,
        selectedTaxReason: () => null,
        selectedTaxReasonId: () => null,
      ),
    );
  }

  void _onTaxReasonSelected(
    TaxReasonSelected event,
    Emitter<AddProductState> emit,
  ) {
    emit(
      state.copyWith(
        selectedTaxReason: () => event.reason.arabicText,
        selectedTaxReasonId: () => event.reason.id.toString(),
      ),
    );
  }

  void _onTaxValueChanged(
    TaxValueChanged event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(taxValue: () => event.taxValue));
  }

  CreateProductEntity _createProductEntityFromState() {
    return CreateProductEntity(
      highestDiscountRate: state.highestDiscountRate,
      salePrice: state.saleProductPrice,
      buyPrice:
          state.selectedProduct?.buyPrice ?? state.productToEdit?.buyPrice,
      disCountReason: state.selectedDiscountReason ?? '',
      disCountReasonId: state.selectedDiscountReasonId ?? '',
      taxReason: state.selectedTaxReason ?? '',
      taxReasonId: state.selectedTaxReasonId ?? '',
      discountType: state.selectedDiscountType ?? '',
      discountTypeId: state.selectedDiscountTypeId ?? '',
      discountValue: state.discountValue,
      id: state.selectedProduct!.id,
      name: state.selectedProduct!.name,
      price: state.price,
      quantity: state.quantity,
      taxId: state.selectedTaxId ?? state.productToEdit?.taxId ?? "",
      taxKey: state.selectedTaxKey ?? state.productToEdit?.taxKey ?? "",
      tax: state.selectedTaxName ?? state.productToEdit?.tax ?? "",
      taxValue: state.taxValue ?? state.productToEdit?.taxValue ?? "",
    );
  }

  void _onSubmitProduct(SubmitProduct event, Emitter<AddProductState> emit) {
    if (!state.isFormValid) return;
    if (state.isEditMode && !state.hasChanges) return;
    final detail = _createProductEntityFromState();
    if (state.isEditMode) {
      if (_addPurchaseInvoiceBloc != null) {
        _addPurchaseInvoiceBloc.add(
          EditProductInvoice(index: state.editIndex ?? 0, detail: detail),
        );
      } else if (_createSaleInvoiceBloc != null) {
        _createSaleInvoiceBloc.add(
          sales.EditProductInInvoice(
            index: state.editIndex ?? 0,
            product: detail,
          ),
        );
      } else if (_offerPriceCreateBloc != null) {
        _offerPriceCreateBloc.add(
          EditProductOffer(index: state.editIndex ?? 0, detail: detail),
        );
      } else if (_mapOfferToInvoiceBloc != null) {
        _mapOfferToInvoiceBloc.add(
          map_offer.EditProductInOfferInvoice(
            index: state.editIndex ?? 0,
            product: detail,
          ),
        );
        // --------------------
      } else if (_mapBuyOrderToInvoiceBloc != null) {
        _mapBuyOrderToInvoiceBloc.add(
          EditProductInBuyOrderInvoice(
            index: state.editIndex ?? 0,
            product: detail,
          ),
        );
        // --------------------
      } else {
        _purchaseRequestCreateBloc!.add(
          EditProductRequest(index: state.editIndex ?? 0, detail: detail),
        );
      }
    } else {
      if (_addPurchaseInvoiceBloc != null) {
        _addPurchaseInvoiceBloc.add(AddProductToInvoice(detail: detail));
      } else if (_createSaleInvoiceBloc != null) {
        _createSaleInvoiceBloc.add(sales.AddProductToInvoice(product: detail));
      } else if (_offerPriceCreateBloc != null) {
        _offerPriceCreateBloc.add(AddProductToOffer(detail: detail));
      } else if (_mapOfferToInvoiceBloc != null) {
        _mapOfferToInvoiceBloc.add(
          map_offer.AddProductToOfferInvoice(product: detail),
        );
        // --------------------
      } else if (_mapBuyOrderToInvoiceBloc != null) {
        _mapBuyOrderToInvoiceBloc.add(
          AddProductToBuyOrderInvoice(product: detail),
        );
        // --------------------
      } else {
        _purchaseRequestCreateBloc!.add(AddProductToRequest(detail: detail));
      }
    }
  }

  void _onSubmitAndReset(SubmitAndReset event, Emitter<AddProductState> emit) {
    if (!state.isFormValid) return;
    final detail = _createProductEntityFromState();
    if (_addPurchaseInvoiceBloc != null) {
      _addPurchaseInvoiceBloc.add(AddProductToInvoice(detail: detail));
    } else if (_mapOfferToInvoiceBloc != null) {
      _mapOfferToInvoiceBloc.add(
        map_offer.AddProductToOfferInvoice(product: detail),
      );
      // --------------------
    } else if (_createSaleInvoiceBloc != null) {
      _createSaleInvoiceBloc.add(sales.AddProductToInvoice(product: detail));
    } else if (_offerPriceCreateBloc != null) {
      _offerPriceCreateBloc.add(AddProductToOffer(detail: detail));
    } else {
      _purchaseRequestCreateBloc!.add(AddProductToRequest(detail: detail));
    }
    emit(const AddProductState());
  }

  void _onDiscountValueChanged(
    DiscountValueChanged event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(discountValue: event.value));
  }

  void canAddDiscount({
    required String highestDiscountRate,
    required String saleProductPrice,
    required VoidCallback onSet,
    required String? discountType,
    required TextEditingController value,
    VoidCallback? onFail,
  }) {
    print("\n=== 🛠 canAddDiscount START ===");
    print("📥 highestDiscountRate: $highestDiscountRate");
    print("📥 saleProductPrice: $saleProductPrice");
    print("📥 discountType: $discountType");
    print("📥 initial value.text: '${value.text}'");

    final text = value.text.trim();
    print("🔹 Trimmed text: '$text'");

    // Allow empty input
    if (text.isEmpty) {
      print("✅ Text is empty → calling onSet()");
      onSet();
      print("=== 🛠 canAddDiscount END ===\n");
      return;
    }

    // Allow partial decimal inputs
    if (text == "0" ||
        text == "0." ||
        text.endsWith(".") ||
        RegExp(r'^0\.0*$').hasMatch(text) ||
        RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      print("🔹 Partial/decimal input detected: '$text'");
      final parsed = num.tryParse(text);
      print("🔹 Parsed number: $parsed");

      if (parsed != null && parsed > 0) {
        print("➡️ Parsed > 0 → continue to validation...");
      } else if (text.endsWith(".") ||
          text == "0" ||
          text == "0." ||
          RegExp(r'^0\.0*$').hasMatch(text)) {
        print("✅ Still typing (ends with '.' or is zero) → calling onSet()");
        onSet();
        print("=== 🛠 canAddDiscount END ===\n");
        return;
      }
    }

    final enteredValue = num.tryParse(value.text);
    print("🔹 Final parsed enteredValue: $enteredValue");

    if (enteredValue == null || enteredValue <= 0) {
      print("❌ Invalid number or <= 0 → clearing field");
      value.clear();
      onFail?.call();
      customToast(
        msg: TranslationsController.instance.getTranslations().enterValidValue,
      );
      print("=== 🛠 canAddDiscount END ===\n");
      return;
    }

    if (discountType == null || (discountType != "1" && discountType != "2")) {
      print("❌ No valid discount type selected → clearing field");
      value.clear();
      onFail?.call();
      customToast(
        msg: TranslationsController.instance
            .getTranslations()
            .selectDiscountTypeFirst,
      );
      print("=== 🛠 canAddDiscount END ===\n");
      return;
    }

    final highestRate = num.tryParse(highestDiscountRate) ?? 0;
    final salePrice = num.tryParse(saleProductPrice) ?? 0;
    print("📊 Parsed highestRate: $highestRate");
    print("📊 Parsed salePrice: $salePrice");

    if (highestRate == 0) {
      print("🔹 Highest rate is 0 → using salePrice/percentage limits");

      if (discountType == "2" && enteredValue > 100) {
        print("❌ DiscountType=2 but enteredValue > 100% → clearing field");
        value.clear();
        onFail?.call();
        customToast(
          msg: TranslationsController.instance
              .getTranslations()
              .enterValidValue,
        );
        print("=== 🛠 canAddDiscount END ===\n");
        return;
      }

      if (discountType != "2" && enteredValue > salePrice) {
        print(
          "❌ DiscountType!=2 but enteredValue > salePrice → clearing field",
        );
        value.clear();
        onFail?.call();
        customToast(
          msg: TranslationsController.instance
              .getTranslations()
              .enterValidValue,
        );
        print("=== 🛠 canAddDiscount END ===\n");
        return;
      } else {
        print("✅ Passed validation → calling onSet()");
        onSet();
        print("=== 🛠 canAddDiscount END ===\n");
        return;
      }
    }

    if (discountType == "1") {
      print("🔹 Discount type is amount (1)");
      final maxAllowed = calculateDiscountValue(
        finalPrice: salePrice,
        discountPercent: highestRate,
      );
      print("📏 Max allowed amount: $maxAllowed");
      if (enteredValue <= maxAllowed) {
        print("✅ Entered value <= maxAllowed → calling onSet()");
        onSet();
      } else {
        print("❌ Entered value > maxAllowed → clearing field");
        value.clear();
        onFail?.call();
        customToast(
          msg: TranslationsController.instance
              .getTranslations()
              .discountExceedsMax,
        );
      }
    } else if (discountType == "2") {
      print("🔹 Discount type is percentage (2)");
      if (enteredValue <= highestRate) {
        print("✅ Entered value <= highestRate → calling onSet()");
        onSet();
      } else {
        print("❌ Entered value > highestRate → clearing field");
        value.clear();
        onFail?.call();
        customToast(
          msg: TranslationsController.instance
              .getTranslations()
              .discountExceedsMax,
        );
      }
    }

    print("=== 🛠 canAddDiscount END ===\n");
  }

  void canAddPurchaseDiscount({
    required String highestDiscountRate,
    required String saleProductPrice,
    required VoidCallback onSet,
    required String? discountType,
    required TextEditingController value,
    VoidCallback? onFail,
  }) {
    print("\n=== 🛠 canAddPurchaseDiscount START ===");
    print("📥 saleProductPrice: $saleProductPrice");
    print("📥 discountType: $discountType");
    print("📥 initial value.text: '${value.text}'");

    final text = value.text.trim();
    print("🔹 Trimmed text: '$text'");

    // Allow empty input
    if (text.isEmpty) {
      print("✅ Text is empty → calling onSet()");
      onSet();
      print("=== 🛠 canAddPurchaseDiscount END ===\n");
      return;
    }

    // Allow partial decimal inputs
    if (text == "0" ||
        text == "0." ||
        text.endsWith(".") ||
        RegExp(r'^0\.0*$').hasMatch(text) ||
        RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      print("🔹 Partial/decimal input detected: '$text'");
      final parsed = num.tryParse(text);
      print("🔹 Parsed number: $parsed");

      if (parsed != null && parsed > 0) {
        print("➡️ Parsed > 0 → continue to validation...");
      } else if (text.endsWith(".") ||
          text == "0" ||
          text == "0." ||
          RegExp(r'^0\.0*$').hasMatch(text)) {
        print("✅ Still typing (ends with '.' or is zero) → calling onSet()");
        onSet();
        print("=== 🛠 canAddPurchaseDiscount END ===\n");
        return;
      }
    }

    final enteredValue = num.tryParse(value.text);
    print("🔹 Final parsed enteredValue: $enteredValue");

    if (enteredValue == null || enteredValue <= 0) {
      print("❌ Invalid number or <= 0 → clearing field");
      value.clear();
      onFail?.call();
      customToast(
        msg: TranslationsController.instance.getTranslations().enterValidValue,
      );
      print("=== 🛠 canAddPurchaseDiscount END ===\n");
      return;
    }

    if (discountType == null || (discountType != "1" && discountType != "2")) {
      print("❌ No valid discount type selected → clearing field");
      value.clear();
      onFail?.call();
      customToast(
        msg: TranslationsController.instance
            .getTranslations()
            .selectDiscountTypeFirst,
      );
      print("=== 🛠 canAddPurchaseDiscount END ===\n");
      return;
    }

    final salePrice = num.tryParse(saleProductPrice) ?? 0;
    print("📊 Parsed salePrice: $salePrice");

    if (discountType == "1") {
      print("🔹 Discount type is amount (1)");
      if (enteredValue <= salePrice) {
        print("✅ Entered value <= salePrice → calling onSet()");
        onSet();
      } else {
        print("❌ Entered value > salePrice → clearing field");
        value.clear();
        onFail?.call();
        customToast(
          msg: TranslationsController.instance
              .getTranslations()
              .enterValidValue,
        );
      }
    } else if (discountType == "2") {
      print("🔹 Discount type is percentage (2)");
      if (enteredValue <= 100) {
        print("✅ Entered value <= 100% → calling onSet()");
        onSet();
      } else {
        print("❌ Entered value > 100% → clearing field");
        value.clear();
        onFail?.call();
        customToast(
          msg: TranslationsController.instance
              .getTranslations()
              .enterValidValue,
        );
      }
    }

    print("=== 🛠 canAddPurchaseDiscount END ===\n");
  }
}
