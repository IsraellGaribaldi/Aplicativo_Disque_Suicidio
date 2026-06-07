import 'package:flutter/material.dart';
import 'package:app_disque_suicidio/main.dart';
import 'package:app_disque_suicidio/pages/auth/login_usuario.dart';
import 'package:app_disque_suicidio/pages/perfil/perfil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);
    final isDark = appState?.isDark ?? false;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: isDark
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
                      height: 300,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Seja Bem-vindo",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 196),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Perfil()),
                      );
                    },
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Text(
                    "Ou se já tiver uma conta",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 21),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xFF008D97),
              onPressed: () => appState?.toggleTheme(),
              child: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}