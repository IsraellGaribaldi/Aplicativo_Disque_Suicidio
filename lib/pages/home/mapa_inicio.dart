import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_disque_suicidio/banco/clinica_dao.dart';
import 'package:app_disque_suicidio/banco/autonomo_dao.dart';
import 'package:app_disque_suicidio/pages/autonomo/autonomo_page.dart';
import 'package:app_disque_suicidio/pages/clinica/clinicas_page.dart';
import 'package:app_disque_suicidio/models/clinicas.dart';
import 'package:app_disque_suicidio/models/autonomos.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _paginaAtual = 0;
  late GoogleMapController mapController;
  final LatLng _centro = const LatLng(-7.1195, -34.8450);
  Set<Marker> _marcadores = {};

<<<<<<< HEAD
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
=======
  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
  }

  Future<void> _carregarMarcadores() async {
    final clinicas = await ClinicaDao().buscarClinicas();
    final autonomos = await AutonomoDao().buscarAutonomos();

    final Set<Marker> marcadores = {};

    for (final Clinica c in clinicas) {
      marcadores.add(Marker(
        markerId: MarkerId('clinica_${c.id}'),
        position: LatLng(c.lat, c.long),
        infoWindow: InfoWindow(
          title: c.nome,
          snippet: 'Clínica',
        ),
      ));
    }

    for (final Autonomo a in autonomos) {
      marcadores.add(Marker(
        markerId: MarkerId('autonomo_${a.id}'),
        position: LatLng(a.lat, a.long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(
          title: a.nome,
          snippet: a.especialidade,
        ),
      ));
    }

    setState(() {
      _marcadores = marcadores;
    });
  }
>>>>>>> b5318fa07caa7d426f5db46eeca302a7fcee7d24

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
<<<<<<< HEAD
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
=======
      const ClinicaPage(),
      const AutonomoPage(),
    ];
>>>>>>> b5318fa07caa7d426f5db46eeca302a7fcee7d24

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