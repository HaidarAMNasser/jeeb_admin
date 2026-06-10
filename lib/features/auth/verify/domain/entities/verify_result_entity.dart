class VerifyResultEntity {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? data;

  const VerifyResultEntity({
    required this.statusCode,
    required this.message,
    this.data,
  });

  bool? get isActive {
    final value = data?['isActive'];
    if (value is bool) return value;
    return null;
  }

  bool get isPendingApproval => statusCode == 202 || isActive == false;
}
