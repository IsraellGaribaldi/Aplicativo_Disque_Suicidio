import '../banco/database_helper.dart';
import '../models/clinicas.dart'; 

class ClinicaDao {
  Future<List<Clinica>> buscarClinicas() async {
    final db = await DatabaseHelper.getDatabase();

    final resultado = await db.query('clinicas');

    return resultado.map((item) {
      return Clinica.fromMap(item);
    }).toList();
  }
}