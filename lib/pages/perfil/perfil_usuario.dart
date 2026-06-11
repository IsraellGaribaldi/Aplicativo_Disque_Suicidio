import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_disque_suicidio/banco/database_helper.dart';
import 'package:app_disque_suicidio/models/usuario_model.dart';
import 'package:app_disque_suicidio/utils/hash_helper.dart';

class PerfilUsuarioPage extends StatefulWidget {
  final Usuario usuario;

  const PerfilUsuarioPage({super.key, required this.usuario});

  @override
  State<PerfilUsuarioPage> createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _mostrarFormSenha = false;
  bool _carregando = false;
  File? _fotoPerfil;

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    super.dispose();
  }

  Future<void> _escolherFoto() async {
    final picker = ImagePicker();
    final XFile? foto = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (foto != null) {
      setState(() {
        _fotoPerfil = File(foto.path);
      });
    }
  }

  Future<void> _mudarSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final db = await DatabaseHelper.getDatabase();
    final resultado = await db.query(
      'contas',
      where: 'id = ? AND senha = ?',
      whereArgs: [
        widget.usuario.id,
        HashHelper.hashSenha(_senhaAtualController.text),
      ],
    );

    if (resultado.isEmpty) {
      setState(() => _carregando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha atual incorreta.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await DatabaseHelper.atualizarSenha(
      widget.usuario.id,
      HashHelper.hashSenha(_novaSenhaController.text),
    );

    setState(() {
      _carregando = false;
      _mostrarFormSenha = false;
    });

    _senhaAtualController.clear();
    _novaSenhaController.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Senha alterada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatarData(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
  }

  @override
  Widget build(BuildContext context) {
    final usuario = widget.usuario;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de identificação
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _escolherFoto,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: const Color(0xFF008D97),
                          backgroundImage: _fotoPerfil != null
                              ? FileImage(_fotoPerfil!)
                              : null,
                          child: _fotoPerfil == null
                              ? const Icon(Icons.person,
                              color: Colors.white, size: 36)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF008D97),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario.nome,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(usuario.email,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card de dados pessoais
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dados Pessoais',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _LinhaInfo('Nome', usuario.nome),
                  _LinhaInfo('Email', usuario.email),
                  _LinhaInfo('Telefone', usuario.telefone),
                  _LinhaInfo('Nascimento',
                      _formatarData(usuario.dataNascimento)),
                  _LinhaInfo('Gênero', usuario.genero),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botão mudar senha
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008D97),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(double.infinity, 55),
                ),
                onPressed: () {
                  setState(() => _mostrarFormSenha = !_mostrarFormSenha);
                },
                child: Text(
                  _mostrarFormSenha ? 'Cancelar' : 'Mudar Senha',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            // Formulário de mudança de senha
            if (_mostrarFormSenha) ...[
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _senhaAtualController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Senha atual',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira a senha atual';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _novaSenhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Nova senha',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira a nova senha';
                        }
                        if (value.length < 6) {
                          return 'Mínimo 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008D97),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          minimumSize: const Size(double.infinity, 55),
                        ),
                        onPressed: _carregando ? null : _mudarSenha,
                        child: _carregando
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : const Text('Confirmar',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LinhaInfo extends StatelessWidget {
  final String label;
  final String valor;

  const _LinhaInfo(this.label, this.valor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }
}