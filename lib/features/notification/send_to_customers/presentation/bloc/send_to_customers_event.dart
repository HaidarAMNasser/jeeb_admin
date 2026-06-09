part of 'send_to_customers_bloc.dart';

abstract class SendToCustomersEvent extends Equatable {
  const SendToCustomersEvent();

  @override
  List<Object?> get props => [];
}

class UpdateNotificationTitle extends SendToCustomersEvent {
  final String title;

  const UpdateNotificationTitle({required this.title});

  @override
  List<Object> get props => [title];
}

class UpdateNotificationBody extends SendToCustomersEvent {
  final String body;

  const UpdateNotificationBody({required this.body});

  @override
  List<Object> get props => [body];
}

class CheckSendNotificationValidation extends SendToCustomersEvent {
  const CheckSendNotificationValidation();
}

class SendToCustomersSubmitted extends SendToCustomersEvent {
  const SendToCustomersSubmitted();
}

class ResetSendNotificationForm extends SendToCustomersEvent {
  const ResetSendNotificationForm();
}
