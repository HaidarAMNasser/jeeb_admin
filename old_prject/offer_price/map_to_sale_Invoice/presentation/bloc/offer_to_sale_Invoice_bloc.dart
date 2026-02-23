import 'package:equatable/equatable.dart';
import 'package:fatoorahapp/core/classes/entities/sale_invoice_entity.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/services/errors_handler.dart';
import 'package:fatoorahapp/feature/offer_price/map_to_sale_Invoice/data/repository/offer_to_sale_Invoice_repository.dart';
import 'package:fatoorahapp/feature/return_invoice_section/create_return_invoice/data/helpful_function.dart/calculate_summary.dart';
import 'package:fatoorahapp/feature/return_invoice_section/create_return_invoice/data/helpful_function.dart/is_return_form_valid.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'offer_to_sale_Invoice_event.dart';
part 'offer_to_sale_Invoice_state.dart';

class MapOfferToInvoiceBloc
    extends Bloc<MapOfferToInvoiceEvent, MapOfferToInvoiceState> {
  final MapOfferToInvoiceRepository _mapOfferToInvoiceRepository;

  List<CreateProductEntity> originalProducts = [];

  MapOfferToInvoiceBloc(this._mapOfferToInvoiceRepository)
    : super(const MapOfferToInvoiceInitialState()) {
    // Event Handlers
    on<MapOfferToInvoiceSubmitted>(_onMapOfferToInvoiceSubmitted);
    on<LoadOfferToInvoiceInitData>(_onLoadInitData);
    on<RecalculateOfferInvoice>(_onRecalculate);
    on<RecalculateAndAdjustPaymentsOfferInvoice>(
      _onRecalculateAndAdjustPayments,
    );
    on<AddPaymentToOfferInvoice>(_onAddPayment);
    on<EditPaymentInOfferInvoice>(_onEditPayment);
    on<DeletePaymentFromOfferInvoice>(_onDeletePayment);
    on<AddProductToOfferInvoice>(_onAddProduct);
    on<DeleteProductFromOfferInvoice>(_onDeleteProduct);
    on<EditProductInOfferInvoice>(_onEditProduct);
    on<UpdateOfferInvoiceFields>(_onUpdateFields);
  }

  Future<void> _onMapOfferToInvoiceSubmitted(
    MapOfferToInvoiceSubmitted event,
    Emitter<MapOfferToInvoiceState> emit,
  ) async {
    final currentState = state;
    emit(
      MapOfferToInvoiceLoadingState(
        details: currentState.details,
        payments: currentState.payments,
        totalAmount: currentState.totalAmount,
        totalDiscount: currentState.totalDiscount,
        taxableAmount: currentState.taxableAmount,
        taxAmount: currentState.taxAmount,
        finalAmount: currentState.finalAmount,
        isValid: currentState.isValid,
        referenceNumber: currentState.referenceNumber,
        supplyDate: currentState.supplyDate,
        serviceEndDate: currentState.serviceEndDate,
        dueDate: currentState.dueDate,
        stockId: currentState.stockId,
        employeeId: currentState.employeeId,
      ),
    );
    try {
      final result = await _mapOfferToInvoiceRepository.mapOfferToInvoice(
        uuid: event.uuid,
      );

      result.fold(
        (l) => emit(
          MapOfferToInvoiceErrorState(
            employeeId: currentState.employeeId,
            message: l.prettyMessage ?? l.message,
            details: currentState.details,
            payments: currentState.payments,
            totalAmount: currentState.totalAmount,
            totalDiscount: currentState.totalDiscount,
            taxableAmount: currentState.taxableAmount,
            taxAmount: currentState.taxAmount,
            finalAmount: currentState.finalAmount,
            isValid: currentState.isValid,
            referenceNumber: currentState.referenceNumber,
            supplyDate: currentState.supplyDate,
            serviceEndDate: currentState.serviceEndDate,
            dueDate: currentState.dueDate,
            stockId: currentState.stockId,
          ),
        ),
        (r) {
          print("aaaaa");
          for (var i in r.payments) {
            print(i.value);
          }
          print("aaaaa");
          emit(
            MapOfferToInvoiceSuccessState(
              saleInvoiceEntity: r,
              details: const [],
              payments: const [],
              totalAmount: 0,
              totalDiscount: 0,
              taxableAmount: 0,
              taxAmount: 0,
              finalAmount: 0,
              isValid: true,
              referenceNumber: currentState.referenceNumber,
              supplyDate: currentState.supplyDate,
              serviceEndDate: currentState.serviceEndDate,
              dueDate: currentState.dueDate,
              stockId: currentState.stockId,
              employeeId: currentState.employeeId,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        MapOfferToInvoiceErrorState(
          employeeId: currentState.employeeId,
          message: ResponseMessage.defaultError,
          details: currentState.details,
          payments: currentState.payments,
          totalAmount: currentState.totalAmount,
          totalDiscount: currentState.totalDiscount,
          taxableAmount: currentState.taxableAmount,
          taxAmount: currentState.taxAmount,
          finalAmount: currentState.finalAmount,
          isValid: currentState.isValid,
          referenceNumber: currentState.referenceNumber,
          supplyDate: currentState.supplyDate,
          serviceEndDate: currentState.serviceEndDate,
          dueDate: currentState.dueDate,
          stockId: currentState.stockId,
        ),
      );
    }
  }

  void _onLoadInitData(
    LoadOfferToInvoiceInitData event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    originalProducts = List<CreateProductEntity>.from(event.details);
    int? parsedStockId;
    if (event.stockId != null && event.stockId!.isNotEmpty) {
      parsedStockId = int.tryParse(event.stockId!);
    }
    int? parsedEmployeeId;
    if (event.employeeId != null && event.employeeId!.isNotEmpty) {
      parsedEmployeeId = int.tryParse(event.employeeId!);
    }
    _emitNewStateWith(
      details: event.details,
      payments: event.payments,
      referenceNumber: event.referenceNumber,
      supplyDate: event.supplyDate,
      serviceEndDate: event.serviceEndDate,
      stockId: parsedStockId,
      employeeId: parsedEmployeeId,
      emit: emit,
    );
  }

  void _onUpdateFields(
    UpdateOfferInvoiceFields event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    _emitNewStateWith(
      referenceNumber: event.referenceNumber,
      supplyDate: event.supplyDate,
      serviceEndDate: event.serviceEndDate,
      dueDate: event.dueDate,
      stockId: event.stockId != null && event.stockId!.isNotEmpty
          ? int.tryParse(event.stockId!) ?? 0
          : null,
      employeeId: event.employeeId != null && event.employeeId!.isNotEmpty
          ? int.tryParse(event.employeeId!) ?? 0
          : null,
      emit: emit,
    );
  }

  void _onRecalculate(
    RecalculateOfferInvoice event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    _emitNewStateWith(emit: emit);
  }

  // --- PAYMENT HANDLERS ---
  void _onAddPayment(
    AddPaymentToOfferInvoice event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    final updatedPayments = List<PaymentMethodEntryOffer>.from(state.payments)
      ..add(event.payment);
    _emitNewStateWith(payments: updatedPayments, emit: emit);
  }

  void _onEditPayment(
    EditPaymentInOfferInvoice event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    final updatedPayments = List<PaymentMethodEntryOffer>.from(state.payments);
    if (event.index >= 0 && event.index < updatedPayments.length) {
      updatedPayments[event.index] = event.payment;
      _emitNewStateWith(payments: updatedPayments, emit: emit);
    }
  }

  void _onDeletePayment(
    DeletePaymentFromOfferInvoice event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    final updatedPayments = List<PaymentMethodEntryOffer>.from(state.payments);
    if (event.index >= 0 && event.index < updatedPayments.length) {
      updatedPayments.removeAt(event.index);
      _emitNewStateWith(payments: updatedPayments, emit: emit);
    }
  }

  // --- PRODUCT HANDLERS ---
  void _onAddProduct(
    AddProductToOfferInvoice event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    final updatedDetails = List<CreateProductEntity>.from(state.details)
      ..add(event.product);
    // Don't adjust payments - only update products and let guarantee auto-recalculate
    _emitNewStateWith(details: updatedDetails, emit: emit);
  }

  void _onDeleteProduct(
    DeleteProductFromOfferInvoice event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    final updatedDetails = List<CreateProductEntity>.from(state.details);

    if (event.index < 0 || event.index >= updatedDetails.length) return;

    updatedDetails.removeAt(event.index);

    // Don't adjust payments - only update products and let guarantee auto-recalculate
    _emitNewStateWith(details: updatedDetails, emit: emit);
  }

  void _onEditProduct(
    EditProductInOfferInvoice event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    final updatedDetails = List<CreateProductEntity>.from(state.details);
    if (event.index < 0 || event.index >= updatedDetails.length) return;

    updatedDetails[event.index] = event.product;

    // Don't adjust payments - only update products and let guarantee auto-recalculate
    _emitNewStateWith(details: updatedDetails, emit: emit);
  }

  // --- RECALCULATE AND ADJUST PAYMENTS HANDLER ---
  void _onRecalculateAndAdjustPayments(
    RecalculateAndAdjustPaymentsOfferInvoice event,
    Emitter<MapOfferToInvoiceState> emit,
  ) {
    // Just recalculate totals, don't adjust payments
    // Guarantee payments will auto-adjust based on their percentage
    _emitNewStateWith(emit: emit);
  }

  // --- CENTRAL STATE EMITTER ---
  void _emitNewStateWith({
    List<CreateProductEntity>? details,
    List<PaymentMethodEntryOffer>? payments,
    String? referenceNumber,
    String? supplyDate,
    String? serviceEndDate,
    String? dueDate,
    int? stockId,
    int? employeeId,
    required Emitter<MapOfferToInvoiceState> emit,
  }) {
    final currentState = state;
    final currentDetails = details ?? currentState.details;
    var currentPayments = payments ?? currentState.payments;
    final currentReferenceNumber =
        referenceNumber ?? currentState.referenceNumber;
    final currentSupplyDate = supplyDate ?? currentState.supplyDate;
    final currentServiceEndDate = serviceEndDate ?? currentState.serviceEndDate;
    final currentDueDate = dueDate ?? currentState.dueDate;
    final currentStockId = stockId ?? currentState.stockId;
    final currentEmployeeId = employeeId ?? currentState.employeeId;

    final summary = calculateSummary(currentDetails);

    // Recalculate guarantee payment amounts based on stored percentages (only if details changed)
    if (details != null) {
      final updatedPayments = List<PaymentMethodEntryOffer>.from(
        currentPayments,
      );
      for (int i = 0; i < updatedPayments.length; i++) {
        final payment = updatedPayments[i];
        // Check if this is a guarantee payment with a stored percentage
        if (payment.effectivePaymentMethodId == '8' &&
            payment.guaranteePercent != null) {
          final percentValue = double.tryParse(payment.guaranteePercent!);
          if (percentValue != null && percentValue > 0) {
            // Recalculate amount based on new total
            final newAmount = (summary.finalAmount * percentValue / 100)
                .toStringAsFixed(2);
            updatedPayments[i] = payment.copyWith(
              amount: TextEditingController(text: newAmount),
            );
          }
        }
      }
      currentPayments = updatedPayments;
    }

    final bool isValid = isReturnFormValid(
      products: currentDetails,
      payments: currentPayments,
      productsTotal: summary.finalAmount,
    );

    if (currentState is MapOfferToInvoiceSuccessState) {
      emit(
        currentState.copyWith(
          details: currentDetails,
          payments: currentPayments,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
          isValid: isValid,
          referenceNumber: currentReferenceNumber,
          supplyDate: currentSupplyDate,
          serviceEndDate: currentServiceEndDate,
          dueDate: currentDueDate,
          stockId: currentStockId,
          employeeId: currentEmployeeId,
        ),
      );
    } else if (currentState is MapOfferToInvoiceErrorState) {
      emit(
        currentState.copyWith(
          details: currentDetails,
          payments: currentPayments,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
          isValid: isValid,
          referenceNumber: currentReferenceNumber,
          supplyDate: currentSupplyDate,
          serviceEndDate: currentServiceEndDate,
          dueDate: currentDueDate,
          stockId: currentStockId,
          employeeId: currentEmployeeId,
        ),
      );
    } else if (currentState is MapOfferToInvoiceInitialState) {
      emit(
        currentState.copyWith(
          details: currentDetails,
          payments: currentPayments,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
          isValid: isValid,
          referenceNumber: currentReferenceNumber,
          supplyDate: currentSupplyDate,
          serviceEndDate: currentServiceEndDate,
          dueDate: currentDueDate,
          stockId: currentStockId,
          employeeId: currentEmployeeId,
        ),
      );
    }
  }
}
