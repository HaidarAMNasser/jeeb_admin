import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/infrastructure/realtime/order_status_rtdb_service.dart';

/// Subscribes to RTDB `/orders/{id}/status` for each [orderId]. On any change
/// (after the initial snapshot per id), invokes [onRemoteStatusChange] debounced.
class MerchantOrderListRtdbListener extends StatefulWidget {
  const MerchantOrderListRtdbListener({
    super.key,
    required this.orderIds,
    required this.rtdb,
    required this.onRemoteStatusChange,
  });

  final List<String> orderIds;
  final OrderStatusRtdbService rtdb;
  final VoidCallback onRemoteStatusChange;

  @override
  State<MerchantOrderListRtdbListener> createState() =>
      _MerchantOrderListRtdbListenerState();
}

class _MerchantOrderListRtdbListenerState
    extends State<MerchantOrderListRtdbListener> {
  final Map<String, StreamSubscription<String?>> _subscriptions = {};
  Timer? _debounce;

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
      _subscriptions[id] = widget.rtdb.watchOrderStatusWire(id).listen((_) {
        if (first) {
          first = false;
          return;
        }
        _scheduleRefresh();
      });
    }
  }

  void _scheduleRefresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      widget.onRemoteStatusChange();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final s in _subscriptions.values) {
      s.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
