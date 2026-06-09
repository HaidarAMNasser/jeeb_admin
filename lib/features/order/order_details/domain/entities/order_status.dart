import 'package:flutter/material.dart';

/// Order status values. Matches API / RTDB wire values (e.g. PENDING, ON_THE_WAY).
enum OrderStatus {
  pending,
  confirmed,
  searching,
  preparing,
  readyForPickup,
  assigned,
  pickedUp,
  onTheWay,
  delivered,
  /// Delivery paid admin fee; awaiting admin confirmation (wire: PAID).
  paid,
  /// Admin confirmed payment receipt (wire: COMPLETED).
  completed,
  cancelled,
  rejected,
  unknown;

  /// Backend wire value (uppercase).
  String get apiWireValue {
    switch (this) {
      case OrderStatus.pending:
        return 'PENDING';
      case OrderStatus.confirmed:
        return 'CONFIRMED';
      case OrderStatus.searching:
        return 'SEARCHING';
      case OrderStatus.preparing:
        return 'PREPARING';
      case OrderStatus.readyForPickup:
        return 'READY_FOR_PICKUP';
      case OrderStatus.assigned:
        return 'ASSIGNED';
      case OrderStatus.pickedUp:
        return 'PICKED_UP';
      case OrderStatus.onTheWay:
        return 'ON_THE_WAY';
      case OrderStatus.delivered:
        return 'DELIVERED';
      case OrderStatus.paid:
        return 'PAID';
      case OrderStatus.completed:
        return 'COMPLETED';
      case OrderStatus.cancelled:
        return 'CANCELLED';
      case OrderStatus.rejected:
        return 'REJECTED';
      case OrderStatus.unknown:
        return 'PENDING';
    }
  }

  /// Parse from API / RTDB string (case-insensitive).
  static OrderStatus fromString(String? value) {
    if (value == null || value.isEmpty) return OrderStatus.unknown;
    final normalized = value.toLowerCase().trim();
    switch (normalized) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'searching':
        return OrderStatus.searching;
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
      case 'completed':
      case 'complete':
        return OrderStatus.completed;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      case 'rejected':
        return OrderStatus.rejected;
      default:
        return OrderStatus.unknown;
    }
  }

  String get displayLabel {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.searching:
        return 'Searching';
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
        return 'Paid';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.unknown:
        return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.completed:
        return const Color.fromARGB(255, 2, 185, 97);
      case OrderStatus.paid:
        return Colors.deepOrange;
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return Colors.red;
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
      case OrderStatus.assigned:
        return Colors.blue;
      case OrderStatus.searching:
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

/// Icons for tracking / timeline UI.
extension OrderStatusPresentation on OrderStatus {
  IconData get iconData {
    switch (this) {
      case OrderStatus.pending:
        return Icons.schedule_rounded;
      case OrderStatus.confirmed:
        return Icons.verified_outlined;
      case OrderStatus.searching:
        return Icons.search_rounded;
      case OrderStatus.preparing:
        return Icons.restaurant_rounded;
      case OrderStatus.readyForPickup:
        return Icons.takeout_dining_rounded;
      case OrderStatus.assigned:
        return Icons.two_wheeler_rounded;
      case OrderStatus.pickedUp:
        return Icons.inventory_2_outlined;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining_rounded;
      case OrderStatus.delivered:
        return Icons.home_outlined;
      case OrderStatus.paid:
        return Icons.payments_outlined;
      case OrderStatus.completed:
        return Icons.check_circle_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
      case OrderStatus.rejected:
        return Icons.block_rounded;
      case OrderStatus.unknown:
        return Icons.help_outline_rounded;
    }
  }
}
