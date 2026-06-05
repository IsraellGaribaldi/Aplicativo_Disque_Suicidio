import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_disque_suicidio/pages/autonomo/autonomo_page.dart';
import 'package:app_disque_suicidio/pages/clinica/clinicas_page.dart';

class MapPage extends StatefulWidget { const MapPage({super.key}); @override State<MapPage> createState() => _MapPageState(); }
class _MapPageState extends State<MapPage> {
  int _paginaAtual = 0;

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
    final telas = [
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _centro,
          zoom: 13,
        ),
        markers: _marcadores,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
      ),
      ClinicaPage(),
      AutonomoPage(),
    ];

    return Scaffold(
      body: telas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: (index) {
          setState(() {
            _paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Clínicas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Autônomos',
          ),
        ],
      ),
    );
  }
}