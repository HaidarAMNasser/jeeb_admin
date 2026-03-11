part of 'verify_bloc.dart';

abstract class VerifyEvent extends Equatable {
  const VerifyEvent();

  @override
  List<Object?> get props => [];
}

class VerifySubmitted extends VerifyEvent {
  final String email;
  final String otp;
  /// Optional password: when provided, a login request is made after verify 200 to establish session.
  final String? password;

  const VerifySubmitted({
    required this.email,
    required this.otp,
    this.password,
  });

  @override
  List<Object?> get props => [email, otp, password];
}

class ResendOtpSubmitted extends VerifyEvent {
  final String email;

  const ResendOtpSubmitted({required this.email});

  @override
  List<Object> get props => [email];
}

