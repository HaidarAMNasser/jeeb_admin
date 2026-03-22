import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/offer/create_offer/domain/entities/offer_product_line.dart';
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
          final lines = o.products
              .map(
                (p) => OfferProductLine(
                  productId: p.id,
                  quantity: p.offerQuantity ?? 1,
                ),
              )
              .toList();
          final initialIds = o.products.map((p) => p.id).toList();
          emit(CreateOfferInitial(
            name: o.name ?? '',
            description: desc,
            offerProducts: lines,
            initialOfferProductIds: initialIds,
            startDate: o.startDate,
            endDate: o.endDate,
            discountType: o.discountType ?? 'PERCENTAGE',
            discountValue: o.discountValue?.toString() ?? '',
            offerId: o.id,
            isValid: _isValid(
              o.name ?? '',
              desc,
              lines,
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
      } else if (event is UpdateOfferProducts) {
        emit(state.copyWith(offerProducts: event.offerProducts));
        add(const CheckOfferValidation());
      } else if (event is UpdateOfferStartDate) {
        final start = event.value;
        final end = state.endDate;
        final clearEnd = start != null && end != null && start.isAfter(end);
        emit(state.copyWith(
          startDate: start,
          endDate: clearEnd ? null : end,
        ));
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
            state.offerProducts,
            state.discountType,
            state.discountValue,
          ),
        ));
      } else if (event is CreateOfferSubmitted) {
        if (!state.isValid) return;
        emit(CreateOfferLoading(
          name: state.name,
          description: state.description,
          offerProducts: state.offerProducts,
          initialOfferProductIds: state.initialOfferProductIds,
          startDate: state.startDate,
          endDate: state.endDate,
          discountType: state.discountType,
          discountValue: state.discountValue,
          offerId: state.offerId,
          isValid: state.isValid,
        ));
        final discountType =
            state.discountType == 'VALUE' ? 'FIXED' : state.discountType;
        final discountValue = num.tryParse(state.discountValue) ?? 0;
        final productsPayload = state.offerProducts
            .map((line) {
              final id = int.tryParse(line.productId);
              if (id == null) return null;
              return <String, dynamic>{
                'productId': id,
                'quantity': line.quantity,
              };
            })
            .whereType<Map<String, dynamic>>()
            .toList();
        final body = <String, dynamic>{
          'name': state.name.trim(),
          'description': state.description.trim(),
          'discountType': discountType,
          'discountValue': discountValue,
          'products': productsPayload,
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
            offerProducts: state.offerProducts,
            initialOfferProductIds: state.initialOfferProductIds,
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
    List<OfferProductLine> lines,
    String type,
    String value,
  ) {
    if (name.trim().isEmpty) return false;
    if (description.trim().isEmpty) return false;
    if (lines.isEmpty) return false;
    for (final line in lines) {
      if (line.quantity < 1) return false;
    }
    final v = num.tryParse(value);
    if (v == null || v < 0) return false;
    if (type == 'PERCENTAGE' && v > 100) return false;
    return true;
  }
}
