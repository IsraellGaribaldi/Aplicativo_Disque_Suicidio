import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_disque_suicidio/pages/autonomo/autonomo_page.dart';
import 'package:app_disque_suicidio/pages/clinica/clinicas_page.dart';

class MapPage extends StatefulWidget { const MapPage({super.key}); @override State<MapPage> createState() => _MapPageState(); }
class _MapPageState extends State<MapPage> {
  int _paginaAtual = 0;

  late GoogleMapController mapController;

  final LatLng _centro = const LatLng(-7.1195, -34.8450);

  final TextEditingController searchController = TextEditingController();

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
  Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: "Pesquisar local",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: 15,
            ),
          ),
        ),
      ),
    ),
  
      Expanded(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _centro,
            zoom: 13,
          ),
          markers: _marcadores,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
        ),
      ),
    ],
  ),

  ClinicaPage(),
  AutonomoPage(),
  ];

    return Scaffold(
      body: telas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(

        selectedItemColor: Color(0xFF008D97),
        unselectedItemColor: Colors.grey,
        
        currentIndex: _paginaAtual,
        onTap: (index) {
          setState(() {
            _paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            activeIcon: Icon(Icons.map_outlined),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            activeIcon: Icon(Icons.local_hospital_outlined),
            label: 'Clínicas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person_outline),
            label: 'Autônomos',
          ),
        ],
      ),
    );
  }
}