import 'package:flutter/services.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';

/// Copies trimmed [text] to the system clipboard and shows a confirmation toast.
/// Does nothing if [text] is null or empty after trimming.
void copyTextToClipboard(String? text) {
  final t = text?.trim() ?? '';
  if (t.isEmpty) return;
  Clipboard.setData(ClipboardData(text: t));
  customToast(msg: '"$t" ${AppTranslation.copiedToClipboard}');
}
