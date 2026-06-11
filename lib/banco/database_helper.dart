import 'package:app_disque_suicidio/models/usuario_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'banco.db');
    await deleteDatabase(path);
    _database = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contas (
            id TEXT PRIMARY KEY,
            nome TEXT,
            email TEXT,
            telefone TEXT,
            dataNascimento TEXT,
            genero TEXT,
            senha TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE clinicas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            endereco TEXT,
            horario TEXT,
            descricao TEXT,
            nota REAL,
            lat REAL,
            long REAL,
            planos TEXT,
            imagem TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE autonomos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            especialidade TEXT,
            endereco TEXT,
            horario TEXT,
            descricao TEXT,
            preco REAL,
            nota REAL,
            lat REAL,
            long REAL,
            planos TEXT,
            credenciais TEXT,
            imagem TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE clinica_profissionais (
            clinica_id INTEGER,
            autonomo_id INTEGER,
            PRIMARY KEY (clinica_id, autonomo_id),
            FOREIGN KEY (clinica_id) REFERENCES clinicas(id),
            FOREIGN KEY (autonomo_id) REFERENCES autonomos(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE favoritos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id TEXT,
            tipo TEXT,
            referencia_id INTEGER,
            FOREIGN KEY (usuario_id) REFERENCES contas(id)
          )
        ''');

        await _inserirDadosIniciais(db);
      },
    );

    return _database!;
  }

  static Future<void> _inserirDadosIniciais(Database db) async {
    final clinica1Id = await db.insert('clinicas', {
      'nome': 'Clínica Viver',
      'endereco': 'R. fictícia, 987, Manaíra, João Pessoa',
      'horario': 'Aberta as 08:00h - Fechada as 18:00h',
      'descricao': 'Clínica especializada em saúde mental com atendimento humanizado e multidisciplinar.',
      'nota': 5.0,
      'lat': -7.1489,
      'long': -34.8466,
      'planos': 'Unimed,Geap,Hapvida',
      'imagem': 'img/clinica1.jpeg',
    });

    final clinica2Id = await db.insert('clinicas', {
      'nome': 'Instituto Mente Sã',
      'endereco': 'Av. Epitácio Pessoa, 1200, Tambaú, João Pessoa',
      'horario': 'Aberta as 07:00h - Fechada as 20:00h',
      'descricao': 'Instituto especializado em psicologia clínica, psiquiatria e terapia familiar.',
      'nota': 4.7,
      'lat': -7.1150,
      'long': -34.8300,
      'planos': 'Unimed,Bradesco Saúde',
      'imagem': 'img/clinica2.jpeg',
    });

    final clinica3Id = await db.insert('clinicas', {
      'nome': 'Espaço Equilíbrio',
      'endereco': 'R. das Trincheiras, 450, Centro, João Pessoa',
      'horario': 'Aberta as 08:00h - Fechada as 17:00h',
      'descricao': 'Clínica integrada com foco em bem-estar emocional e qualidade de vida.',
      'nota': 4.5,
      'lat': -7.1195,
      'long': -34.8630,
      'planos': 'Hapvida,SulAmérica',
      'imagem': 'img/clinica3.jpeg',
    });

    final psicoId = await db.insert('autonomos', {
      'nome': 'Psicóloga Camila',
      'especialidade': 'Psicologia',
      'endereco': 'R. imaginária, 765, Funcionários IV, João Pessoa',
      'horario': 'De seg a sex, 12:00h às 18:00h',
      'descricao': 'Psicóloga clínica com especialização em ansiedade, depressão e terapia cognitivo-comportamental.',
      'preco': 200.0,
      'nota': 4.5,
      'lat': -7.1400,
      'long': -34.8550,
      'planos': 'Unimed,Geap',
      'credenciais': 'Registro no CRP,Diploma em Psicologia',
      'imagem': 'img/psicologo.jpeg',
    });

    final psiquiatraId = await db.insert('autonomos', {
      'nome': 'Psiquiatra Géssica',
      'especialidade': 'Psiquiatria',
      'endereco': 'R. qualquer, 111, Mangabeira I, João Pessoa',
      'horario': 'De ter a qui, 8:00h às 15:00h',
      'descricao': 'Psiquiatra especializado em transtornos do humor.',
      'preco': 500.0,
      'nota': 4.8,
      'lat': -7.1520,
      'long': -34.8490,
      'planos': 'Hapvida',
      'credenciais': 'Registro no CRM,Especialização em Psiquiatria',
      'imagem': 'img/psiquiatra.jpeg',
    });

    final psicanalista = await db.insert('autonomos', {
      'nome': 'Psicanalista Rodrigo',
      'especialidade': 'Psicanálise',
      'endereco': 'Av. Dom Pedro II, 800, Torre, João Pessoa',
      'horario': 'De seg a sex, 14:00h às 20:00h',
      'descricao': 'Psicanalista com formação freudiana e experiência em transtornos de personalidade.',
      'preco': 250.0,
      'nota': 4.6,
      'lat': -7.1300,
      'long': -34.8700,
      'planos': 'Particular',
      'credenciais': 'Registro no CRP,Diploma em Psicologia,Especialização em Psicanálise',
      'imagem': 'img/psicanalista.jpeg',
    });

    await db.insert('clinica_profissionais', {
      'clinica_id': clinica1Id,
      'autonomo_id': psicoId,
    });

    await db.insert('clinica_profissionais', {
      'clinica_id': clinica1Id,
      'autonomo_id': psiquiatraId,
    });

    await db.insert('clinica_profissionais', {
      'clinica_id': clinica2Id,
      'autonomo_id': psicanalista,
    });
  }

  static Future<void> inserirUsuario(Usuario usuario) async {
    final db = await getDatabase();
    await db.insert('contas', usuario.toMap());
  }

  static Future<void> deletarUsuario(int id) async {
    final db = await getDatabase();
    await db.delete('contas', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> atualizarSenha(String id, String novaSenha) async {
    final db = await getDatabase();
    await db.update(
      'contas',
      {'senha': novaSenha},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> inserirClinica(Map<String, dynamic> clinica) async {
    final db = await getDatabase();
    await db.insert('clinicas', clinica);
  }
}