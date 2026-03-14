part of 'create_offer_bloc.dart';

abstract class CreateOfferEvent extends Equatable {
  const CreateOfferEvent();

  @override
  List<Object?> get props => [];
}

class InitializeOfferForm extends CreateOfferEvent {
  final OfferEntity? offer;

  const InitializeOfferForm({this.offer});

  @override
  List<Object?> get props => [offer];
}

class UpdateOfferName extends CreateOfferEvent {
  final String value;

  const UpdateOfferName(this.value);

  @override
  List<Object> get props => [value];
}

class UpdateOfferDescription extends CreateOfferEvent {
  final String value;

  const UpdateOfferDescription(this.value);

  @override
  List<Object> get props => [value];
}

class UpdateOfferProductIds extends CreateOfferEvent {
  final List<String> productIds;

  const UpdateOfferProductIds(this.productIds);

  @override
  List<Object> get props => [productIds];
}

class UpdateOfferStartDate extends CreateOfferEvent {
  final DateTime? value;

  const UpdateOfferStartDate(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateOfferEndDate extends CreateOfferEvent {
  final DateTime? value;

  const UpdateOfferEndDate(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateOfferDiscountType extends CreateOfferEvent {
  final String value;

  const UpdateOfferDiscountType(this.value);

  @override
  List<Object> get props => [value];
}

class UpdateOfferDiscountValue extends CreateOfferEvent {
  final String value;

  const UpdateOfferDiscountValue(this.value);

  @override
  List<Object> get props => [value];
}

class CreateOfferSubmitted extends CreateOfferEvent {
  const CreateOfferSubmitted();
}

class CheckOfferValidation extends CreateOfferEvent {
  const CheckOfferValidation();
}
