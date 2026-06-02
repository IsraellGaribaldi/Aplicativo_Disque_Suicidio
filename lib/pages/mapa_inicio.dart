import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late GoogleMapController mapController;

  final LatLng _centro = const LatLng(-7.1195, -34.8450);

  final Set<Marker> _marcadores = {
    const Marker(
      markerId: MarkerId('unipe'),
      position: LatLng(-7.1489, -34.8466),
      infoWindow: InfoWindow(
        title: 'UNIPÊ',
        snippet: 'Centro Universitário',
      ),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Flutter'),
      ),

      body: GoogleMap(
        onMapCreated: _onMapCreated,

        initialCameraPosition: CameraPosition(
          target: _centro,
          zoom: 13,
        ),

        markers: _marcadores,

        myLocationEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
