import 'package:flutter/material.dart';
import 'package:app_disque_suicidio/models/autonomos.dart';
import 'package:app_disque_suicidio/models/clinicas.dart';

class CredenciaisPage extends StatelessWidget {
  final Clinica? clinica;
  final Autonomo? profissional;

  const CredenciaisPage({
    super.key,
    this.clinica,
    this.profissional,
  });

  @override
  Widget build(BuildContext context) {
    final String nomeExibido = clinica?.nome ?? profissional?.nome ?? 'Credenciais';

    final List<String> documentosClinica = [
      'Registro no CRP (Pessoa Jurídica)',
      'CNPJ',
      'Contrato Social',
      'Licença Sanitária',
      'CNES',
      'Inscrição Municipal',
    ];

    final List<String> documentosAutonomo = (profissional?.credenciais != null && profissional!.credenciais.isNotEmpty)
        ? profissional!.credenciais
        : ['Registro no CRP', 'CNPJ', 'Contrato Social', 'Licença Sanitária', 'CNES', 'Inscrição Municipal'];

    final List<String> formacoesAutonomo = [
      if (profissional?.diploma != null && profissional!.diploma.isNotEmpty)
        'Diploma em: ${profissional!.diploma}'
      else
        'Diploma não informado',
        
      if (profissional?.especialidade != null && profissional!.especialidade.isNotEmpty)
        'Especialização em: ${profissional!.especialidade}',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credenciais'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nomeExibido,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),

              if (clinica != null) ...[
                _buildRoundedContainer(
                  context: context,
                  titulo: 'Documentos Principais',
                  itens: documentosClinica,
                ),
              ],

              if (profissional != null) ...[
                _buildRoundedContainer(
                  context: context,
                  titulo: 'Documentos Principais',
                  itens: documentosAutonomo,
                ),
                
                const SizedBox(height: 20),

                _buildRoundedContainer(
                  context: context,
                  titulo: 'Formação Acadêmica',
                  itens: formacoesAutonomo,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedContainer({
    required BuildContext context,
    required String titulo,
    required List<String> itens,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...itens.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.trim(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}