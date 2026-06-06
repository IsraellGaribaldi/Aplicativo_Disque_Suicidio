import 'package:app_disque_suicidio/banco/autonomo_dao.dart';
import 'package:app_disque_suicidio/models/autonomos.dart';

class AutonomosController {
  final _dao = AutonomoDao();

  Future<List<Autonomo>> listarAutonomos() async {
    return await _dao.buscarAutonomos();
  }
}