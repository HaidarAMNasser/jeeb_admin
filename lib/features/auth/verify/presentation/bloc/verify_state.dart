part of 'verify_bloc.dart';

abstract class VerifyState extends Equatable {
  const VerifyState();

  @override
  List<Object?> get props => [];
}

class VerifyInitial extends VerifyState {
  const VerifyInitial();
}

class VerifyLoading extends VerifyState {
  const VerifyLoading();
}

/// Shown after verify 200 while performing background login (modal progress).
class VerifyLoggingIn extends VerifyState {
  const VerifyLoggingIn();
}

class VerifySuccess extends VerifyState {
  final bool goToMain;

  const VerifySuccess({this.goToMain = true});

  @override
  List<Object?> get props => [goToMain];
}

class VerifyOtpResent extends VerifyState {
  const VerifyOtpResent();
}

class VerifyError extends VerifyState {
  final String message;

  const VerifyError({required this.message});

  @override
  List<Object> get props => [message];
}

