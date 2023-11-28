import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled3/note.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

class DatabaseHelper {

  static const _databaseName = "demo.db";
  static const _databaseVersion = 1;

  static const table = 'notes';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDescription = 'description';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // instantiate the database if unavailable
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database, creating if it doesn't exist
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
           CREATE TABLE $table (
             $columnId INTEGER PRIMARY KEY,
             $columnName TEXT NOT NULL,
             $columnDescription TEXT NOT NULL
           )
           ''');
  }

  // Insert a note into the database
  Future<int> insert(Note note) async {
    Database db = await instance.database;
    return await db.insert(table, note.toMap());
  }

  // Retrieve all notes from the database
  Future<List<Note>> getAllNotes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Retrieve all notes from the database
  Future<List<Note>> FindAllNotes(String query) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table,where: '$columnName = ?', whereArgs: [query]);
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Update a note in the database
  Future<int> update(Note note) async {
    Database db = await instance.database;
    return await db.update(table, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  // Delete a note from the database
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);

  }

  Future<User> fetchAlbum()  async{
    final response = await http
        .get(Uri.parse('http://192.168.1.115:5000/testapi/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}