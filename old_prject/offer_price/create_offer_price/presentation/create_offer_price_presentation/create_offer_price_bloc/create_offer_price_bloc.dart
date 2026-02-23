import 'package:equatable/equatable.dart';
import 'package:fatoorahapp/core/constances/local_data.dart';
import 'package:fatoorahapp/core/localization/language.dart';
import 'package:fatoorahapp/core/services/errors_handler.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/data/repositories/create_offer_price_repositories.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/helpful_functions/check_payment_differences.dart';
import 'package:fatoorahapp/feature/offer_price/create_offer_price/helpful_functions/is_form_valid.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price/domain/offer_price_entity.dart';
import 'package:fatoorahapp/feature/offer_price/offer_price_details.dart/domain/offer_price_single_entity.dart';
import 'package:fatoorahapp/feature/return_invoice_section/create_return_invoice/data/helpful_function.dart/calculate_summary.dart';
import 'package:fatoorahapp/feature/sales_invoices/invoice_model.dart';
import 'package:fatoorahapp/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_offer_price_event.dart';
part 'create_offer_price_state.dart';

class OfferPriceCreateBloc
    extends Bloc<OfferPriceCreateEvent, CreateOfferPriceState> {
  final OfferPriceCreateRepository _offerPriceCreateRepository;
  double _totalProductsPrice = 0;
  String selectedClient = "";
  String selectedAdmin = "";
  String selectedWorkplace = "";
  List<PaymentMethodEntryOffer> initialPayments = [];

  double get totalProductsPrice => _totalProductsPrice;
  TextEditingController referenceNumberController = TextEditingController();
  final createOfferPriceKey = GlobalKey<FormState>();

  OfferPriceCreateBloc(this._offerPriceCreateRepository)
    : super(
        const CreateOfferPriceInitial(
          details: [],
          payments: [],
          isValid: false,
          hasChanges: false,
        ),
      ) {
    on<OfferPriceCreateEvent>((event, emit) async {
      if (event is OfferPriceCreateSubmitted) {
        final currentDetails = getProducts();
        final currentPayments = getPayments();

        emit(
          CreateOfferPriceLoading(
            totalAmount: state.totalAmount,
            totalDiscount: state.totalDiscount,
            taxableAmount: state.taxableAmount,
            taxAmount: state.taxAmount,
            finalAmount: state.finalAmount,
            isValid: state.isValid,
            details: currentDetails,
            payments: currentPayments,
          ),
        );

        try {
          final result = await _offerPriceCreateRepository.createOfferPrice(
            referenceNumber: event.referenceNumber,
            userId: event.userId,
            supplyDate: event.supplyDate,
            serviceEndDate: event.serviceEndDate,
            workPalceId: event.workPalceId,
            expirationDate: event.expirationDate,
            employeeId: event.employeeId,
            payments: currentPayments,
            date: event.date,
            status: event.status,
            details: currentDetails,
          );

          result.fold(
            (l) => emit(
              CreateOfferPriceError(
                isValid: state.isValid,
                message: l.prettyMessage ?? l.message,
                details: currentDetails,
                payments: currentPayments,
              ),
            ),
            (r) => emit(CreateOfferPriceSuccess(createOfferPriceDataEntity: r)),
          );
        } catch (e) {
          emit(
            CreateOfferPriceError(
              isValid: state.isValid,
              message: ResponseMessage.defaultError,
              details: currentDetails,
              payments: currentPayments,
            ),
          );
        }
      } else if (event is ResetToInit) {
        // Recalculate summary from the provided product list
        final summary = calculateSummary(event.details);

        // Update the BLoC's internal properties to match the preserved state
        this.selectedClient = event.userId.toString();
        this.selectedWorkplace = event.workPalceId.toString();
        this.selectedAdmin = event.employeeId.toString();
        this.referenceNumberController.text = event.referenceNumber;
        this.initialPayments = List<PaymentMethodEntryOffer>.from(
          event.payments,
        );

        // Emit a new `CreateOfferPriceInitial` state. This moves the
        // BLoC out of the error state while preserving all data.
        emit(
          CreateOfferPriceInitial(
            details: event.details,
            payments: event.payments,
            hasChanges: true,
            isValid: false, // Will be recalculated by the event below
            // Use the recalculated summary values
            totalAmount: summary.totalAmount,
            totalDiscount: summary.totalDiscount,
            taxableAmount: summary.taxableAmount,
            taxAmount: summary.taxAmount,
            finalAmount: summary.finalAmount,
          ),
        );

        // Trigger a re-validation of the restored form state
        add(const CheckValidationEvent());
      } else if (event is LoadInitData) {
        this.selectedAdmin = event.adminId;
        this.selectedClient = event.clientId;

        this.selectedWorkplace = event.workPalceId.toString();
        this.initialPayments = event.payments;
        _emitStateWithUpdatedDetails(event.details, emit);
        _emitWithUpdatedPayments(event.payments, emit);
        add(const CheckValidationEvent());
      } else if (event is AddProductToOffer) {
        final updatedDetails = List<CreateProductEntity>.from(getProducts())
          ..add(event.detail);
        _emitStateWithUpdatedDetails(updatedDetails, emit);
        _totalProductsPrice = 0.0;
        _totalProductsPrice = getProducts().fold<double>(
          0.0,
          (sum, item) =>
              sum +
              ((double.tryParse(item.price) ?? 0.0) *
                  (num.tryParse(item.quantity.toString()) ?? 1)),
        );
        _emitStateWithHasChanges(true, emit);
        add(CheckValidationEvent());
      } else if (event is DeleteProductFromOffer) {
        final updatedDetails = List<CreateProductEntity>.from(getProducts());
        if (event.index >= 0 && event.index < updatedDetails.length) {
          updatedDetails.removeAt(event.index);
        }

        _emitStateWithUpdatedDetails(updatedDetails, emit);
        _emitStateWithHasChanges(true, emit);
        add(CheckValidationEvent());
      } else if (event is EditProductOffer) {
        final updatedDetails = List<CreateProductEntity>.from(getProducts());
        if (event.index >= 0 && event.index < updatedDetails.length) {
          updatedDetails[event.index] = event.detail;
        }
        _emitStateWithUpdatedDetails(updatedDetails, emit);
        _emitStateWithHasChanges(true, emit);

        add(CheckValidationEvent());
      } else if (event is AddPaymentToOffer) {
        final updatedPayments = List<PaymentMethodEntryOffer>.from(
          getPayments(),
        )..add(event.payment);

        _emitWithUpdatedPayments(updatedPayments, emit);
        if (checkPaymentDifferences(this.initialPayments, this.getPayments())) {
          _emitStateWithHasChanges(true, emit);
        }
        add(CheckValidationEvent());
      } else if (event is DeletePaymentFromOffer) {
        final updatedPayments = List<PaymentMethodEntryOffer>.from(
          getPayments(),
        );
        if (event.index >= 0 && event.index < updatedPayments.length) {
          updatedPayments.removeAt(event.index);
        }

        _emitWithUpdatedPayments(updatedPayments, emit);
        _emitStateWithHasChanges(true, emit);
        add(CheckValidationEvent());
      } else if (event is EditPaymentInOffer) {
        final proposedPayments = List<PaymentMethodEntryOffer>.from(
          getPayments(),
        );
        if (event.index >= 0 && event.index < proposedPayments.length) {
          proposedPayments[event.index] = event.payment;
        }
        // if (paymentIds.length != paymentIds.toSet().length) {
        //   customToast(
        //       msg: TranslationsController.instance
        //           .getTranslations()
        //           .duplicatePaymentMethod);
        //   final invalidPaymentAttempt = event.payment;
        //   proposedPayments[event.index] = PaymentMethodEntryOffer(
        //     id: "",
        //     bankId: null,
        //     bankName: null,
        //     dueDate: null,
        //     paymentType: "",
        //     amount: invalidPaymentAttempt.amount,
        //   );
        //   add(CheckValidationEvent());
        //   return;
        // }

        num sum = 0;
        for (var p in proposedPayments) {
          if (p.amount != null && p.amount!.text.isNotEmpty) {
            sum += num.tryParse(p.amount!.text) ?? 0;
          }
        }

        // Round both to 2 decimal places for exact comparison
        final sumRounded = double.parse(sum.toStringAsFixed(2));
        final totalRounded = double.parse(state.finalAmount.toStringAsFixed(2));
        if (sumRounded > totalRounded) {
          customToast(
            msg: TranslationsController.instance
                .getTranslations()
                .paymentGreaterThanInvoice,
          );

          final faultyPayment = proposedPayments[event.index];
          proposedPayments[event.index] = PaymentMethodEntryOffer(
            id: faultyPayment.id,
            bankId: faultyPayment.bankId,
            bankName: faultyPayment.bankName,
            paymentMethodName: faultyPayment.paymentMethodName,
            dueDate: faultyPayment.dueDate,
            paymentType: faultyPayment.paymentType,
            type: faultyPayment.type,
            parentId: faultyPayment.parentId,
            amount: TextEditingController(text: ""),
            guaranteePercent:
                faultyPayment.guaranteePercent, // Preserve percentage
          );
        }
        _emitWithUpdatedPayments(proposedPayments, emit);
        print(
          checkPaymentDifferences(this.initialPayments, this.getPayments()),
        );
        _emitWithUpdatedPayments(proposedPayments, emit);
        if (checkPaymentDifferences(this.initialPayments, this.getPayments())) {
          _emitStateWithHasChanges(true, emit);
        } else {
          _emitStateWithHasChanges(false, emit);
        }
        add(CheckValidationEvent());
      } else if (event is CheckForChangesInEditMode) {
        final hasChanged = _hasChangesOccurred(event.initialData);
        _emitStateWithHasChanges(hasChanged, emit);
      } else if (event is CheckValidationEvent) {
        bool isValid = isFormValid(
          selectedClient,
          selectedAdmin,
          this.getProducts(),
          this.getPayments(),
          this.state.finalAmount,
          selectedWorkplace,
        );
        _emitStateWithUpdatedValidate(isValid, emit);
      } else if (event is RecalculateAndAdjustPayments) {
        if (getPayments().isEmpty) return;

        final newTotal = state.finalAmount;

        final updatedPayments = List<PaymentMethodEntryOffer>.from(
          getPayments(),
        );

        if (updatedPayments.isNotEmpty) {
          // First, recalculate all guarantee payments based on their saved percentages
          final paymentsWithRecalculatedGuarantees =
              _recalculateGuaranteePayments(updatedPayments, newTotal);

          // If the first payment is not a guarantee payment with a saved percentage,
          // set it to the total (original behavior)
          if (paymentsWithRecalculatedGuarantees.isNotEmpty) {
            final firstPayment = paymentsWithRecalculatedGuarantees[0];
            if (!(firstPayment.effectivePaymentMethodId == '8' &&
                firstPayment.guaranteePercent != null)) {
              paymentsWithRecalculatedGuarantees[0] = PaymentMethodEntryOffer(
                paymentType: firstPayment.paymentType,
                id: firstPayment.id,
                type: firstPayment.type,
                parentId: firstPayment.parentId,
                bankId: firstPayment.bankId,
                dueDate: firstPayment.dueDate,
                bankName: firstPayment.bankName,
                note: firstPayment.note,
                guaranteePercent: firstPayment.guaranteePercent,
                amount: TextEditingController(
                  text: newTotal.toStringAsFixed(2),
                ),
              );
            }

            // Set other non-guarantee payments to 0 (original behavior)
            for (
              int i = 1;
              i < paymentsWithRecalculatedGuarantees.length;
              i++
            ) {
              final otherPayment = paymentsWithRecalculatedGuarantees[i];
              if (!(otherPayment.effectivePaymentMethodId == '8' &&
                  otherPayment.guaranteePercent != null)) {
                paymentsWithRecalculatedGuarantees[i] = PaymentMethodEntryOffer(
                  paymentType: otherPayment.paymentType,
                  id: otherPayment.id,
                  type: otherPayment.type,
                  parentId: otherPayment.parentId,
                  bankId: otherPayment.bankId,
                  dueDate: otherPayment.dueDate,
                  bankName: otherPayment.bankName,
                  note: otherPayment.note,
                  guaranteePercent: otherPayment.guaranteePercent,
                  amount: TextEditingController(text: "0"),
                );
              }
            }
          }

          _emitWithUpdatedPayments(paymentsWithRecalculatedGuarantees, emit);
        } else {
          _emitWithUpdatedPayments(updatedPayments, emit);
        }

        add(const CheckValidationEvent());
      } else if (event is ChangeHasChanges) {
        _emitStateWithHasChanges(event.hasChanges, emit);
      }
    });
  }

  void _emitWithUpdatedPayments(
    List<PaymentMethodEntryOffer> payments,
    Emitter<CreateOfferPriceState> emit,
  ) {
    final summary = calculateSummary(getProducts());
    final currentState = state;
    if (currentState is CreateOfferPriceInitial) {
      emit(
        currentState.copyWith(
          payments: payments,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
        ),
      );
    } else if (currentState is CreateOfferPriceError) {
      emit(
        currentState.copyWith(
          payments: payments,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
        ),
      );
    } else if (currentState is CreateOfferPriceLoading) {
      emit(
        currentState.copyWith(
          payments: payments,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
        ),
      );
    }
  }

  void _emitStateWithUpdatedDetails(
    List<CreateProductEntity> details,
    Emitter<CreateOfferPriceState> emit,
  ) {
    final summary = calculateSummary(details);

    // Recalculate guarantee payment amounts based on stored percentages
    final updatedPayments = List<PaymentMethodEntryOffer>.from(state.payments);
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

    if (state is CreateOfferPriceInitial) {
      emit(
        (state as CreateOfferPriceInitial).copyWith(
          details: details,
          payments: updatedPayments,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
        ),
      );
    } else if (state is CreateOfferPriceError) {
      emit(
        (state as CreateOfferPriceError).copyWith(
          details: details,
          payments: updatedPayments,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
        ),
      );
    } else if (state is CreateOfferPriceLoading) {
      emit(
        (state as CreateOfferPriceLoading).copyWith(
          details: details,
          payments: updatedPayments,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
        ),
      );
    }
  }

  void _emitStateWithUpdatedValidate(
    bool isValid,
    Emitter<CreateOfferPriceState> emit,
  ) {
    final summary = calculateSummary(getProducts());
    if (state is CreateOfferPriceInitial) {
      emit(
        (state as CreateOfferPriceInitial).copyWith(
          isValid: isValid,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
        ),
      );
    } else if (state is CreateOfferPriceError) {
      emit(
        (state as CreateOfferPriceError).copyWith(
          isValid: isValid,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
        ),
      );
    } else if (state is CreateOfferPriceLoading) {
      emit(
        (state as CreateOfferPriceLoading).copyWith(
          isValid: isValid,
          totalAmount: summary.totalAmount,
          totalDiscount: summary.totalDiscount,
          taxableAmount: summary.taxableAmount,
          taxAmount: summary.taxAmount,
          finalAmount: summary.finalAmount,
        ),
      );
    }
  }

  List<CreateProductEntity> getProducts() {
    return state.details;
  }

  List<PaymentMethodEntryOffer> getPayments() {
    return state.payments;
  }

  bool _hasChangesOccurred(OfferPriceSingleEntity offerprice) {
    if (offerprice.clientId != this.selectedClient) {
      return true;
    }
    return false;
  }

  void _emitStateWithHasChanges(
    bool hasChanges,
    Emitter<CreateOfferPriceState> emit,
  ) {
    final currentState = state;
    if (currentState is CreateOfferPriceInitial) {
      emit((state as CreateOfferPriceInitial).copyWith(hasChanges: hasChanges));
    } else if (state is CreateOfferPriceError) {
      emit((state as CreateOfferPriceError).copyWith(hasChanges: hasChanges));
    } else if (state is CreateOfferPriceLoading) {
      emit((state as CreateOfferPriceLoading).copyWith(hasChanges: hasChanges));
    }
  }

  /// Recalculates guarantee payment amounts based on stored percentages when total changes
  List<PaymentMethodEntryOffer> _recalculateGuaranteePayments(
    List<PaymentMethodEntryOffer> payments,
    num newFinalAmount,
  ) {
    final updatedPayments = <PaymentMethodEntryOffer>[];

    for (final payment in payments) {
      if (payment.effectivePaymentMethodId == '8' &&
          payment.guaranteePercent != null) {
        // This is a guarantee payment with a saved percentage
        final percent = num.tryParse(payment.guaranteePercent!) ?? 0;
        final newAmount = (newFinalAmount * percent / 100).toStringAsFixed(2);

        updatedPayments.add(
          payment.copyWith(amount: TextEditingController(text: newAmount)),
        );
      } else {
        updatedPayments.add(payment);
      }
    }

    return updatedPayments;
  }
}
