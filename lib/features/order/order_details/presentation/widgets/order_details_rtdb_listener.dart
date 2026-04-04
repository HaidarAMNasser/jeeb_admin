import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jeeb_admin/core/infrastructure/realtime/order_status_rtdb_service.dart';

/// Refreshes order details when RTDB status changes (skips initial snapshot).
class OrderDetailsRtdbListener extends StatefulWidget {
  const OrderDetailsRtdbListener({
    super.key,
    required this.orderId,
    required this.rtdb,
    required this.onRemoteStatusChange,
  });

  final String orderId;
  final OrderStatusRtdbService rtdb;
  final VoidCallback onRemoteStatusChange;

  @override
  State<OrderDetailsRtdbListener> createState() =>
      _OrderDetailsRtdbListenerState();
}

class _OrderDetailsRtdbListenerState extends State<OrderDetailsRtdbListener> {
  StreamSubscription<String?>? _sub;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _attach();
  }

  @override
  void didUpdateWidget(covariant OrderDetailsRtdbListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orderId != widget.orderId) {
      _sub?.cancel();
      _attach();
    }
  }

  void _attach() {
    var first = true;
    _sub = widget.rtdb.watchOrderStatusWire(widget.orderId).listen((_) {
      if (first) {
        first = false;
        return;
      }
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        if (mounted) widget.onRemoteStatusChange();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
