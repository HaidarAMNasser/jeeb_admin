import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jeeb_admin/core/common/utils/constants.dart';
import 'package:jeeb_admin/core/common/utils/location_permission_helper.dart';
import 'package:jeeb_admin/core/common/utils/toast_util.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_app_bar.dart';
import 'package:jeeb_admin/core/presentation/widgets/custom_button.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';

/// Default center when no initial location (see [AppConstants.defaultMapLatitude]).
const LatLng _kDefaultCenter = LatLng(
  AppConstants.defaultMapLatitude,
  AppConstants.defaultMapLongitude,
);

/// Picked coordinates from [GoogleMapLocationPickerPage].
class GoogleMapLocationPickResult {
  const GoogleMapLocationPickResult({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;
}

/// Full-screen Google Map: tap to place marker, confirm to return lat/lng.
/// Uses the same Maps SDK / API key as [LiveTrackingMapCard].
class GoogleMapLocationPickerPage extends StatefulWidget {
  const GoogleMapLocationPickerPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<GoogleMapLocationPickerPage> createState() =>
      _GoogleMapLocationPickerPageState();
}

class _GoogleMapLocationPickerPageState
    extends State<GoogleMapLocationPickerPage> {
  GoogleMapController? _controller;
  late LatLng _selected;
  bool _loadingMyLocation = false;
  static const double _zoom = 14;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selected = LatLng(widget.initialLatitude!, widget.initialLongitude!);
    } else {
      _selected = _kDefaultCenter;
    }
  }

  Set<Marker> get _markers => {
        Marker(
          markerId: const MarkerId('picked'),
          position: _selected,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      };

  Future<void> _goToMyLocation() async {
    setState(() => _loadingMyLocation = true);
    final position = await LocationPermissionHelper.requestAndGetPosition();
    if (!mounted) return;
    setState(() => _loadingMyLocation = false);
    if (position != null) {
      final point = LatLng(position.latitude, position.longitude);
      setState(() => _selected = point);
      await _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(point, _zoom),
      );
    } else if (mounted) {
      customToast(msg: AppTranslation.locationPermissionDenied);
    }
  }

  void _onMapTap(LatLng position) {
    setState(() => _selected = position);
  }

  void _onConfirm() {
    Navigator.of(context).pop(
      GoogleMapLocationPickResult(
        latitude: _selected.latitude,
        longitude: _selected.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(
        title: AppTranslation.chooseLocationOnMap,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selected,
                zoom: _zoom,
              ),
              markers: _markers,
              onTap: _onMapTap,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              onMapCreated: (c) => _controller = c,
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppPadding.p24),
            color: ColorManager.background,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                    text:
                        '${AppTranslation.latitude}: ${_selected.latitude.toStringAsFixed(5)}\n${AppTranslation.longitude}: ${_selected.longitude.toStringAsFixed(5)}',
                    textStyle: getRegularStyle(
                      fontSize: AppFontSize.s14,
                      color: ColorManager.textColor,
                    ),
                  ),
                  SizedBox(height: AppHeight.s16),
                  CustomButton(
                    text: AppTranslation.useMyLocation,
                    onPressed: _goToMyLocation,
                    isLoading: _loadingMyLocation,
                    color: ColorManager.primary,
                    isOutlined: true,
                  ),
                  SizedBox(height: AppHeight.s12),
                  CustomButton(
                    text: AppTranslation.confirm,
                    onPressed: _onConfirm,
                    color: ColorManager.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
