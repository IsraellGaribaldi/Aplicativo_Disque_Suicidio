import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_disque_suicidio/banco/clinica_dao.dart';
import 'package:app_disque_suicidio/banco/autonomo_dao.dart';
import 'package:app_disque_suicidio/main.dart';
import 'package:app_disque_suicidio/models/autonomos.dart';
import 'package:app_disque_suicidio/models/clinicas.dart';
import 'package:app_disque_suicidio/models/usuario_model.dart';
import 'package:app_disque_suicidio/pages/autonomo/autonomo_page.dart';
import 'package:app_disque_suicidio/pages/clinica/clinicas_page.dart';
import 'package:app_disque_suicidio/pages/favoritos/favoritos_page.dart';
import 'package:app_disque_suicidio/pages/home/home_page.dart';
import 'package:app_disque_suicidio/pages/perfil/perfil_usuario.dart';
import 'package:app_disque_suicidio/pages/favoritos/saber_mais.dart';

class MapPage extends StatefulWidget {
  final Usuario usuario;


  const MapPage({super.key, required this.usuario});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _paginaAtual = 0;
  Set<Marker> _marcadores = {};
  late GoogleMapController mapController;
  final LatLng _centro = const LatLng(-7.1195, -34.8450);

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
        infoWindow: InfoWindow(title: c.nome, snippet: 'Clínica'),
      ));
    }

    for (final Autonomo a in autonomos) {
      marcadores.add(Marker(
        markerId: MarkerId('autonomo_${a.id}'),
        position: LatLng(a.lat, a.long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: a.nome, snippet: a.especialidade),
      ));
    }

    setState(() => _marcadores = marcadores);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);

    final telas = [
      Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _centro, zoom: 13),
            markers: _marcadores,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
          ),
          Positioned(
            top: 50,
            right: 16,
            child: _MenuFlutuante(
              isDark: appState?.isDark ?? false,
              onToggleTheme: () => appState?.toggleTheme(),
              onLogout: _logout,
            ),
          ),
        ],
      ),
      const ClinicaPage(),
      const AutonomoPage(),
      FavoritosPage(usuario: widget.usuario),
      PerfilUsuarioPage(usuario: widget.usuario),
    ];

    return Scaffold(
      body: telas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: (index) => setState(() => _paginaAtual = index),
        backgroundColor: const Color(0xFF008D97),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital), label: 'Clínicas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.psychology), label: 'Autônomos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'Favoritos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _MenuFlutuante extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const _MenuFlutuante({
    required this.isDark,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  State<_MenuFlutuante> createState() => _MenuFlutuanteState();
}

class _MenuFlutuanteState extends State<_MenuFlutuante> {
  bool _aberto = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          mini: true,
          backgroundColor: const Color(0xFF008D97),
          onPressed: () => setState(() => _aberto = !_aberto),
          child: Icon(
            _aberto ? Icons.close : Icons.menu,
            color: Colors.white,
          ),
        ),
        if (_aberto) ...[
          const SizedBox(height: 8),
          _ItemMenu(
            icone: widget.isDark ? Icons.light_mode : Icons.dark_mode,
            label: widget.isDark ? 'Tema claro' : 'Tema escuro',
            onTap: () {
              widget.onToggleTheme();
              setState(() => _aberto = false);
            },
          ),
          const SizedBox(height: 8),
            _ItemMenu(                          // 👈 novo botão
              icone: Icons.info_outline,
              label: 'Saber mais',
              onTap: () {
                setState(() => _aberto = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SaibaMais()),
                );
              },
            ),
          const SizedBox(height: 8),
          _ItemMenu(
            icone: Icons.logout,
            label: 'Sair',
            onTap: () {
              setState(() => _aberto = false);
              widget.onLogout();
            },
          ),
        ],
      ],
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final IconData icone;
  final String label;
  final VoidCallback onTap;

  const _ItemMenu({
    required this.icone,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF008D97),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}