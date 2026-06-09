/// Converts numeric input (e.g. `20200101`) to API `YYYY-MM-DD`. Returns null if invalid.
String? normalizeBirthdayForPayload(String? raw) {
  if (raw == null) return null;
  final t = raw.trim();
  if (t.isEmpty) return null;
  String? candidate;
  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(t)) {
    candidate = t;
  } else {
    final digits = t.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) return null;
    candidate =
        '${digits.substring(0, 4)}-${digits.substring(4, 6)}-${digits.substring(6, 8)}';
  }
  final parsed = DateTime.tryParse(candidate);
  if (parsed == null) return null;
  final y = parsed.year;
  final m = parsed.month.toString().padLeft(2, '0');
  final d = parsed.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
