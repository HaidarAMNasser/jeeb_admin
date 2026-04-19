import 'package:equatable/equatable.dart';
import 'package:jeeb_admin/core/config/app_config.dart';

/// Payment receipt image attached to a PAID order (admin review before COMPLETE).
class OrderPaymentReceiptEntity extends Equatable {
  final int id;
  final int imageId;
  final String relativePath;

  const OrderPaymentReceiptEntity({
    required this.id,
    required this.imageId,
    required this.relativePath,
  });

  String get fullImageUrl {
    if (relativePath.isEmpty) return '';
    if (relativePath.startsWith('http')) return relativePath;
    return '${AppConfig.assetsBaseUrl}uploads/$relativePath';
  }

  @override
  List<Object?> get props => [id, imageId, relativePath];
}
