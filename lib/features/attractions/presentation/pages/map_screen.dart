// lib/features/attractions/presentation/pages/map_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:developer' as developer; // or just use debugPrint
import '../../domain/entities/attraction_entity.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';

  final List<AttractionEntity> attractions;

  // Default to empty list if none provided
  const MapScreen({Key? key, this.attractions = const []}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker> _markers = {};

  // Fallback position if no valid attractions
  static const CameraPosition _fallbackPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357), 
    zoom: 5,
  );

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    if (widget.attractions.isEmpty) {
      developer.log("MapScreen: Received empty attractions list.");
      return;
    }

    final markers = <Marker>{};

    for (final att in widget.attractions) {
      // Print lat/long to confirm correctness
      developer.log("MapScreen: [${att.name}] lat=${att.latitude}, lng=${att.longitude}");

      markers.add(
        Marker(
          markerId: MarkerId(att.id.toString()),
          position: LatLng(att.latitude, att.longitude),
          infoWindow: InfoWindow(
            title: att.name,
            snippet: att.address ?? '',
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  void _onMapCreated(GoogleMapController controller) {

    if (_markers.isEmpty) {
      // If we have no markers, fallback
      controller.moveCamera(CameraUpdate.newCameraPosition(_fallbackPosition));
      return;
    }

    if (_markers.length == 1) {
      // Single marker: Zoom in
      final marker = _markers.first;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: marker.position,
            zoom: 14, // closer zoom for single location
          ),
        ),
      );
    } else {
      // Multiple markers: Fit bounds
      final bounds = _computeBounds(_markers);
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80),
      );
    }
  }

  LatLngBounds _computeBounds(Set<Marker> markers) {
    double? minLat, maxLat, minLng, maxLng;

    for (final m in markers) {
      final lat = m.position.latitude;
      final lng = m.position.longitude;
      if (minLat == null || lat < minLat) minLat = lat;
      if (maxLat == null || lat > maxLat) maxLat = lat;
      if (minLng == null || lng < minLng) minLng = lng;
      if (maxLng == null || lng > maxLng) maxLng = lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // e.g., no back arrow
      appBar: AppBar(
        title: const Text("Map"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: GoogleMap(
        initialCameraPosition: _fallbackPosition,
        onMapCreated: _onMapCreated,
        markers: _markers,
      ),
    );
  }
}
