import 'autonomos.dart';

class Clinica {
  final int? id;
  final String nome;
  final String endereco;
  final String horario;
  final String descricao;
  final double nota;
  final double lat;
  final double long;
  final List<String> planos;
  final List<Autonomo> profissionais;

  Clinica({
    this.id,
    required this.nome,
    required this.endereco,
    required this.horario,
    required this.descricao,
    required this.nota,
    required this.lat,
    required this.long,
    required this.planos,
    required this.profissionais,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'horario': horario,
      'descricao': descricao,
      'nota': nota,
      'lat': lat,
      'long': long,
      'planos': planos.join(','),
    };
  }

  factory Clinica.fromMap(Map<String, dynamic> map, {List<Autonomo> profissionais = const []}) {
    return Clinica(
      id: map['id'],
      nome: map['nome'],
      endereco: map['endereco'],
      horario: map['horario'],
      descricao: map['descricao'],
      nota: map['nota'],
      lat: map['lat'],
      long: map['long'],
      planos: (map['planos'] as String).split(','),
      profissionais: profissionais,
    );
  }
}