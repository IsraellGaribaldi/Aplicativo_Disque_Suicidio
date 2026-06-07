import 'package:flutter/material.dart';
import 'package:app_disque_suicidio/controllers/autonomos_controller.dart';
import 'package:app_disque_suicidio/models/autonomos.dart';
import 'package:app_disque_suicidio/pages/clinica/credenciais_page.dart';

class AutonomoPage extends StatefulWidget {
  const AutonomoPage({super.key});

  @override
  State<AutonomoPage> createState() => _AutonomoPageState();
}

class _AutonomoPageState extends State<AutonomoPage> {
  final controller = AutonomosController();
  late Future<List<Autonomo>> _autonomos;

  @override
  void initState() {
    super.initState();
    _autonomos = controller.listarAutonomos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autônomos')),
      body: FutureBuilder<List<Autonomo>>(
        future: _autonomos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final autonomos = snapshot.data ?? [];
          if (autonomos.isEmpty) {
            return const Center(child: Text('Nenhum autônomo encontrado.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: autonomos.length,
            itemBuilder: (context, index) {
              return _CardAutonomo(autonomo: autonomos[index]);
            },
          );
        },
      ),
    );
  }
}

class _CardAutonomo extends StatelessWidget {
  final Autonomo autonomo;

  const _CardAutonomo({required this.autonomo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(autonomo.nome,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(autonomo.especialidade,
                style: const TextStyle(color: Colors.teal)),
            const SizedBox(height: 8),
            Text(autonomo.endereco),
            Text(autonomo.horario),
            const SizedBox(height: 12),
            const Text('Sobre',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(autonomo.descricao),
            const SizedBox(height: 12),
            const Text('Planos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            ...autonomo.planos.map((p) => Text('• $p')),
            const SizedBox(height: 12),
            const Text('Preço',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('R\$ ${autonomo.preco.toStringAsFixed(2)} a consulta'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(double.infinity, 55),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CredenciaisPage(profissional: autonomo),
                  ),
                ),
                child: const Text(
                  'Ver credenciais',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}