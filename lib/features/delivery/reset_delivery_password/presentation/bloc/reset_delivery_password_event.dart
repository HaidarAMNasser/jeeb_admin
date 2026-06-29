part of 'reset_delivery_password_bloc.dart';

abstract class ResetDeliveryPasswordEvent extends Equatable {
  const ResetDeliveryPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetDeliveryPasswordSubmitted extends ResetDeliveryPasswordEvent {
  final String deliveryManId;
  final String password;

  const ResetDeliveryPasswordSubmitted({
    required this.deliveryManId,
    required this.password,
  });

  @override
  List<Object?> get props => [deliveryManId, password];
}
