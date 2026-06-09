part of 'send_to_customers_bloc.dart';

abstract class SendToCustomersState extends Equatable {
  final bool isValid;

  const SendToCustomersState({this.isValid = false});

  SendToCustomersState copyWith({bool? isValid});

  @override
  List<Object?> get props => [isValid];
}

class SendToCustomersInitial extends SendToCustomersState {
  const SendToCustomersInitial({super.isValid});

  @override
  SendToCustomersState copyWith({bool? isValid}) {
    return SendToCustomersInitial(isValid: isValid ?? this.isValid);
  }
}

class SendToCustomersLoading extends SendToCustomersState {
  const SendToCustomersLoading({required super.isValid});

  @override
  SendToCustomersState copyWith({bool? isValid}) {
    return SendToCustomersLoading(isValid: isValid ?? this.isValid);
  }
}

class SendToCustomersSuccess extends SendToCustomersState {
  const SendToCustomersSuccess() : super(isValid: true);

  @override
  SendToCustomersState copyWith({bool? isValid}) {
    return const SendToCustomersInitial();
  }
}

class SendToCustomersError extends SendToCustomersState {
  final String message;

  const SendToCustomersError({
    required this.message,
    required super.isValid,
  });

  @override
  SendToCustomersState copyWith({bool? isValid}) {
    return SendToCustomersError(
      message: message,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [message, ...super.props];
}
