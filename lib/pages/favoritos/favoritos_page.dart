import 'package:flutter/material.dart';
import 'package:app_disque_suicidio/banco/database_helper.dart';
import 'package:app_disque_suicidio/models/usuario_model.dart';

class FavoritosPage extends StatefulWidget {
  final Usuario usuario;

  const FavoritosPage({super.key, required this.usuario});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  late Future<List<Map<String, dynamic>>> _favoritos;

  @override
  void initState() {
    super.initState();
    _favoritos = _buscarFavoritos();
  }

  Future<List<Map<String, dynamic>>> _buscarFavoritos() async {
    final db = await DatabaseHelper.getDatabase();

    final clinicas = await db.rawQuery('''
      SELECT c.id, c.nome, c.endereco, c.horario, c.nota, 'clinica' as tipo
      FROM clinicas c
      INNER JOIN favoritos f ON c.id = f.referencia_id
      WHERE f.usuario_id = ? AND f.tipo = 'clinica'
    ''', [widget.usuario.id]);

    final autonomos = await db.rawQuery('''
      SELECT a.id, a.nome, a.endereco, a.horario, a.nota, a.especialidade, 'autonomo' as tipo
      FROM autonomos a
      INNER JOIN favoritos f ON a.id = f.referencia_id
      WHERE f.usuario_id = ? AND f.tipo = 'autonomo'
    ''', [widget.usuario.id]);

    return [...clinicas, ...autonomos];
  }

  Future<void> _removerFavorito(int referenciaId, String tipo) async {
    final db = await DatabaseHelper.getDatabase();
    await db.delete(
      'favoritos',
      where: 'usuario_id = ? AND referencia_id = ? AND tipo = ?',
      whereArgs: [widget.usuario.id, referenciaId, tipo],
    );
    setState(() {
      _favoritos = _buscarFavoritos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _favoritos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final favoritos = snapshot.data ?? [];
          if (favoritos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum favorito ainda.',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoritos.length,
            itemBuilder: (context, index) {
              final item = favoritos[index];
              final tipo = item['tipo'] as String;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF008D97),
                    child: Icon(
                      tipo == 'clinica'
                          ? Icons.local_hospital
                          : Icons.psychology,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(item['nome'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(item['endereco'] as String),
                      Text(item['horario'] as String),
                      if (tipo == 'autonomo')
                        Text(item['especialidade'] as String,
                            style: const TextStyle(color: Color(0xFF008D97))),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark, color: Color(0xFF008D97)),
                    onPressed: () =>
                        _removerFavorito(item['id'] as int, tipo),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}