import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Order status values. Use this instead of raw strings.
/// Matches API: PENDING, CONFIRMED, …, DELIVERED, PAID, COMPLETE, CANCELLED, REJECTED.
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  readyForPickup,
  assigned,
  pickedUp,
  onTheWay,
  delivered,
  paid,
  complete,
  cancelled,
  rejected,
  unknown;

  /// Parse from API/string value (case-insensitive, supports snake_case).
  static OrderStatus fromString(String? value) {
    if (value == null || value.isEmpty) return OrderStatus.unknown;
    final normalized = value.toLowerCase().trim();
    switch (normalized) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready_for_pickup':
        return OrderStatus.readyForPickup;
      case 'assigned':
        return OrderStatus.assigned;
      case 'picked_up':
        return OrderStatus.pickedUp;
      case 'on_the_way':
        return OrderStatus.onTheWay;
      case 'delivered':
        return OrderStatus.delivered;
      case 'paid':
        return OrderStatus.paid;
      case 'complete':
      case 'completed':
        return OrderStatus.complete;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      case 'rejected':
        return OrderStatus.rejected;
      default:
        return OrderStatus.unknown;
    }
  }

  /// Display label for UI.
  String get displayLabel {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.readyForPickup:
        return 'Ready for pickup';
      case OrderStatus.assigned:
        return 'Assigned';
      case OrderStatus.pickedUp:
        return 'Picked up';
      case OrderStatus.onTheWay:
        return 'On the way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.paid:
        return 'order_status_paid'.tr();
      case OrderStatus.complete:
        return 'order_status_complete'.tr();
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.unknown:
        return 'Unknown';
    }
  }

  /// Color for status chip/badge.
  Color get color {
    switch (this) {
      case OrderStatus.delivered:
      case OrderStatus.complete:
        return Colors.green;
      case OrderStatus.paid:
        return Colors.deepPurple;
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return Colors.red;
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
      case OrderStatus.assigned:
        return Colors.blue;
      case OrderStatus.preparing:
      case OrderStatus.readyForPickup:
      case OrderStatus.pickedUp:
      case OrderStatus.onTheWay:
        return Colors.teal;
      case OrderStatus.unknown:
        return Colors.grey;
    }
  }

  /// Merchant: complete/cancel from pending (legacy flow).
  bool get canCompleteOrCancel => this == OrderStatus.pending;

  /// Admin: confirm payment receipts and mark PAID → COMPLETE.
  bool get canAdminConfirmPaidComplete => this == OrderStatus.paid;
}
