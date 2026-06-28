import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/infrastructure/realtime/order_status_rtdb_service.dart';

/// Subscribes to RTDB `/orders/{id}/status` for each [orderId]. On any change
/// (after the initial snapshot per id), invokes [onOrderStatusChanged] with the
/// changed order id and its new status, so the list can be updated in place
/// instead of refetching everything.
class MerchantOrderListRtdbListener extends StatefulWidget {
  const MerchantOrderListRtdbListener({
    super.key,
    required this.orderIds,
    required this.rtdb,
    required this.onOrderStatusChanged,
  });

  final List<String> orderIds;
  final OrderStatusRtdbService rtdb;
  final void Function(String orderId, String? status) onOrderStatusChanged;

  @override
  State<MerchantOrderListRtdbListener> createState() =>
      _MerchantOrderListRtdbListenerState();
}

class _MerchantOrderListRtdbListenerState
    extends State<MerchantOrderListRtdbListener> {
  final Map<String, StreamSubscription<String?>> _subscriptions = {};

  @override
  void initState() {
    super.initState();
    _syncSubscriptions(widget.orderIds);
  }

  @override
  void didUpdateWidget(covariant MerchantOrderListRtdbListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.orderIds, widget.orderIds)) {
      _syncSubscriptions(widget.orderIds);
    }
  }

  void _syncSubscriptions(List<String> ids) {
    final want = ids.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

    for (final key in _subscriptions.keys.toList()) {
      if (!want.contains(key)) {
        _subscriptions.remove(key)?.cancel();
      }
    }

    for (final id in want) {
      if (_subscriptions.containsKey(id)) continue;
      var first = true;
      _subscriptions[id] = widget.rtdb.watchOrderStatusWire(id).listen((status) {
        // Skip the initial snapshot: it just reflects the value already loaded.
        if (first) {
          first = false;
          return;
        }
        if (!mounted) return;
        widget.onOrderStatusChanged(id, status);
      });
    }
  }

  @override
  void dispose() {
    for (final s in _subscriptions.values) {
      s.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
