import 'package:app_disque_suicidio/models/usuario_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'banco.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            telefone TEXT,
            dataNascimento TEXT,
            genero TEXT,
            senha TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE empresas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            lat REAL,
            long REAL,
            nome TEXT,
            email TEXT
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
            planos TEXT
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
            credenciais TEXT
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

        await _inserirDadosIniciais(db);
      },
    );
    return _database!;
  }

  static Future<void> _inserirDadosIniciais(Database db) async {
    final clinicaId = await db.insert('clinicas', {
      'nome': 'Clínica 1',
      'endereco': 'R. num sei oq, 67, bairro, cidade',
      'horario': 'Aberta as 08:00h - Fechada as 18:00h',
      'descricao': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'nota': 5.0,
      'lat': -7.1489,
      'long': -34.8466,
      'planos': 'Unimed,Geap,Hapvida',
    });

    final psicoId = await db.insert('autonomos', {
      'nome': 'Psicólogo 1',
      'especialidade': 'Psicologia',
      'endereco': 'R. num sei oq, 67, bairro, cidade',
      'horario': 'De seg a sex, 12:00h às 18:00h',
      'descricao': 'Psicólogo clínico com experiência em ansiedade e depressão.',
      'preco': 200.0,
      'nota': 4.5,
      'lat': -7.1489,
      'long': -34.8466,
      'planos': 'Unimed,Geap',
      'credenciais': 'Registro no CRP,Diploma em Psicologia',
    });

    final psiquiatraId = await db.insert('autonomos', {
      'nome': 'Psiquiatra 1',
      'especialidade': 'Psiquiatria',
      'endereco': 'R. inserir rua, 111, bairro, cidade',
      'horario': 'De ter a qui, 8:00h às 15:00h',
      'descricao': 'Psiquiatra especializado em transtornos do humor.',
      'preco': 500.0,
      'nota': 4.8,
      'lat': -7.1520,
      'long': -34.8490,
      'planos': 'Hapvida',
      'credenciais': 'Registro no CRM,Especialização em Psiquiatria',
    });

    await db.insert('clinica_profissionais', {
      'clinica_id': clinicaId,
      'autonomo_id': psicoId,
    });

    await db.insert('clinica_profissionais', {
      'clinica_id': clinicaId,
      'autonomo_id': psiquiatraId,
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
}