import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/offer/list_offer/domain/entities/offer_entity.dart';
import 'package:jeeb_admin/features/offer/create_offer/data/repositories/create_offer_repository.dart';

part 'create_offer_event.dart';
part 'create_offer_state.dart';

class CreateOfferBloc extends Bloc<CreateOfferEvent, CreateOfferState> {
  final CreateOfferRepository _repository;

  CreateOfferBloc(this._repository) : super(const CreateOfferInitial()) {
    on<CreateOfferEvent>((event, emit) async {
      if (event is InitializeOfferForm) {
        if (event.offer != null) {
          final o = event.offer!;
          emit(CreateOfferInitial(
            shortDescription: o.shortDescription ?? '',
            longDescription: o.longDescription ?? '',
            productIds: o.products.map((p) => p.id).toList(),
            startDate: o.startDate,
            endDate: o.endDate,
            discountType: o.discountType ?? 'PERCENTAGE',
            discountValue: o.discountValue?.toString() ?? '',
            offerId: o.id,
            isValid: _isValid(
              o.shortDescription ?? '',
              o.longDescription ?? '',
              o.products.map((p) => p.id).toList(),
              o.discountType ?? 'PERCENTAGE',
              o.discountValue?.toString() ?? '',
            ),
          ));
        } else {
          emit(const CreateOfferInitial());
        }
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferShortDescription) {
        emit(state.copyWith(shortDescription: event.value));
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferLongDescription) {
        emit(state.copyWith(longDescription: event.value));
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferProductIds) {
        emit(state.copyWith(productIds: event.productIds));
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferStartDate) {
        emit(state.copyWith(startDate: event.value));
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferEndDate) {
        emit(state.copyWith(endDate: event.value));
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferDiscountType) {
        emit(state.copyWith(discountType: event.value));
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferDiscountValue) {
        emit(state.copyWith(discountValue: event.value));
        add(const CheckOfferValidation());
      } else if (event is CheckOfferValidation) {
        emit(state.copyWith(
          isValid: _isValid(
            state.shortDescription,
            state.longDescription,
            state.productIds,
            state.discountType,
            state.discountValue,
          ),
        ));
      } else if (event is CreateOfferSubmitted) {
        if (!state.isValid) return;
        emit(CreateOfferLoading(
          shortDescription: state.shortDescription,
          longDescription: state.longDescription,
          productIds: state.productIds,
          startDate: state.startDate,
          endDate: state.endDate,
          discountType: state.discountType,
          discountValue: state.discountValue,
          offerId: state.offerId,
          isValid: state.isValid,
        ));
        final formData = FormData.fromMap({
          'shortDescription': state.shortDescription,
          'longDescription': state.longDescription,
          if (state.startDate != null)
            'startDate': state.startDate!.toIso8601String(),
          if (state.endDate != null)
            'endDate': state.endDate!.toIso8601String(),
          'discountType': state.discountType,
          'discountValue': num.tryParse(state.discountValue) ?? 0,
        });
        for (final id in state.productIds) {
          formData.fields.add(MapEntry('productIds', id));
        }
        final result = await _repository.createOffer(formData);
        result.fold(
          (failure) => emit(CreateOfferError(
            message: failure.message,
            shortDescription: state.shortDescription,
            longDescription: state.longDescription,
            productIds: state.productIds,
            startDate: state.startDate,
            endDate: state.endDate,
            discountType: state.discountType,
            discountValue: state.discountValue,
            offerId: state.offerId,
            isValid: state.isValid,
          )),
          (_) => emit(const CreateOfferSuccess()),
        );
      }
    });
  }

  bool _isValid(
    String shortDesc,
    String longDesc,
    List<String> ids,
    String type,
    String value,
  ) {
    if (shortDesc.trim().isEmpty) return false;
    if (ids.isEmpty) return false;
    final v = num.tryParse(value);
    if (v == null || v < 0) return false;
    if (type == 'PERCENTAGE' && v > 100) return false;
    return true;
  }
}
