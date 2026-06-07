import 'package:flutter/material.dart';
import 'package:app_disque_suicidio/pages/auth/cadastro_usuario.dart';
import '../auth/cadastro_empresa.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: Theme.of(context).brightness == Brightness.dark
                    ? const ColorFilter.matrix([
                  -1, 0, 0, 0, 255,
                  0, -1, 0, 0, 255,
                  0, 0, -1, 0, 255,
                  0, 0, 0, 1, 0,
                ])
                    : const ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.dst,
                ),
                child: Image.asset(
                  'img/Escura-letreiro-removebg-preview.png',
                  height: 250,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Qual a classificação do seu perfil?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 91),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  elevation: 3,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(212, 121),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroUsuario(),
                    ),
                  );
                },
                child: Text(
                  'Usuário',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 42),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  elevation: 3,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(212, 121),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroEmpresa(),
                    ),
                  );
                },
                child: Text(
                  'Empresa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}