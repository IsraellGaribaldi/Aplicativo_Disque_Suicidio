import 'package:flutter/material.dart';
import '../models/clinicas.dart';

class ClinicasController extends ChangeNotifier {
  List<Clinica> buscarClinicas() {
    return [
      Clinica(
        nome: 'Clínica Vida',
        endereco: 'Rua A, 123',
        horario: '08:00 às 18:00',
        descricao: 'Atendimento psicológico e psiquiátrico.',
        nota: 4.8,
        planos: ['Unimed', 'Hapvida', 'Geap'],
      ),

      Clinica(
        nome: 'Clínica Esperança',
        endereco: 'Av. Central, 456',
        horario: '07:00 às 20:00',
        descricao: 'Especializada em saúde mental.',
        nota: 4.6,
        planos: ['Bradesco', 'SulAmérica'],
      ),
    ];
  }

  Clinica buscarClinica() {
    return buscarClinicas().first;
  }
}
