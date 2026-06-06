import 'package:flutter/material.dart';
import 'package:app_disque_suicidio/controllers/clinicas_controller.dart';
import 'package:app_disque_suicidio/models/autonomos.dart';
import 'package:app_disque_suicidio/models/clinicas.dart';
import 'package:app_disque_suicidio/pages/clinica/credenciais_page.dart';

class ClinicaPage extends StatefulWidget {
  const ClinicaPage({super.key});

  @override
  State<ClinicaPage> createState() => _ClinicaPageState();
}

class _ClinicaPageState extends State<ClinicaPage> {
  final controller = ClinicasController();
  late Future<List<Clinica>> _clinicas;

  @override
  void initState() {
    super.initState();
    _clinicas = controller.listarClinicas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clínicas')),
      body: FutureBuilder<List<Clinica>>(
        future: _clinicas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final clinicas = snapshot.data ?? [];
          if (clinicas.isEmpty) {
            return const Center(child: Text('Nenhuma clínica encontrada.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: clinicas.length,
            itemBuilder: (context, index) {
              return _CardClinica(clinica: clinicas[index]);
            },
          );
        },
      ),
    );
  }
}

class _CardClinica extends StatelessWidget {
  final Clinica clinica;

  const _CardClinica({required this.clinica});

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
            Text(clinica.nome,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(clinica.endereco),
            Text(clinica.horario),
            const SizedBox(height: 12),
            const Text('Sobre',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(clinica.descricao),
            const SizedBox(height: 12),
            const Text('Planos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            ...clinica.planos.map((p) => Text('• $p')),
            const SizedBox(height: 12),
            const Text('Profissionais',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...clinica.profissionais
                .map((prof) => _CardProfissional(profissional: prof)),
          ],
        ),
      ),
    );
  }
}

class _CardProfissional extends StatelessWidget {
  final Autonomo profissional;

  const _CardProfissional({required this.profissional});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF0EF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(profissional.nome,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text(profissional.planos.join(' e ')),
          Text(profissional.horario),
          Text('R\$ ${profissional.preco.toStringAsFixed(2)} a consulta'),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CredenciaisPage(profissional: profissional),
                ),
              ),
              child: const Text('Ver credenciais'),
            ),
          ),
        ],
      ),
    );
  }
}