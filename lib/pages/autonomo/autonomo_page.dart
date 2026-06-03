import 'package:flutter/material.dart';
import '../../controllers/autonomos_controller.dart';

class AutonomoPage extends StatelessWidget {
  AutonomoPage({super.key});

  final controller = AutonomosController();

  @override
  Widget build(BuildContext context) {
    final autonomo = controller.buscarAutonomo();

    return Scaffold(
      appBar: AppBar(title: Text(autonomo.nome)),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              autonomo.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text('Especialidade: ${autonomo.especialidade}'),
            Text('Endereço: ${autonomo.endereco}'),
            Text('Horário: ${autonomo.horario}'),

            const SizedBox(height: 15),

            Text(autonomo.descricao),

            const SizedBox(height: 15),

            Text('Preço da consulta: R\$ ${autonomo.preco}'),

            const SizedBox(height: 15),

            const Text(
              'Planos aceitos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            ...autonomo.planos.map((plano) => Text(plano)),
          ],
        ),
      ),
    );
  }
}
