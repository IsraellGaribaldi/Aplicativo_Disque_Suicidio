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
    FOREIGN KEY (id) REFERENCES clinicas(id)
    FOREIGN KEY (id) REFERENCES autonomos(id)
    ''');

    await db.execute('''
    CREATE TABLE clinicas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      endereco TEXT,
      horario TEXT,
      descricao TEXT,
      nota REAL,
      planos TEXT,
      lat REAL,
      long REAL
    )
  ''');

  await db.execute('''
    CREATE TABLE autonomos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      email TEXT,
      lat REAL,
      long REAL
    )
  ''');


    },
    );
    return _database!;
}


  static Future<void> inserirAluno(Usuario aluno) async {
    final db = await getDatabase();
    await db.insert('contas', aluno.toMap());
  }
  static Future<void> deletarAluno(int id) async {
    final db = await getDatabase();
    await db.delete('contas',where: 'id = ?',whereArgs: [id],);
  }
}
