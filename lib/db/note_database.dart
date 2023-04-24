import 'package:local_storage/model/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../db/note_database.dart';

class NoteDatabase {
  // instance that besically calling the constractur
  static final NoteDatabase instance = NoteDatabase._init();

  static Database? _database;

// creating a private constractor
  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb('notes.db');
    return _database!;
  }

  // this function will initiat the databse

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // this function will generate the database

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
  CREATE TABLE $tableNotes(
    ${NoteFields.id} $idType,
    ${NoteFields.isImportant} $boolType,
    ${NoteFields.number} $integerType,
    ${NoteFields.titile} $textType,
    ${NoteFields.description} $textType,
    ${NoteFields.time} $textType,


  )
''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
