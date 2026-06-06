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
        latitude: -7.1195,
        longitude: -34.8450,
      ),

      Clinica(
        nome: 'Clínica Esperança',
        endereco: 'Av. Central, 456',
        horario: '07:00 às 20:00',
        descricao: 'Especializada em saúde mental.',
        nota: 4.6,
        planos: ['Bradesco', 'SulAmérica'],
        latitude: -7.1200,
        longitude: -34.8460,
      ),
    ];
  }

  Clinica buscarClinica() {
    return buscarClinicas().first;
  }
}
