import 'package:flutter/material.dart';

class SaibaMais extends StatefulWidget {
  const SaibaMais({super.key});

  @override
  State<SaibaMais> createState() => _SaibaMaisState();
}

class _SaibaMaisState extends State<SaibaMais> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Saiba mais sobre os tipos de serviços",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 79),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Psicólogo",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 35),
                          const Text(
                            'É o profissional de saúde formado em Psicologia que estuda a mente e o comportamento humano. Ele utiliza métodos científicos para prevenir, diagnosticar e tratar transtornos mentais e emocionais, promovendo o autoconhecimento, a regulação emocional e o bem-estar dos indivíduos.',
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'img/psicologo.jpeg',
                        width: 171,
                        height: 266,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 171,
                          height: 266,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 75),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Psicanalista",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 35),
                          const Text(
                            'É um especialista em saúde mental que investiga o inconsciente para tratar conflitos internos, traumas e distúrbios emocionais. Utilizando métodos como a livre associação e interpretação de sonhos, baseados na teoria de Sigmund Freud, ele ajuda o paciente a entender as raízes de angústias e os comportamentos autodestrutivos.',
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'img/psicanalista.jpeg',
                        width: 171,
                        height: 266,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 171,
                          height: 266,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 75),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Psiquiatra",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 35),
                          const Text(
                            'É um médico especialista em saúde mental. Ele é habilitado para prevenir, diagnosticar e tratar transtornos mentais e sofrimentos emocionais. Diferente de outros profissionais da saúde, por ser médico, ele pode solicitar exames físicos e laboratoriais e prescrever medicamentos.',
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'img/psiquiatra.jpeg',
                        width: 171,
                        height: 266,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 171,
                          height: 266,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}