class Empresa {
  int? id;
  String? nome;
  String? email;
  String? telefone;
  String? cnpj;
  String? senha;
  double? lat;
  double? long;

  Empresa({
    this.id,
    this.nome,
    this.email,
    this.telefone,
    this.cnpj,
    this.senha,
    this.lat,
    this.long,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cnpj': cnpj,
      'senha': senha,
      'lat': lat,
      'long': long,
    };
  }

  factory Empresa.fromMap(Map<String, dynamic> map) {
    return Empresa(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      cnpj: map['cnpj'],
      senha: map['senha'],
      lat: map['lat'],
      long: map['long'],
    );
  }
}