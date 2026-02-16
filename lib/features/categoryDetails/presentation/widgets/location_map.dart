import 'package:app_5roga/core/location/location_handler.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LocationMap extends StatefulWidget {
  final MapController controller;
  const LocationMap({super.key, required this.controller});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  List<GeoPoint> markers = [];
  String? fullAddress;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final point = GeoPoint(latitude: 30.0818165, longitude: 31.3630254);

      await Future.delayed(const Duration(seconds: 1));

      await widget.controller.addMarker(
        point,
        markerIcon: const MarkerIcon(icon: Icon(Icons.location_on, color: AppColors.primaryColor, size: 150)),
      );

      await widget.controller.moveTo(point);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OSMFlutter(
          controller: widget.controller,
          osmOption: OSMOption(
            userTrackingOption: const UserTrackingOption(enableTracking: true, unFollowUser: false),
            zoomOption: const ZoomOption(initZoom: 14, minZoomLevel: 8, maxZoomLevel: 19, stepZoom: 1.0),
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(iconWidget: Icon(Icons.location_on, color: AppColors.primaryColor, size: 150)),
              directionArrowMarker: const MarkerIcon(icon: Icon(Icons.location_on, size: 100, color: AppColors.primaryColor)),
            ),
            roadConfiguration: const RoadOption(roadColor: Colors.yellowAccent),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: AppColors.primaryColor,
            mini: true,
            onPressed: () async {
              await widget.controller.zoomIn();
            },
            child: const Icon(Icons.add, color: AppColors.wightColor),
          ),
        ),
        Positioned(
          bottom: 80,
          right: 20,
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: AppColors.primaryColor,
            mini: true,
            onPressed: () async {
              await widget.controller.zoomOut();
            },
            child: const Icon(Icons.remove, color: AppColors.wightColor),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 20,
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: AppColors.primaryColor,
            onPressed: () async {
              final position = await determinePosition();
              setState(() {
                fullAddress = position;
              });
              final parts = position.split(',');
              final lat = double.parse(parts[0]);
              final lng = double.parse(parts[1]);
              final point = GeoPoint(latitude: lat, longitude: lng);
              await widget.controller.moveTo(point, animate: true);
            },
            child: const Icon(Icons.location_on, color: AppColors.wightColor),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
