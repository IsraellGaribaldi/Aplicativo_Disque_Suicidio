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
import 'package:app_disque_suicidio/pages/favoritos/saber_mais.dart';
import 'package:app_disque_suicidio/banco/favorito_dao.dart';
import 'package:app_disque_suicidio/pages/home/home_page.dart';
import 'package:app_disque_suicidio/pages/perfil/perfil_usuario.dart';

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

  bool _mostrarClinicas = true;
  bool _mostrarAutonomos = true;

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
  }

  Future<void> _carregarMarcadores() async {
    final clinicas = await ClinicaDao().buscarClinicas();
    final autonomos = await AutonomoDao().buscarAutonomos();

    final Set<Marker> marcadores = {};

    if (_mostrarClinicas) {
      for (final Clinica c in clinicas) {
        marcadores.add(Marker(
          markerId: MarkerId('clinica_${c.id}'),
          position: LatLng(c.lat, c.long),
          infoWindow: InfoWindow(title: c.nome, snippet: 'Clínica'),
          onTap: () => _mostrarDetalhesClinica(c),
        ));
      }
    }

    if (_mostrarAutonomos) {
      for (final Autonomo a in autonomos) {
        marcadores.add(Marker(
          markerId: MarkerId('autonomo_${a.id}'),
          position: LatLng(a.lat, a.long),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(title: a.nome, snippet: a.especialidade),
          onTap: () => _mostrarDetalhesAutonomo(a),
        ));
      }
    }

    setState(() => _marcadores = marcadores);
  }

  void _mostrarDetalhesClinica(Clinica c) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_hospital, color: Color(0xFF008D97)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    c.nome,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.location_on, text: c.endereco),
            _InfoRow(icon: Icons.access_time, text: c.horario),
            _InfoRow(icon: Icons.star, text: 'Nota: ${c.nota}'),
            _InfoRow(icon: Icons.health_and_safety, text: 'Planos: ${c.planos.join(', ')}'),
            const SizedBox(height: 8),
            Text(c.descricao, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008D97),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  await FavoritoDao().favoritar(
                    usuarioId: widget.usuario.id,
                    referenciaId: c.id!,
                    tipo: 'clinica',
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clínica adicionada aos favoritos!'),
                      backgroundColor: Color(0xFF008D97),
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark_add, color: Colors.white),
                label: const Text('Favoritar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalhesAutonomo(Autonomo a) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, color: Color(0xFF008D97)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    a.nome,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.work, text: a.especialidade),
            _InfoRow(icon: Icons.location_on, text: a.endereco),
            _InfoRow(icon: Icons.access_time, text: a.horario),
            _InfoRow(icon: Icons.star, text: 'Nota: ${a.nota}'),
            _InfoRow(icon: Icons.attach_money, text: 'R\$ ${a.preco.toStringAsFixed(2)}'),
            _InfoRow(icon: Icons.health_and_safety, text: 'Planos: ${a.planos.join(', ')}'),
            const SizedBox(height: 8),
            Text(a.descricao, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008D97),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  await FavoritoDao().favoritar(
                    usuarioId: widget.usuario.id,
                    referenciaId: a.id!,
                    tipo: 'autonomo',
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profissional adicionado aos favoritos!'),
                      backgroundColor: Color(0xFF008D97),
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark_add, color: Colors.white),
                label: const Text('Favoritar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
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
          // Menu flutuante (canto superior direito)
          Positioned(
            top: 50,
            right: 16,
            child: _MenuFlutuante(
              isDark: appState?.isDark ?? false,
              onToggleTheme: () => appState?.toggleTheme(),
              onLogout: _logout,
              onSaberMais: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SaibaMais()),
                );
              },
            ),
          ),
          // Filtros (canto inferior)
          Positioned(
            bottom: 20,
            left: 16,
            child: Row(
              children: [
                _FiltroChip(
                  label: 'Clínicas',
                  icon: Icons.local_hospital,
                  selecionado: _mostrarClinicas,
                  onTap: () {
                    setState(() => _mostrarClinicas = !_mostrarClinicas);
                    _carregarMarcadores();
                  },
                ),
                const SizedBox(width: 8),
                _FiltroChip(
                  label: 'Autônomos',
                  icon: Icons.psychology,
                  selecionado: _mostrarAutonomos,
                  onTap: () {
                    setState(() => _mostrarAutonomos = !_mostrarAutonomos);
                    _carregarMarcadores();
                  },
                ),
              ],
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
          BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: 'Clínicas'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'Autônomos'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// Widget de linha de informação no bottom sheet
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF008D97)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

// Widget de chip de filtro
class _FiltroChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selecionado;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.icon,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? const Color(0xFF008D97) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF008D97), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: selecionado ? Colors.white : const Color(0xFF008D97),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selecionado ? Colors.white : const Color(0xFF008D97),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Menu flutuante superior direito
class _MenuFlutuante extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;
  final VoidCallback onSaberMais;

  const _MenuFlutuante({
    required this.isDark,
    required this.onToggleTheme,
    required this.onLogout,
    required this.onSaberMais,
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
          _ItemMenu(
            icone: Icons.info_outline,
            label: 'Saber mais',
            onTap: () {
              setState(() => _aberto = false);
              widget.onSaberMais();
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