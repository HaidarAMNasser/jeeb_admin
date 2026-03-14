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
          final desc = (o.shortDescription ?? o.longDescription ?? '').trim().isNotEmpty
              ? (o.shortDescription ?? o.longDescription ?? '')
              : '';
          emit(CreateOfferInitial(
            name: o.name ?? '',
            description: desc,
            productIds: o.products.map((p) => p.id).toList(),
            startDate: o.startDate,
            endDate: o.endDate,
            discountType: o.discountType ?? 'PERCENTAGE',
            discountValue: o.discountValue?.toString() ?? '',
            offerId: o.id,
            isValid: _isValid(
              o.name ?? '',
              desc,
              o.products.map((p) => p.id).toList(),
              o.discountType ?? 'PERCENTAGE',
              o.discountValue?.toString() ?? '',
            ),
          ));
        } else {
          emit(const CreateOfferInitial());
        }
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferName) {
        emit(state.copyWith(name: event.value));
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferDescription) {
        emit(state.copyWith(description: event.value));
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
            state.name,
            state.description,
            state.productIds,
            state.discountType,
            state.discountValue,
          ),
        ));
      } else if (event is CreateOfferSubmitted) {
        if (!state.isValid) return;
        emit(CreateOfferLoading(
          name: state.name,
          description: state.description,
          productIds: state.productIds,
          startDate: state.startDate,
          endDate: state.endDate,
          discountType: state.discountType,
          discountValue: state.discountValue,
          offerId: state.offerId,
          isValid: state.isValid,
        ));
        // Backend expects application/json with a single object (not FormData)
        final discountType = state.discountType == 'VALUE' ? 'FIXED' : state.discountType;
        final discountValue = num.tryParse(state.discountValue) ?? 0;
        final productIdsNumbers = state.productIds
            .map((id) => int.tryParse(id))
            .whereType<int>()
            .toList();
        final body = <String, dynamic>{
          'name': state.name.trim(),
          'description': state.description.trim(),
          'discountType': discountType,
          'discountValue': discountValue,
          'productIds': productIdsNumbers,
          'isActive': true,
        };
        if (state.startDate != null) {
          body['startDate'] = state.startDate!.toIso8601String();
        }
        if (state.endDate != null) {
          body['endDate'] = state.endDate!.toIso8601String();
        }
        final result = await _repository.createOffer(body);
        result.fold(
          (failure) => emit(CreateOfferError(
            message: failure.message,
            name: state.name,
            description: state.description,
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
    String name,
    String description,
    List<String> ids,
    String type,
    String value,
  ) {
    if (name.trim().isEmpty) return false;
    if (description.trim().isEmpty) return false;
    if (ids.isEmpty) return false;
    final v = num.tryParse(value);
    if (v == null || v < 0) return false;
    if (type == 'PERCENTAGE' && v > 100) return false;
    return true;
  }
}
