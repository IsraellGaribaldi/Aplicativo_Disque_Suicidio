import 'package:flutter/material.dart';
import 'package:app_disque_suicidio/models/autonomos.dart';

class CredenciaisPage extends StatelessWidget {
  final Autonomo profissional;

  const CredenciaisPage({super.key, required this.profissional});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credenciais'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profissional.nome,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFDFF0EF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Documentos Principais',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ...profissional.credenciais.map(
                        (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(c),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}