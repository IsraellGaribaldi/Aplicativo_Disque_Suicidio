import 'package:app_disque_suicidio/banco/database_helper.dart';
import 'package:app_disque_suicidio/models/autonomos.dart';
import 'package:app_disque_suicidio/models/clinicas.dart';

class ClinicaDao {
  Future<List<Clinica>> buscarClinicas() async {
    final db = await DatabaseHelper.getDatabase();
    final resultado = await db.query('clinicas');

    List<Clinica> clinicas = [];

    for (final item in resultado) {
      final clinicaId = item['id'] as int;

      final profissionaisResult = await db.rawQuery('''
        SELECT a.* FROM autonomos a
        INNER JOIN clinica_profissionais cp ON a.id = cp.autonomo_id
        WHERE cp.clinica_id = ?
      ''', [clinicaId]);

      final profissionais = profissionaisResult
          .map((p) => Autonomo.fromMap(p))
          .toList();

      clinicas.add(Clinica.fromMap(item, profissionais: profissionais));
    }

    return clinicas;
  }

  Future<int> inserirClinica(Clinica clinica) async {
    final db = await DatabaseHelper.getDatabase();
    return await db.insert('clinicas', clinica.toMap());
  }

  Future<void> deletarClinica(int id) async {
    final db = await DatabaseHelper.getDatabase();
    await db.delete('clinicas', where: 'id = ?', whereArgs: [id]);
    await db.delete('clinica_profissionais',
        where: 'clinica_id = ?', whereArgs: [id]);
  }
}