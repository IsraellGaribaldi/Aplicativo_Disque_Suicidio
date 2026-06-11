import 'package:app_disque_suicidio/banco/clinica_dao.dart';
import 'package:app_disque_suicidio/models/clinicas.dart';

class ClinicasController {
  final _dao = ClinicaDao();

  Future<List<Clinica>> listarClinicas() async {
    return await _dao.buscarClinicas();
  }
}