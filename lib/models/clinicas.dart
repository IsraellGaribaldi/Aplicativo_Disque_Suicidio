class Clinica {
  final int? id;
  final String nome;
  final String endereco;
  final String horario;
  final String descricao;
  final double nota;
  final List<String> planos;
  final double latitude;
  final double longitude;

  Clinica({
    this.id,
    required this.nome,
    required this.endereco,
    required this.horario,
    required this.descricao,
    required this.nota,
    required this.planos,
    required this.latitude,
    required this.longitude,
  });

  factory Clinica.fromMap(Map<String, dynamic> map) {
    return Clinica(
      id: map['id'],
      nome: map['nome'],
      endereco: map['endereco'],
      horario: map['horario'],
      descricao: map['descricao'],
      nota: map['nota'],
      planos: List<String>.from(map['planos']),
      latitude: map['lat'],
      longitude: map['long'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'horario': horario,
      'descricao': descricao,
      'nota': nota,
      'planos': planos,
      'lat': latitude,
      'long': longitude,
    };
  }
  }





