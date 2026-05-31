class Usuario {
  String id;
  String nome;
  String email;
  String telefone;
  DateTime dataNascimento;
  String genero;
  String senha;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.dataNascimento,
    required this.genero,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'dataNascimento': dataNascimento.toIso8601String(),
      'genero': genero,
      'senha': senha,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      dataNascimento: DateTime.parse(map['dataNascimento']),
      genero: map['genero'],
      senha: map['senha'],
    );
  }
}

class UsuarioLogin {
  String email;
  String senha;

  UsuarioLogin({
    required this.email,
    required this.senha,
  });
}