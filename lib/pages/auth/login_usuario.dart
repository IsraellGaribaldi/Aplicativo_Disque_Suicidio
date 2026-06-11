import 'package:app_disque_suicidio/main.dart';
import 'package:flutter/material.dart';
import 'package:app_disque_suicidio/banco/database_helper.dart';
import 'package:app_disque_suicidio/models/usuario_model.dart';
import 'package:app_disque_suicidio/pages/auth/cadastro_usuario.dart';
import 'package:app_disque_suicidio/pages/home/mapa_inicio.dart';
import 'package:app_disque_suicidio/utils/hash_helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final db = await DatabaseHelper.getDatabase();
    final resultado = await db.query(
      'contas',
      where: 'email = ? AND senha = ?',
      whereArgs: [
        _emailController.text.trim(),
        HashHelper.hashSenha(_passwordController.text),
      ],
    );

    setState(() => _carregando = false);

    if (!mounted) return;

    if (resultado.isNotEmpty) {
      final usuario = Usuario.fromMap(resultado.first);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MapPage(usuario: usuario)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email ou senha incorretos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);
    final isDark = appState?.isDark ?? false;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
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
                        'img/Escura-removebg-preview.png',
                        height: 250,
                        width: 230,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Boas Vindas!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 33),
                    Text(
                      "Faça login para continuar",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        labelText: 'Email',
                        hintText: 'Digite seu email aqui',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o email';
                        }
                        if (!value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        labelText: 'Senha',
                        hintText: 'Digite sua senha aqui',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a senha';
                        }
                        if (value.length < 6) {
                          return 'Mínimo 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Esqueceu a senha?",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 58),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF008D97),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(362, 60),
                      ),
                      onPressed: _carregando ? null : _fazerLogin,
                      child: _carregando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 83),
                    Text(
                      "Não se cadastrou?",
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
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(171, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CadastroUsuario()),
                        );
                      },
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
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