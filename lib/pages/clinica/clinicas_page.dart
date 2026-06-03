import 'package:flutter/material.dart';
import '../../controllers/clinicas_controller.dart';

class ClinicaPage extends StatelessWidget {
  ClinicaPage({super.key});

  final controller = ClinicasController();

  @override
  Widget build(BuildContext context) {
    final clinica = controller.buscarClinica();

    return Scaffold(
      appBar: AppBar(title: Text(clinica.nome)),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              clinica.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text('Endereço: ${clinica.endereco}'),
            Text('Horário: ${clinica.horario}'),

            const SizedBox(height: 15),

            Text(clinica.descricao),

            const SizedBox(height: 15),

            const Text(
              'Planos aceitos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            ...clinica.planos.map((plano) => Text(plano)),
          ],
        ),
      ),
    );
  }
}
