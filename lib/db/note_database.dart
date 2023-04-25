import 'dart:convert';

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

    _database = await _initDB('notes.db');
    return _database!;
  }

  // this function will initiat the databse

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${NoteFields.id} $idType, 
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType
  )
''');
  }

  // Future<Database> _initDb(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   // this function will generate the database

//   Future _createDB(Database db, int version) async {
//     const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     const boolType = 'BOOLEAN NOT NULL';
//     const integerType = 'INTEGER NOT NULL';
//     const textType = 'TEXT NOT NULL';
//     await db.execute("""
//   CREATE TABLE $tableNotes(
//     ${NoteFields.id} $idType,
//     ${NoteFields.isImportant} $boolType,
//     ${NoteFields.number} $integerType,
//     ${NoteFields.titile} $textType,
//     ${NoteFields.description} $textType,
//     ${NoteFields.time} $textType,

//   )
// """);
//   }

  // this function create individual note

  Future<Note> create(Note note) async {
    final db = await instance.database;

    // final json = note.toJson();

    // if we want to write our own sql code
    // access the column

    // final columns =
    //     '${NoteFields.titile}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.titile]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';

    final id = await db.insert(tableNotes, note.toJson());

    return note.copy(id: id);
  }

//  this function help us to read individual Note from the db
  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      // ? prevent the sql injection
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Future<List<Note>> readAllNotes() async {
  //   final db = await instance.database;
  //   final orderBy = '${NoteFields.time} ASC';
  //   final results = await db.query(tableNotes, orderBy: orderBy);

  //   return results.map((json) => Note.fromJson(json)).toList();
  // }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${NoteFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
