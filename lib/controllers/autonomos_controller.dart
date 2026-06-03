import 'package:flutter/material.dart';
import '../models/autonomos.dart';

class AutonomosController extends ChangeNotifier {
  List<Autonomo> buscarAutonomos() {
    return [
      Autonomo(
        nome: 'Maria Silva',
        especialidade: 'Psicóloga',
        endereco: 'Rua B, 45',
        horario: '09:00 às 17:00',
        descricao: 'Atendimento individual e familiar.',
        preco: 120.00,
        nota: 4.9,
        planos: ['Unimed', 'Particular'],
      ),

      Autonomo(
        nome: 'Carlos Souza',
        especialidade: 'Psiquiatra',
        endereco: 'Av. Norte, 200',
        horario: '08:00 às 18:00',
        descricao: 'Especialista em transtornos de ansiedade.',
        preco: 250.00,
        nota: 4.7,
        planos: ['Hapvida', 'Particular'],
      ),
    ];
  }

  Autonomo buscarAutonomo() {
    return buscarAutonomos().first;
  }
}
