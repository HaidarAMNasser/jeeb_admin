import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jeeb_admin/core/infrastructure/realtime/route_history_point.dart';

/// Backend RTDB URL — must match the database your server writes to.
const String kOrderRtdbDatabaseUrl =
    'https://jeeb-f64a4-default-rtdb.europe-west1.firebasedatabase.app';

/// Listens to `/orders/{orderId}/status` and driver paths for live tracking.
class OrderStatusRtdbService {
  OrderStatusRtdbService({FirebaseDatabase? database})
      : _db = database ??
            FirebaseDatabase.instanceFor(
              app: Firebase.app(),
              databaseURL: kOrderRtdbDatabaseUrl,
            );

  final FirebaseDatabase _db;

  Stream<List<RouteHistoryPoint>> watchOrderRouteHistory(String orderId) {
    final id = orderId.trim();
    if (id.isEmpty) {
      return const Stream.empty();
    }
    return _db.ref('orders/$id/routeHistory').onValue.map((event) {
      return RouteHistoryPoint.parseList(event.snapshot.value);
    });
  }

  Stream<String?> watchOrderStatusWire(String orderId) {
    final id = orderId.trim();
    if (id.isEmpty) {
      return const Stream.empty();
    }
    return _db.ref('orders/$id/status').onValue.map((event) {
      final v = event.snapshot.value;
      if (v == null) return null;
      if (v is String) return v;
      return v.toString();
    });
  }

  Stream<int?> watchOrderDeliveryId(String orderId) {
    final id = orderId.trim();
    if (id.isEmpty) {
      return const Stream.empty();
    }
    return _db.ref('orders/$id/deliveryId').onValue.map((event) {
      final v = event.snapshot.value;
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v.trim());
      return int.tryParse(v.toString());
    });
  }

  Stream<DriverLiveLocation?> watchDriverLiveLocation(int driverId) {
    if (driverId <= 0) {
      return const Stream.empty();
    }
    return _db.ref('drivers/$driverId').onValue.map((event) {
      final v = event.snapshot.value;
      if (v is! Map) return null;
      final raw = Map<String, dynamic>.from(v);
      final lat = _asDouble(raw['currentLat']);
      final lng = _asDouble(raw['currentLng']);
      if (lat == null || lng == null) return null;
      final online = raw['isOnline'] == true;
      return DriverLiveLocation(latitude: lat, longitude: lng, isOnline: online);
    });
  }

  static double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v.trim());
    return double.tryParse(v.toString());
  }
}

class DriverLiveLocation {
  const DriverLiveLocation({
    required this.latitude,
    required this.longitude,
    required this.isOnline,
  });

  final double latitude;
  final double longitude;
  final bool isOnline;
}
