part of 'delivery_details_bloc.dart';

abstract class DeliveryDetailsState extends Equatable {
  const DeliveryDetailsState();

  @override
  List<Object?> get props => [];
}

class DeliveryDetailsInitial extends DeliveryDetailsState {
  const DeliveryDetailsInitial();
}

class DeliveryDetailsLoading extends DeliveryDetailsState {
  const DeliveryDetailsLoading();
}

class DeliveryDetailsLoaded extends DeliveryDetailsState {
  final DeliveryManEntity deliveryMan;

  const DeliveryDetailsLoaded({required this.deliveryMan});

  @override
  List<Object?> get props => [deliveryMan];
}

class DeliveryDetailsError extends DeliveryDetailsState {
  final String message;

  const DeliveryDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
