import 'package:app_disque_suicidio/utils/hash_helper.dart';
import 'package:flutter/material.dart';
import 'package:app_disque_suicidio/banco/database_helper.dart';
import 'package:app_disque_suicidio/models/usuario_model.dart';
import 'package:app_disque_suicidio/pages/auth/login_usuario.dart';
import 'package:uuid/uuid.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _generoSelecionado;
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _dataNascimentoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      final db = await DatabaseHelper.getDatabase();

      final emailExistente = await db.query(
        'contas',
        where: 'email = ?',
        whereArgs: [_emailController.text.trim()],
      );

      if (emailExistente.isNotEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este email já está cadastrado.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final partes = _dataNascimentoController.text.split('/');
      final dataNascimento = DateTime(
        int.parse(partes[2]),
        int.parse(partes[1]),
        int.parse(partes[0]),
      );

      final usuario = Usuario(
        id: const Uuid().v4(),
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        dataNascimento: dataNascimento,
        genero: _generoSelecionado!,
        senha: HashHelper.hashSenha(_passwordController.text),
      );

      await DatabaseHelper.inserirUsuario(usuario);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso! Faça login.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Criar uma conta",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nomeController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: 'Nome Completo',
                    hintText: 'Digite seu nome aqui',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o seu nome';
                    }
                    return null;
                  },
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
                const SizedBox(height: 30),
                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: 'Telefone',
                    hintText: 'Digite seu telefone aqui',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o seu telefone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _dataNascimentoController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: 'Data de Nascimento',
                    hintText: 'Selecione sua data',
                  ),
                  onTap: () async {
                    DateTime? dataSelecionada = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now()
                          .subtract(const Duration(days: 365 * 18)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (dataSelecionada != null) {
                      _dataNascimentoController.text =
                      "${dataSelecionada.day.toString().padLeft(2, '0')}/${dataSelecionada.month.toString().padLeft(2, '0')}/${dataSelecionada.year}";
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua data de nascimento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  initialValue: _generoSelecionado,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: 'Gênero',
                  ),
                  items: ['Masculino', 'Feminino', 'Outro', 'Prefiro não dizer']
                      .map((genero) => DropdownMenuItem(
                    value: genero,
                    child: Text(genero),
                  ))
                      .toList(),
                  onChanged: (novoValor) {
                    setState(() {
                      _generoSelecionado = novoValor;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione o seu gênero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
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
                const SizedBox(height: 64),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: const Size(362, 60),
                  ),
                  onPressed: _carregando ? null : _cadastrar,
                  child: _carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 94),
                const Text(
                  "Já tem uma conta?",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 19),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: const Size(171, 50),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                          (route) => false,
                    );
                  },
                  child: const Text(
                    'Faça login',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}