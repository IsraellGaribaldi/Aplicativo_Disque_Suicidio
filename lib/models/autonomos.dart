class Autonomo {
  final int? id;
  final String nome;
  final String especialidade;
  final String endereco;
  final String horario;
  final String descricao;
  final double preco;
  final double nota;
  final double lat;
  final double long;
  final List<String> planos;
  final List<String> credenciais;
  final String? imagem;

  Autonomo({
    this.id,
    required this.nome,
    required this.especialidade,
    required this.endereco,
    required this.horario,
    required this.descricao,
    required this.preco,
    required this.nota,
    required this.lat,
    required this.long,
    required this.planos,
    required this.credenciais,
    this.imagem,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'especialidade': especialidade,
      'endereco': endereco,
      'horario': horario,
      'descricao': descricao,
      'preco': preco,
      'nota': nota,
      'lat': lat,
      'long': long,
      'planos': planos.join(','),
      'credenciais': credenciais.join(','),
      'imagem': imagem,
    };
  }

  factory Autonomo.fromMap(Map<String, dynamic> map) {
    return Autonomo(
      id: map['id'],
      nome: map['nome'],
      especialidade: map['especialidade'],
      endereco: map['endereco'],
      horario: map['horario'],
      descricao: map['descricao'],
      preco: map['preco'],
      nota: map['nota'],
      lat: map['lat'],
      long: map['long'],
      planos: (map['planos'] as String).split(','),
      credenciais: (map['credenciais'] as String).split(','),
      imagem: map['imagem'],
    );
  }
}