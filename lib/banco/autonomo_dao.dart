import 'package:app_disque_suicidio/banco/database_helper.dart';
import 'package:app_disque_suicidio/models/autonomos.dart';

class AutonomoDao {
  Future<List<Autonomo>> buscarAutonomos() async {
    final db = await DatabaseHelper.getDatabase();
    final resultado = await db.query('autonomos');
    return resultado.map((item) => Autonomo.fromMap(item)).toList();
  }

  Future<int> inserirAutonomo(Autonomo autonomo) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.insert('autonomos', autonomo.toMap());
  }

  Future<void> deletarAutonomo(int id) async {
    final db = await DatabaseHelper.getDatabase();
    await db.delete('autonomos', where: 'id = ?', whereArgs: [id]);
    await db.delete('clinica_profissionais',
        where: 'autonomo_id = ?', whereArgs: [id]);
  }
}