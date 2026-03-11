import 'package:flutter/material.dart';

/// Holds all [TextEditingController]s for the delivery form. Call [dispose] when done.
class DeliveryFormControllers {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController phone;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController address;
  final TextEditingController birthday;

  DeliveryFormControllers()
      : firstName = TextEditingController(),
        lastName = TextEditingController(),
        phone = TextEditingController(),
        email = TextEditingController(),
        password = TextEditingController(),
        address = TextEditingController(),
        birthday = TextEditingController();

  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    address.dispose();
    birthday.dispose();
  }

  /// Pre-fill from existing delivery (edit mode).
  void fillFrom({
    required String name,
    required String phone,
    required String email,
  }) {
    final parts = name.split(' ');
    firstName.text = parts.isNotEmpty ? parts.first : '';
    lastName.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    this.phone.text = phone;
    this.email.text = email;
  }
}
