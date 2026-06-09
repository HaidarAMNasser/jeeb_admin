import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jeeb_admin/core/infrastructure/realtime/route_history_point.dart';

abstract final class RouteHistoryPolylineBuilder {
  RouteHistoryPolylineBuilder._();

  static List<LatLng> toLatLngs(List<RouteHistoryPoint> points) =>
      points.map((e) => LatLng(e.lat, e.lng)).toList();

  static Set<Polyline> walkedPath({
    required String orderId,
    required List<LatLng> points,
    int width = 6,
  }) {
    if (points.length < 2) return {};
    return {
      Polyline(
        polylineId: PolylineId('walked_$orderId'),
        points: points,
        color: const Color(0xFFD32F2F).withValues(alpha: 0.92),
        width: width,
        zIndex: 3,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }
}
