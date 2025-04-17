import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'dart:developer' as developer;
import '../../domain/entities/attraction_entity.dart';
import '../blocs/attractions_bloc/attractions_bloc.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';

  final List<AttractionEntity> attractions;

  /// Defaults to an empty list if none is provided.
  const MapScreen({Key? key, this.attractions = const []}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  final LatLng _fallbackCenter = LatLng(30.0444, 31.2357);
  final double _fallbackZoom = 5.0;
  double _currentZoom = 5.0;

  @override
  void initState() {
    super.initState();
    _currentZoom = _fallbackZoom;
    // Post-frame callback to ensure context is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createMarkers();
      _adjustMapView();
    });
  }

  /// Create markers from attractions.
  void _createMarkers() {
    List<AttractionEntity> attractionsToUse = widget.attractions;
    // If no attractions were passed as arguments, get them from the Bloc.
    if (attractionsToUse.isEmpty) {
      final blocState = context.read<AttractionsBloc>().state;
      attractionsToUse = blocState.attractions;
    }
    if (attractionsToUse.isEmpty) {
      developer.log("MapScreen: No attractions to display.");
      return;
    }
    final markers = attractionsToUse.map((att) {
      developer.log("MapScreen: [${att.name}] lat=${att.latitude}, lng=${att.longitude}");
      return Marker(
        point: LatLng(att.latitude, att.longitude),
        width: 80,
        height: 80,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      );
    }).toList();
    setState(() {
      _markers = markers;
    });
  }

  /// Adjust the map view depending on marker count.
  void _adjustMapView() {
    if (_markers.isEmpty) {
      _mapController.move(_fallbackCenter, _fallbackZoom);
    } else if (_markers.length == 1) {
      _mapController.move(_markers.first.point, 14.0);
    } else {
      final bounds = _computeBounds(_markers);
      if (bounds != null) {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(80),
          ),
        );
      }
    }
  }

  /// Compute bounding box for markers.
  LatLngBounds? _computeBounds(List<Marker> markers) {
    if (markers.isEmpty) return null;
    final latValues = markers.map((m) => m.point.latitude).toList();
    final lngValues = markers.map((m) => m.point.longitude).toList();
    final minLat = latValues.reduce(math.min);
    final maxLat = latValues.reduce(math.max);
    final minLng = lngValues.reduce(math.min);
    final maxLng = lngValues.reduce(math.max);
    return LatLngBounds.fromPoints([LatLng(minLat, minLng), LatLng(maxLat, maxLng)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _fallbackCenter,
              initialZoom: _fallbackZoom,
              onMapReady: _adjustMapView,
              onPositionChanged: (MapCamera position, bool hasGesture) {
                setState(() {
                  _currentZoom = position.zoom;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.mycompany.tripgo', // Replace with your package name.
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
          // Zoom Buttons Overlay.
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  onPressed: () {
                    final newZoom = _currentZoom + 1;
                    _mapController.move(_mapController.camera.center, newZoom);
                    setState(() {
                      _currentZoom = newZoom;
                    });
                  },
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  onPressed: () {
                    final newZoom = _currentZoom - 1;
                    _mapController.move(_mapController.camera.center, newZoom);
                    setState(() {
                      _currentZoom = newZoom;
                    });
                  },
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
