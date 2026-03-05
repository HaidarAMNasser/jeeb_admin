part of 'confirm_product_bloc.dart';

abstract class ConfirmProductState extends Equatable {
  const ConfirmProductState();

  @override
  List<Object?> get props => [];
}

class ConfirmProductInitial extends ConfirmProductState {
  const ConfirmProductInitial();
}

class ConfirmProductLoading extends ConfirmProductState {
  const ConfirmProductLoading();
}

class ConfirmProductSuccess extends ConfirmProductState {
  const ConfirmProductSuccess();
}

class ConfirmProductError extends ConfirmProductState {
  final String message;

  const ConfirmProductError({required this.message});

  @override
  List<Object> get props => [message];
}

