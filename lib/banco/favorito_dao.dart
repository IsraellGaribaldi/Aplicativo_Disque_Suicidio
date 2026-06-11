import 'package:app_disque_suicidio/banco/database_helper.dart';

class FavoritoDao {
  Future<void> favoritar({
    required String usuarioId,
    required int referenciaId,
    required String tipo, // 'clinica' ou 'autonomo'
  }) async {
    final db = await DatabaseHelper.getDatabase();
    final existente = await db.query(
      'favoritos',
      where: 'usuario_id = ? AND referencia_id = ? AND tipo = ?',
      whereArgs: [usuarioId, referenciaId, tipo],
    );
    if (existente.isEmpty) {
      await db.insert('favoritos', {
        'usuario_id': usuarioId,
        'referencia_id': referenciaId,
        'tipo': tipo,
      });
    }
  }

  Future<void> desfavoritar({
    required String usuarioId,
    required int referenciaId,
    required String tipo,
  }) async {
    final db = await DatabaseHelper.getDatabase();
    await db.delete(
      'favoritos',
      where: 'usuario_id = ? AND referencia_id = ? AND tipo = ?',
      whereArgs: [usuarioId, referenciaId, tipo],
    );
  }

  Future<bool> isFavorito({
    required String usuarioId,
    required int referenciaId,
    required String tipo,
  }) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query(
      'favoritos',
      where: 'usuario_id = ? AND referencia_id = ? AND tipo = ?',
      whereArgs: [usuarioId, referenciaId, tipo],
    );
    return result.isNotEmpty;
  }
}