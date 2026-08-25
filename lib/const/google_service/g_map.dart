import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constant/image_manager.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});
  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}
class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final LatLng _initialLocation = const LatLng(21.7394, 72.0046);
  final LatLng _destinationLocation = const LatLng(21.7588, 72.1447);

  BitmapDescriptor _customMarkerIcon = BitmapDescriptor.defaultMarker;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadCustomMarkerIcon();
  }

  Future<void> _loadCustomMarkerIcon() async {
    final BitmapDescriptor icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      AppImages.mrk,
    );
    setState(() {
      _customMarkerIcon = icon;
    });
  }

  Future<void> _checkLocationPermission() async {
    /// Request location permission from the device
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: _permissionGranted,
        myLocationButtonEnabled: _permissionGranted,
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 13.0,
        ),
        // FEATURE 3: Polylines (Drawing Routes)
        polylines: {
          Polyline(
            polylineId: const PolylineId('route_path_1'), // Unique identifier key for the line
            color: Colors.blue,
            width: 7,
            points: [
              _initialLocation,
              _destinationLocation,
            ],
          ),
        },
        markers: {
          Marker(
              markerId: const MarkerId('khodiyar_mandir'),
              position: _initialLocation,
              icon: _customMarkerIcon,

              infoWindow: InfoWindow(
                  title: 'This Is Memoize Temple',
                  snippet: "This is main khodiyar mata mandir in the Bhavnagar Ciry."
              )
          ),

          Marker(
              markerId: const MarkerId('hyvikk_solution'),
              position: _destinationLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),

              infoWindow: InfoWindow(
                  title: 'Hyvikk Solutions',
                  snippet: "this is an IT company, provide a services and application developments."
              )
          ),
        },
      ),
    );
  }
}
