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
      'id': id.toString(),
      'nome': nome.toString(),
      'email': email.toString(),
      'telefone': telefone.toString(),
      'dataNascimento': dataNascimento.toIso8601String().split('T')[0],
      'genero': genero.toString(),
      'senha': senha.toString(),
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