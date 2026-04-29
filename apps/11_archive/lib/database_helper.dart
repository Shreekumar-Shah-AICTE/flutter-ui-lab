import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Note {
  int? id;
  String title;
  String content;
  int colorIndex;
  String updatedAt;

  Note({this.id, required this.title, required this.content, this.colorIndex = 0, String? updatedAt})
      : updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() => {
    'id': id, 'title': title, 'content': content,
    'colorIndex': colorIndex, 'updatedAt': updatedAt,
  };

  factory Note.fromMap(Map<String, dynamic> m) => Note(
    id: m['id'], title: m['title'], content: m['content'],
    colorIndex: m['colorIndex'], updatedAt: m['updatedAt'],
  );
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;
  DatabaseHelper._();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'archive.db');
    return openDatabase(path, version: 1, onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          colorIndex INTEGER DEFAULT 0,
          updatedAt TEXT NOT NULL
        )
      ''');
    });
  }

  Future<int> create(Note note) async {
    final db = await database;
    return db.insert('notes', note.toMap());
  }

  Future<List<Note>> readAll() async {
    final db = await database;
    final maps = await db.query('notes', orderBy: 'updatedAt DESC');
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<int> update(Note note) async {
    final db = await database;
    return db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> search(String query) async {
    final db = await database;
    final maps = await db.query('notes', where: 'title LIKE ? OR content LIKE ?', whereArgs: ['%$query%', '%$query%'], orderBy: 'updatedAt DESC');
    return maps.map((m) => Note.fromMap(m)).toList();
  }
}
